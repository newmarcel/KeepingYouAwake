//
//  KYAAppController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 17.10.14.
//  Copyright (c) 2014 Marcel Dierkes. All rights reserved.
//

#import "KYAAppController.h"
#import "KYASleepWakeTimer.h"
#import "KYAEventHandler.h"
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
NSString * const KYASleepWakeControllerUserDefaultsTimeInterval = @"info.marcel-dierkes.KeepingYouAwake.TimeInterval";

@implementation KYAAppController

#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [self configureStatusItem];
        
        self.sleepWakeTimer = [KYASleepWakeTimer new];
        [self.sleepWakeTimer addObserver:self forKeyPath:@"scheduled" options:NSKeyValueObservingOptionNew context:NULL];
        
        // Check activate on launch state
        if([self shouldActivateOnLaunch])
        {
            [self activateTimer];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillFinishLaunching:)
                                                     name:NSApplicationWillFinishLaunchingNotification
                                                   object:nil
         ];
        
        [self configureEventHandler];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Check start at login state
    if([[NSApplication sharedApplication] kya_isStartingAtLogin])
    {
        self.startAtLoginMenuItem.state = NSOnState;
    }
    else
    {
        self.startAtLoginMenuItem.state = NSOffState;
    }
    
    [NSUserNotificationCenter defaultUserNotificationCenter].delegate = self;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([object isEqual:self.sleepWakeTimer] && [keyPath isEqualToString:@"scheduled"])
    {
        // Update the status item for scheduling changes
        [self setStatusItemActive:[change[NSKeyValueChangeNewKey] boolValue]];
    }
}

#pragma mark - Setup

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

#pragma mark - Default Time Interval
- (NSTimeInterval) defaultTimeInterval
{
	return [[NSUserDefaults standardUserDefaults] integerForKey:KYASleepWakeControllerUserDefaultsTimeInterval];
}

- (void) setDefaultTimeInterval: (NSTimeInterval) interval
{
	[[NSUserDefaults standardUserDefaults] setInteger:interval forKey:KYASleepWakeControllerUserDefaultsTimeInterval];
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
    {
        self.startAtLoginMenuItem.state = NSOnState;
    }
    else
    {
        self.startAtLoginMenuItem.state = NSOffState;
    }
}

#pragma mark - Toggle Handling

- (void)toggleStatus:(id)sender
{
    NSEvent *event = [[NSApplication sharedApplication] currentEvent];
    if((event.modifierFlags & NSControlKeyMask) || (event.type == NSRightMouseUp))
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
    [self activateTimerWithTimeInterval: self.defaultTimeInterval];
}

- (void)activateTimerWithTimeInterval:(NSTimeInterval)timeInterval
{
    // Do not allow negative time intervals
    if(timeInterval < 0)
    {
        return;
    }
    
    [self.sleepWakeTimer scheduleWithTimeInterval:timeInterval completion:^(BOOL cancelled) {
        // Post notifications
        if([[NSUserDefaults standardUserDefaults] boolForKey:KYASleepWakeControllerUserDefaultsKeyNotificationsEnabled])
        {
            NSUserNotification *n = [NSUserNotification new];
            n.informativeText = NSLocalizedString(@"Allowing your Mac to go to sleep…", nil);
            [[NSUserNotificationCenter defaultUserNotificationCenter] scheduleNotification:n];
        }
    }];
    
    // Post notifications
    if([[NSUserDefaults standardUserDefaults] boolForKey:KYASleepWakeControllerUserDefaultsKeyNotificationsEnabled])
    {
        NSUserNotification *n = [NSUserNotification new];
        
        if(timeInterval == KYASleepWakeTimeIntervalIndefinite)
        {
            n.informativeText = NSLocalizedString(@"Preventing your Mac from going to sleep…", nil);
        }
        else
        {
            NSDateComponentsFormatter *formatter = [self dateComponentsFormatter];
            formatter.includesTimeRemainingPhrase = NO;
            NSString *remainingTimeString = [formatter stringFromDate:[NSDate date] toDate:self.sleepWakeTimer.fireDate];
            formatter.includesTimeRemainingPhrase = YES;
            
            n.informativeText = [NSString stringWithFormat:NSLocalizedString(@"Preventing your Mac from going to sleep for\n%@…", nil), remainingTimeString];
        }
        
        [[NSUserNotificationCenter defaultUserNotificationCenter] scheduleNotification:n];
    }
}

