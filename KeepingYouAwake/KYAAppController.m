//
//  KYAAppController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 17.10.14.
//  Copyright (c) 2014 Marcel Dierkes. All rights reserved.
//

#import "KYAAppController.h"
#import "KYASleepWakeTimer.h"
#import "NSApplication+LoginItem.h"

@interface KYAAppController () <NSUserNotificationCenterDelegate>
@property (strong, nonatomic, readwrite) KYASleepWakeTimer *sleepWakeTimer;

// Status Item
@property (strong, nonatomic) NSStatusItem *statusItem;

// Menu
@property (weak, nonatomic) IBOutlet NSMenu *menu;
@property (weak, nonatomic) IBOutlet NSMenu *timerMenu;
@property (weak, nonatomic) IBOutlet NSMenuItem *startAtLoginMenuItem;
@end

NSString * const KYASleepWakeControllerUserDefaultsKeyActivateOnLaunch = @"info.marcel-dierkes.KeepingYouAwake.ActivateOnLaunch";
NSString * const KYASleepWakeControllerUserDefaultsKeyNotificationsEnabled = @"info.marcel-dierkes.KeepingYouAwake.NotificationsEnabled";

@implementation KYAAppController

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [self configureStatusItem];
        
        self.sleepWakeTimer = [KYASleepWakeTimer new];
        
        // Check activate on launch state
        if([self shouldActivateOnLaunch])
        {
            [self activateTimer];
        }
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Check start at login state
    if([[NSApplication sharedApplication] kya_isStartingAtLogin])
        self.startAtLoginMenuItem.state = NSOnState;
    else
        self.startAtLoginMenuItem.state = NSOffState;
    
    [NSUserNotificationCenter defaultUserNotificationCenter].delegate = self;
}

- (void)configureStatusItem
{
    NSStatusItem *statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    NSStatusBarButton *button = statusItem.button;
    
    button.target = self;
    button.action = @selector(toggleStatus:);
    
    [button sendActionOn:NSLeftMouseUpMask|NSRightMouseUpMask];
    
    self.statusItem = statusItem;
    [self setStatusItemActive:NO];
}

#pragma mark - Menu Handling

- (void)showMenu:(id)sender
{
    [self.statusItem popUpStatusItemMenu:self.menu];
}

#pragma mark - Activate on Launch

- (BOOL)shouldActivateOnLaunch
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:KYASleepWakeControllerUserDefaultsKeyActivateOnLaunch];
}

- (IBAction)toggleActivateOnLaunch:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = KYASleepWakeControllerUserDefaultsKeyActivateOnLaunch;
    
    BOOL activateOnLaunch = [defaults boolForKey:key];
    activateOnLaunch = !activateOnLaunch;
    [defaults setBool:activateOnLaunch forKey:key];
    [defaults synchronize];
}

#pragma mark - Start at Login

- (IBAction)toggleStartAtLogin:(id)sender
{
    BOOL shouldStartAtLogin = ![[NSApplication sharedApplication] kya_isStartingAtLogin];
    [NSApplication sharedApplication].kya_startAtLogin = shouldStartAtLogin;
    
    if(shouldStartAtLogin)
        self.startAtLoginMenuItem.state = NSOnState;
    else
        self.startAtLoginMenuItem.state = NSOffState;
}

#pragma mark - Toggle Handling

- (void)toggleStatus:(id)sender
{
    NSEvent *event = [[NSApplication sharedApplication] currentEvent];
    if(event.type == NSRightMouseUp)
    {
        [self showMenu:nil];
        return;
    }
    
    if([self.sleepWakeTimer isScheduled])
    {
        [self terminateTimer];
    }
    else
    {
        [self activateTimer];
    }
}

- (void)setStatusItemActive:(BOOL)active
{
    NSStatusBarButton *button = self.statusItem.button;
    if(active)
    {
        button.image = [NSImage imageNamed:@"ActiveIcon"];
        button.appearsDisabled = NO;
        button.toolTip = NSLocalizedString(@"Click to allow sleep\nRight click to show menu", nil);
    }
    else
    {
        button.image = [NSImage imageNamed:@"InactiveIcon"];
        button.appearsDisabled = YES;
        button.toolTip = NSLocalizedString(@"Click to prevent sleep\nRight click to show menu", nil);
    }
}

