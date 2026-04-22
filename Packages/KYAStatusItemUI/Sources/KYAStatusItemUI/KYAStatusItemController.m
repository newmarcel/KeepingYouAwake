//
//  KYAStatusItemController.m
//  KYAStatusItemUI
//
//  Created by Marcel Dierkes on 10.09.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import <KYAStatusItemUI/KYAStatusItemController.h>
#import <KYACommon/KYACommon.h>
#import <KYAStatusItemUI/KYAStatusItemImageProvider.h>
#import <KYAApplicationSupport/NSUserDefaults+KYAKeys.h>
#import "KYAStatusItemUILocalizedStrings.h"

@interface KYAStatusItemController ()
@property (nonatomic, readwrite) NSStatusItem *systemStatusItem;
@property (nonatomic) KYAStatusItemAppearance currentAppearance;
@property (nonatomic, nullable) NSTimer *remainingTimeTimer;
@end

@implementation KYAStatusItemController

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [self configureStatusItem];
        Auto center = NSNotificationCenter.defaultCenter;
        [center addObserver:self
                   selector:@selector(imageProviderDidChange:)
                       name:KYAStatusItemImageProviderDidChangeNotification
                     object:nil];
        [center addObserver:self
                   selector:@selector(defaultsDidChange:)
                       name:NSUserDefaultsDidChangeNotification
                     object:nil];
    }
    return self;
}

- (void)dealloc
{
    [self stopRemainingTimeTimer];
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)imageProviderDidChange:(NSNotification *)notification
{
    // Reapply current appearance so the button picks up the fresh images.
    self.appearance = self.appearance;
}

- (void)defaultsDidChange:(NSNotification *)notification
{
    // Remaining-time toggle/format may have changed — re-render.
    [self refreshTitleAndTimer];
}

#pragma mark - Configuration

- (void)configureStatusItem
{
    Auto statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    statusItem.highlightMode = ![NSUserDefaults standardUserDefaults].kya_menuBarIconHighlightDisabled;
    if([statusItem respondsToSelector:@selector(behavior)])
    {
        statusItem.behavior = NSStatusItemBehaviorTerminationOnRemoval;
    }
    if([statusItem respondsToSelector:@selector(isVisible)])
    {
        statusItem.visible = YES;
    }

    Auto button = statusItem.button;

    [button sendActionOn:NSEventMaskLeftMouseUp|NSEventMaskRightMouseUp];
    button.target = self;
    button.action = @selector(toggleStatus:);
    button.imagePosition = NSImageLeft;

#if DEBUG
    if(@available(macOS 10.14, *))
    {
        button.contentTintColor = NSColor.systemBlueColor;
    }
    Auto log = KYALogCreateWithCategory("StatusItemUI");
    os_log_debug(log, "Blue status bar item color is enabled for DEBUG builds.");
#endif

    self.systemStatusItem = statusItem;
    self.appearance = KYAStatusItemAppearanceInactive;
}

- (void)toggleStatus:(id)sender
{
    Auto delegate = self.delegate;
    Auto event = NSApplication.sharedApplication.currentEvent;

    if((event.modifierFlags & NSEventModifierFlagControl)   // ctrl click
       || (event.modifierFlags & NSEventModifierFlagOption) // alt click
       || (event.type == NSEventTypeRightMouseUp))          // right click
    {
        [self showMenuFromDataSource];
        return;
    }

    if([delegate respondsToSelector:@selector(statusItemControllerShouldPerformPrimaryAction:)])
    {
        [delegate statusItemControllerShouldPerformPrimaryAction:self];
    }
}

#pragma mark - Appearance

- (KYAStatusItemAppearance)appearance
{
    return self.currentAppearance;
}

- (void)setAppearance:(KYAStatusItemAppearance)appearance
{
    [self willChangeValueForKey:@"appearance"];

    self.currentAppearance = appearance;

    Auto button = self.systemStatusItem.button;
    Auto imageProvider = KYAStatusItemImageProvider.currentProvider;

    if(appearance == KYAStatusItemAppearanceActive)
    {
        button.image = imageProvider.activeIconImage;
        button.toolTip = KYA_L10N_CLICK_TO_ALLOW_SLEEP;
    }
    else
    {
        button.image = imageProvider.inactiveIconImage;
        button.toolTip = KYA_L10N_CLICK_TO_PREVENT_SLEEP;
        self.fireDate = nil;
    }

    [self refreshTitleAndTimer];

    [self didChangeValueForKey:@"appearance"];
}

