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
    // Icon color for either slot may have changed — re-apply tint.
    self.appearance = self.currentAppearance;
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
    Auto defaults = NSUserDefaults.standardUserDefaults;

    if(appearance == KYAStatusItemAppearanceActive)
    {
        button.image = imageProvider.activeIconImage;
        button.toolTip = KYA_L10N_CLICK_TO_ALLOW_SLEEP;
        if(@available(macOS 10.14, *))
        {
            button.contentTintColor = [[self class] colorFromHexString:defaults.kya_menuBarActiveIconColor];
        }
    }
    else
    {
        button.image = imageProvider.inactiveIconImage;
        button.toolTip = KYA_L10N_CLICK_TO_PREVENT_SLEEP;
        if(@available(macOS 10.14, *))
        {
            button.contentTintColor = [[self class] colorFromHexString:defaults.kya_menuBarInactiveIconColor];
        }
        self.fireDate = nil;
        self.startDate = nil;
    }

    [self refreshTitleAndTimer];

    [self didChangeValueForKey:@"appearance"];
}

+ (nullable NSColor *)colorFromHexString:(nullable NSString *)hex
{
    if(hex.length == 0) { return nil; }

    NSString *trimmed = hex;
    if([trimmed hasPrefix:@"#"])
    {
        trimmed = [trimmed substringFromIndex:1];
    }
    if(trimmed.length != 6 && trimmed.length != 8) { return nil; }

    unsigned int value = 0;
    NSScanner *scanner = [NSScanner scannerWithString:trimmed];
    if(![scanner scanHexInt:&value]) { return nil; }

    CGFloat r, g, b, a = 1.0;
    if(trimmed.length == 6)
    {
        r = ((value >> 16) & 0xFF) / 255.0;
        g = ((value >> 8) & 0xFF) / 255.0;
        b = (value & 0xFF) / 255.0;
    }
    else
    {
        r = ((value >> 24) & 0xFF) / 255.0;
        g = ((value >> 16) & 0xFF) / 255.0;
        b = ((value >> 8) & 0xFF) / 255.0;
        a = (value & 0xFF) / 255.0;
    }
    return [NSColor colorWithSRGBRed:r green:g blue:b alpha:a];
}

#pragma mark - Remaining Time

- (void)setFireDate:(NSDate *)fireDate
{
    if(fireDate == _fireDate || [fireDate isEqualToDate:_fireDate]) { return; }
    _fireDate = [fireDate copy];
    [self refreshTitleAndTimer];
}

- (void)setStartDate:(NSDate *)startDate
{
    if(startDate == _startDate || [startDate isEqualToDate:_startDate]) { return; }
    _startDate = [startDate copy];
    [self refreshTitleAndTimer];
}

- (void)refreshTitleAndTimer
{
    Auto defaults = NSUserDefaults.standardUserDefaults;
    BOOL active = (self.currentAppearance == KYAStatusItemAppearanceActive);
    BOOL enabled = defaults.kya_isShowRemainingTimeInMenuBarEnabled;
    BOOL hasDate = (self.fireDate != nil) || (self.startDate != nil);

    if(active && enabled && hasDate)
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
    NSTimeInterval interval = 0;
    Auto fireDate = self.fireDate;
    if(fireDate != nil)
    {
        interval = [fireDate timeIntervalSinceNow];
        if(interval <= 0)
        {
            self.systemStatusItem.button.title = @"";
            [self stopRemainingTimeTimer];
            return;
        }
    }
    else
    {
        Auto startDate = self.startDate;
        if(startDate == nil)
        {
            self.systemStatusItem.button.title = @"";
            return;
        }
        interval = -[startDate timeIntervalSinceNow];
        if(interval < 0) { interval = 0; }
    }

    Auto defaults = NSUserDefaults.standardUserDefaults;
    KYARemainingTimeFormat format = defaults.kya_remainingTimeFormat;
    NSString *title = [[self class] formatRemaining:interval format:format];
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

    if([format isEqualToString:KYARemainingTimeFormatHoursMinutes])
    {
        NSUInteger roundedMinutes = minutes + (seconds >= 30 ? 1 : 0);
        NSUInteger carryHours = hours + (roundedMinutes >= 60 ? 1 : 0);
        NSUInteger finalMinutes = roundedMinutes % 60;
        return [NSString stringWithFormat:@"%lu:%02lu",
                (unsigned long)carryHours, (unsigned long)finalMinutes];
    }

    if([format isEqualToString:KYARemainingTimeFormatMinutes])
    {
        NSUInteger totalMinutes = (total + 59) / 60; // round up
        return [NSString stringWithFormat:@"%lum", (unsigned long)totalMinutes];
    }

    if([format isEqualToString:KYARemainingTimeFormatHours])
    {
        NSUInteger totalHours = (total + 3599) / 3600; // round up
        return [NSString stringWithFormat:@"%luh", (unsigned long)totalHours];
    }

    if([format isEqualToString:KYARemainingTimeFormatSeconds])
    {
        return [NSString stringWithFormat:@"%lus", (unsigned long)total];
    }

    if([format isEqualToString:KYARemainingTimeFormatVerbose])
    {
        NSMutableArray<NSString *> *parts = [NSMutableArray new];
        if(hours > 0)
        {
            [parts addObject:[NSString stringWithFormat:@"%lu %@",
                              (unsigned long)hours,
                              hours == 1 ? @"hour" : @"hours"]];
        }
        if(minutes > 0)
        {
            [parts addObject:[NSString stringWithFormat:@"%lu %@",
                              (unsigned long)minutes,
                              minutes == 1 ? @"minute" : @"minutes"]];
        }
        if(parts.count == 0)
        {
            [parts addObject:[NSString stringWithFormat:@"%lu %@",
                              (unsigned long)seconds,
                              seconds == 1 ? @"second" : @"seconds"]];
        }
        return [parts componentsJoinedByString:@" "];
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