#pragma mark - Sleep Wake Timer Handling

- (void)activateTimer
{
    [self activateTimerWithTimeInterval:KYASleepWakeTimeIntervalIndefinite];
}

- (void)activateTimerWithTimeInterval:(NSTimeInterval)timeInterval
{
    [self setStatusItemActive:YES];
    
    __weak typeof(self) weakSelf = self;
    [self.sleepWakeTimer scheduleWithTimeInterval:timeInterval completion:^(BOOL cancelled) {
        [weakSelf setStatusItemActive:NO];
        
        // Post notifications
        if([[NSUserDefaults standardUserDefaults] boolForKey:KYASleepWakeControllerUserDefaultsKeyNotificationsEnabled])
        {
            NSUserNotification *n = [NSUserNotification new];
            n.informativeText = NSLocalizedString(@"Stopped preventing your Mac from sleeping…", nil);
            [[NSUserNotificationCenter defaultUserNotificationCenter] scheduleNotification:n];
        }
    }];
    
    // Post notifications
    if([[NSUserDefaults standardUserDefaults] boolForKey:KYASleepWakeControllerUserDefaultsKeyNotificationsEnabled])
    {
        NSUserNotification *n = [NSUserNotification new];
        
        if(timeInterval == KYASleepWakeTimeIntervalIndefinite)
            n.informativeText = NSLocalizedString(@"Preventing your Mac from sleeping…", nil);
        else
        {
            n.informativeText = [NSString stringWithFormat:NSLocalizedString(@"Started preventing your Mac from sleeping for %.0f seconds…", nil), timeInterval];
        }
        
        [[NSUserNotificationCenter defaultUserNotificationCenter] scheduleNotification:n];
    }
}

- (void)terminateTimer
{
    [self setStatusItemActive:NO];
    
    [self.sleepWakeTimer invalidate];
}

#pragma mark - Menu Delegate

- (IBAction)selectTimeInterval:(id)sender
{
    if([self.sleepWakeTimer isScheduled])
        [self.sleepWakeTimer invalidate];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSTimeInterval seconds = (NSTimeInterval)[sender tag];
        [weakSelf activateTimerWithTimeInterval:seconds];
    });
}

- (void)menuNeedsUpdate:(NSMenu *)menu
{
    if(![menu isEqual:self.timerMenu])
        return;
    
    for(NSMenuItem *item in menu.itemArray)
    {
        item.state = NSOffState;
        
        NSTimeInterval seconds = (NSTimeInterval)item.tag;
        if(seconds > 0)
        {
            if(self.sleepWakeTimer.scheduledTimeInterval == seconds)
            {
                item.state = NSOnState;
            }
        }
        else if((seconds == 0) && ![item isSeparatorItem])
        {
            item.state = NSOffState;
            if([self.sleepWakeTimer isScheduled] && (self.sleepWakeTimer.scheduledTimeInterval == KYASleepWakeTimeIntervalIndefinite))
                item.state = NSOnState;
        }
        else
        {
            // The display menu item
            static NSDateComponentsFormatter *dateFormatter;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                dateFormatter = [NSDateComponentsFormatter new];
                dateFormatter.allowedUnits = NSCalendarUnitSecond|NSCalendarUnitMinute|NSCalendarUnitHour;
                dateFormatter.unitsStyle = NSDateComponentsFormatterUnitsStyleShort;
                dateFormatter.includesTimeRemainingPhrase = YES;
            });
            
            item.hidden = YES;
            if(self.sleepWakeTimer.fireDate)
            {
                item.hidden = NO;
                item.title = [dateFormatter stringFromDate:[NSDate date] toDate:self.sleepWakeTimer.fireDate];
            }
        }
    }
}

#pragma mark - User Notification Center Delegate

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification
{
    return YES;
}

@end