#pragma mark - Remaining Time

- (void)setFireDate:(NSDate *)fireDate
{
    if(fireDate == _fireDate || [fireDate isEqualToDate:_fireDate]) { return; }
    _fireDate = [fireDate copy];
    [self refreshTitleAndTimer];
}

- (void)refreshTitleAndTimer
{
    Auto defaults = NSUserDefaults.standardUserDefaults;
    BOOL active = (self.currentAppearance == KYAStatusItemAppearanceActive);
    BOOL enabled = defaults.kya_isShowRemainingTimeInMenuBarEnabled;
    BOOL hasFireDate = (self.fireDate != nil);

    if(active && enabled && hasFireDate)
    {
        [self updateRemainingTimeTitle];
        [self startRemainingTimeTimerIfNeeded];
    }
    else
    {
        [self stopRemainingTimeTimer];
        self.systemStatusItem.button.title = @"";
    }
}

- (void)startRemainingTimeTimerIfNeeded
{
    if(self.remainingTimeTimer.isValid) { return; }
    AutoWeak weakSelf = self;
    Auto timer = [NSTimer timerWithTimeInterval:1.0
                                        repeats:YES
                                          block:^(NSTimer * _Nonnull t) {
        [weakSelf updateRemainingTimeTitle];
    }];
    timer.tolerance = 0.25;
    [NSRunLoop.mainRunLoop addTimer:timer forMode:NSRunLoopCommonModes];
    self.remainingTimeTimer = timer;
}

- (void)stopRemainingTimeTimer
{
    [self.remainingTimeTimer invalidate];
    self.remainingTimeTimer = nil;
}

- (void)updateRemainingTimeTitle
{
    Auto fireDate = self.fireDate;
    if(fireDate == nil)
    {
        self.systemStatusItem.button.title = @"";
        return;
    }

    NSTimeInterval remaining = [fireDate timeIntervalSinceNow];
    if(remaining <= 0)
    {
        self.systemStatusItem.button.title = @"";
        [self stopRemainingTimeTimer];
        return;
    }

    Auto defaults = NSUserDefaults.standardUserDefaults;
    KYARemainingTimeFormat format = defaults.kya_remainingTimeFormat;
    NSString *title = [[self class] formatRemaining:remaining format:format];
    self.systemStatusItem.button.title = [NSString stringWithFormat:@" %@", title];
}

+ (NSString *)formatRemaining:(NSTimeInterval)remaining format:(KYARemainingTimeFormat)format
{
    NSUInteger total = (NSUInteger)ceil(remaining);
    NSUInteger hours = total / 3600;
    NSUInteger minutes = (total % 3600) / 60;
    NSUInteger seconds = total % 60;

    if([format isEqualToString:KYARemainingTimeFormatDigital])
    {
        if(hours > 0)
        {
            return [NSString stringWithFormat:@"%lu:%02lu:%02lu",
                    (unsigned long)hours, (unsigned long)minutes, (unsigned long)seconds];
        }
        return [NSString stringWithFormat:@"%lu:%02lu",
                (unsigned long)minutes, (unsigned long)seconds];
    }

    if([format isEqualToString:KYARemainingTimeFormatMinutes])
    {
        NSUInteger totalMinutes = (total + 59) / 60; // round up
        return [NSString stringWithFormat:@"%lum", (unsigned long)totalMinutes];
    }

    // Compact (default): "2h 30m", "45m", "30s"
    if(hours > 0)
    {
        if(minutes > 0)
        {
            return [NSString stringWithFormat:@"%luh %lum",
                    (unsigned long)hours, (unsigned long)minutes];
        }
        return [NSString stringWithFormat:@"%luh", (unsigned long)hours];
    }
    if(minutes > 0)
    {
        return [NSString stringWithFormat:@"%lum", (unsigned long)minutes];
    }
    return [NSString stringWithFormat:@"%lus", (unsigned long)seconds];
}

#pragma mark - Menu

- (void)showMenuFromDataSource
{
    Auto dataSource = self.dataSource;
    if([dataSource respondsToSelector:@selector(menuForStatusItemController:)])
    {
        Auto menu = [dataSource menuForStatusItemController:self];
        if(menu != nil)
        {
            [self.systemStatusItem popUpStatusItemMenu:menu];
        }
    }
}

@end