- (void)terminateTimer
{
    [self.sleepWakeTimer invalidate];
}

#pragma mark - Menu Delegate

- (IBAction)selectTimeInterval:(NSMenuItem *)sender
{
    if([self.sleepWakeTimer isScheduled])
    {
        [self.sleepWakeTimer invalidate];
    }
	
	if (sender.alternate)
	{
		[self setDefaultTimeInterval: sender.tag];
	} else {
		
		__weak typeof(self) weakSelf = self;
		dispatch_async(dispatch_get_main_queue(), ^{
			NSTimeInterval seconds = (NSTimeInterval)[sender tag];
			[weakSelf activateTimerWithTimeInterval:seconds];
		});
	}
	
}

- (void)menuNeedsUpdate:(NSMenu *)menu
{
    if(![menu isEqual:self.timerMenu])
    {
        return;
    }
    
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
            item.hidden = YES;
            if(self.sleepWakeTimer.fireDate)
            {
                item.hidden = NO;
                item.title = [[self dateComponentsFormatter] stringFromDate:[NSDate date]
                                                                     toDate:self.sleepWakeTimer.fireDate
                              ];
            }
        }
    }
}

#pragma mark - Date Components Formatter

- (NSDateComponentsFormatter *)dateComponentsFormatter
{
    static NSDateComponentsFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDateComponentsFormatter new];
        dateFormatter.allowedUnits = NSCalendarUnitSecond|NSCalendarUnitMinute|NSCalendarUnitHour;
        dateFormatter.unitsStyle = NSDateComponentsFormatterUnitsStyleShort;
        dateFormatter.includesTimeRemainingPhrase = YES;
    });
    
    return dateFormatter;
}

#pragma mark - User Notification Center Delegate

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification
{
    return YES;
}

#pragma mark - Apple Event Manager

- (void)applicationWillFinishLaunching:(NSNotification *)notification
{
    [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self
                                                       andSelector:@selector(handleGetURLEvent:withReplyEvent:)
                                                     forEventClass:kInternetEventClass
                                                        andEventID:kAEGetURL
     ];
}


- (void)handleGetURLEvent:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)reply
{
    NSString *value = [event paramDescriptorForKeyword:keyDirectObject].stringValue;
    
    [[KYAEventHandler mainHandler] handleEventForURL:[NSURL URLWithString:value]];
}

- (void)configureEventHandler
{
    __weak typeof(self) weakSelf = self;
    [[KYAEventHandler mainHandler] registerActionNamed:@"activate" block:^(KYAEvent *event) {
        NSDictionary *parameters = event.arguments;
        NSString *seconds = parameters[@"seconds"];
        NSString *minutes = parameters[@"minutes"];
        NSString *hours = parameters[@"hours"];
        
        if([self.sleepWakeTimer isScheduled])
        {
            [self.sleepWakeTimer invalidate];
        }
        
        // Activate indefinitely if there are no parameters
        if(parameters.count == 0)
        {
            [weakSelf activateTimer];
        }
        else if(seconds)
        {
            [weakSelf activateTimerWithTimeInterval:(NSTimeInterval)ceil(seconds.doubleValue)];
        }
        else if(minutes)
        {
            [weakSelf activateTimerWithTimeInterval:(NSTimeInterval)KYA_MINUTES(ceil(minutes.doubleValue))];
        }
        else if(hours)
        {
            [weakSelf activateTimerWithTimeInterval:(NSTimeInterval)KYA_HOURS(ceil(hours.doubleValue))];
        }
    }];
    [[KYAEventHandler mainHandler] registerActionNamed:@"deactivate" block:^(KYAEvent *event) {
        [weakSelf terminateTimer];
    }];
}

@end
