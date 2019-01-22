//
//  KYAAppController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 17.10.14.
//  Copyright (c) 2014 Marcel Dierkes. All rights reserved.
//

#import "KYAAppController.h"
#import "KYADefines.h"
#import "KYASleepWakeTimer.h"
#import "KYAStatusItemController.h"
#import "KYAEventHandler.h"
#import "KYABatteryStatus.h"
#import "KYABatteryCapacityThreshold.h"
#import "NSUserDefaults+Keys.h"

@interface KYAAppController () <NSUserNotificationCenterDelegate, KYAStatusItemControllerDelegate>
@property (nonatomic, readwrite) KYASleepWakeTimer *sleepWakeTimer;
@property (nonatomic, readwrite) KYAStatusItemController *statusItemController;

// Battery Status
@property (nonatomic) KYABatteryStatus *batteryStatus;
@property (nonatomic, getter=isBatteryOverrideEnabled) BOOL batteryOverrideEnabled;

// Menu
@property (weak, nonatomic) IBOutlet NSMenu *menu;
@property (weak, nonatomic) IBOutlet NSMenu *timerMenu;
@end

@implementation KYAAppController

#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.sleepWakeTimer = [KYASleepWakeTimer new];
        [self.sleepWakeTimer addObserver:self forKeyPath:@"scheduled" options:NSKeyValueObservingOptionNew context:NULL];
        
        self.statusItemController = [KYAStatusItemController new];
        self.statusItemController.delegate = self;
        
        // Check activate on launch state
        if([self shouldActivateOnLaunch])
        {
            [self activateTimer];
        }
        
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(applicationWillFinishLaunching:)
                                                   name:NSApplicationWillFinishLaunchingNotification
                                                 object:nil
         ];
        
        [self configureBatteryStatus];
        [self configureEventHandler];
        [self configureScreenLockEvents];
    }
    return self;
}

- (void)dealloc
{
    NSNotificationCenter *center = NSNotificationCenter.defaultCenter;
    [center removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    [center removeObserver:self name:kKYABatteryCapacityThresholdDidChangeNotification object:nil];
    
    
    NSDistributedNotificationCenter *distCenter = [NSDistributedNotificationCenter defaultCenter];
    [distCenter removeObserver:self name:@"com.apple.screenIsLocked" object:nil];
    [distCenter removeObserver:self name:@"com.apple.screenIsUnlocked" object:nil];
}

- (void)configureScreenLockEvents
{
    NSDistributedNotificationCenter *center = [NSDistributedNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(screenLocked)
                   name:@"com.apple.screenIsLocked"
                 object:nil];
    
    [center addObserver:self
               selector:@selector(screenUnlocked)
                   name:@"com.apple.screenIsUnlocked"
                 object:nil];
}

- (void) screenLocked
{
    if(![NSUserDefaults.standardUserDefaults kya_disableWhenScreenLockedEnabled])
    {
        return
    }
    // if active, disable & store state
    
}

- (void) screenUnlocked
{
    if(![NSUserDefaults.standardUserDefaults kya_disableWhenScreenLockedEnabled])
    {
        return
    }
    
    // if was active, restore state
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    NSUserNotificationCenter.defaultUserNotificationCenter.delegate = self;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([object isEqual:self.sleepWakeTimer] && [keyPath isEqualToString:@"scheduled"])
    {
        // Update the status item for scheduling changes
        BOOL active = [change[NSKeyValueChangeNewKey] boolValue];
        self.statusItemController.activeAppearanceEnabled = active;
    }
}

#pragma mark - Default Time Interval

- (NSTimeInterval)defaultTimeInterval
{
    return NSUserDefaults.standardUserDefaults.kya_defaultTimeInterval;
}

- (void)setDefaultTimeInterval:(NSTimeInterval)interval
{
    NSUserDefaults.standardUserDefaults.kya_defaultTimeInterval = interval;
}

#pragma mark - Activate on Launch

- (BOOL)shouldActivateOnLaunch
{
    return [NSUserDefaults.standardUserDefaults kya_isActivatedOnLaunch];
}

- (IBAction)toggleActivateOnLaunch:(id)sender
{
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    defaults.kya_activateOnLaunch = ![defaults kya_isActivatedOnLaunch];
    [defaults synchronize];
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
    
    // Check battery overrides and register for capacity changes.
    [self checkAndEnableBatteryOverride];
    if([NSUserDefaults.standardUserDefaults kya_isBatteryCapacityThresholdEnabled])
    {
        [self.batteryStatus registerForCapacityChangesIfNeeded];
    }
    
    [self.sleepWakeTimer scheduleWithTimeInterval:timeInterval completion:^(BOOL cancelled) {
        // Post notifications
        if([NSUserDefaults.standardUserDefaults kya_areNotificationsEnabled])
        {
            NSUserNotification *n = [NSUserNotification new];
            n.informativeText = NSLocalizedString(@"Allowing your Mac to go to sleep…", @"Allowing your Mac to go to sleep…");
            [NSUserNotificationCenter.defaultUserNotificationCenter scheduleNotification:n];
        }
    }];
    
    // Post notifications
    if([NSUserDefaults.standardUserDefaults kya_areNotificationsEnabled])
    {
        NSUserNotification *n = [NSUserNotification new];
        
        if(timeInterval == KYASleepWakeTimeIntervalIndefinite)
        {
            n.informativeText = NSLocalizedString(@"Preventing your Mac from going to sleep…", @"Preventing your Mac from going to sleep…");
        }
        else
        {
            NSDateComponentsFormatter *formatter = [self dateComponentsFormatter];
            formatter.includesTimeRemainingPhrase = NO;
            NSString *remainingTimeString = [formatter stringFromDate:[NSDate date] toDate:self.sleepWakeTimer.fireDate];
            formatter.includesTimeRemainingPhrase = YES;
            
            n.informativeText = [NSString stringWithFormat:NSLocalizedString(@"Preventing your Mac from going to sleep for\n%@…", @"Preventing your Mac from going to sleep for\n%@…"), remainingTimeString];
        }
        
        [NSUserNotificationCenter.defaultUserNotificationCenter scheduleNotification:n];
    }
}

- (void)terminateTimer
{
    [self disableBatteryOverride];
    [self.batteryStatus unregisterFromCapacityChanges];
    
    if([self.sleepWakeTimer isScheduled])
    {
        [self.sleepWakeTimer invalidate];
    }
}

#pragma mark - Menu Delegate

- (IBAction)selectTimeInterval:(NSMenuItem *)sender
{
    [self terminateTimer];
	
	if (sender.alternate)
	{
		[self setDefaultTimeInterval: sender.tag];
	}
	else
	{
        KYA_WEAK weakSelf = self;
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

#pragma mark - Battery Status

- (KYABatteryStatus *)batteryStatus
{
    if(_batteryStatus == nil)
    {
        _batteryStatus = [KYABatteryStatus new];
        
        KYA_WEAK weakSelf = self;
        _batteryStatus.capacityChangeHandler = ^(CGFloat capacity) {
            [weakSelf batteryCapacityDidChange:capacity];
        };
    }
    return _batteryStatus;
}

- (void)configureBatteryStatus
{
    if(![self.batteryStatus isBatteryStatusAvailable])
    {
        return;
    }
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(batteryCapacityThresholdDidChange:)
                                               name:kKYABatteryCapacityThresholdDidChangeNotification
                                             object:nil
     ];
    
    // Start receiving battery status changes
    if([NSUserDefaults.standardUserDefaults kya_isBatteryCapacityThresholdEnabled])
    {
        [self.batteryStatus registerForCapacityChangesIfNeeded];
    }
}

- (void)checkAndEnableBatteryOverride
{
    CGFloat currentCapacity = self.batteryStatus.currentCapacity;
    CGFloat threshold = NSUserDefaults.standardUserDefaults.kya_batteryCapacityThreshold;
    
    self.batteryOverrideEnabled = (currentCapacity <= threshold);
}

- (void)disableBatteryOverride
{
    self.batteryOverrideEnabled = NO;
}

- (void)batteryCapacityDidChange:(CGFloat)capacity
{
    CGFloat threshold = NSUserDefaults.standardUserDefaults.kya_batteryCapacityThreshold;
    if([self.sleepWakeTimer isScheduled] && (capacity <= threshold) && ![self isBatteryOverrideEnabled])
    {
        [self terminateTimer];
    }
}

#pragma mark - Battery Capacity Threshold Changes

- (void)batteryCapacityThresholdDidChange:(NSNotification *)notification
{
    if(![self.batteryStatus isBatteryStatusAvailable])
    {
        return;
    }
    
    [self terminateTimer];
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
    
    [KYAEventHandler.defaultHandler handleEventForURL:[NSURL URLWithString:value]];
}

- (void)configureEventHandler
{
    KYA_WEAK weakSelf = self;
    [KYAEventHandler.defaultHandler registerActionNamed:@"activate" block:^(KYAEvent *event) {
        typeof(self) strongSelf = weakSelf;
        
        NSDictionary *parameters = event.arguments;
        NSString *seconds = parameters[@"seconds"];
        NSString *minutes = parameters[@"minutes"];
        NSString *hours = parameters[@"hours"];
        
        [strongSelf terminateTimer];
        
        // Activate indefinitely if there are no parameters
        if(parameters.count == 0)
        {
            [strongSelf activateTimer];
        }
        else if(seconds)
        {
            [strongSelf activateTimerWithTimeInterval:(NSTimeInterval)ceil(seconds.doubleValue)];
        }
        else if(minutes)
        {
            [strongSelf activateTimerWithTimeInterval:(NSTimeInterval)KYA_MINUTES(ceil(minutes.doubleValue))];
        }
        else if(hours)
        {
            [strongSelf activateTimerWithTimeInterval:(NSTimeInterval)KYA_HOURS(ceil(hours.doubleValue))];
        }
    }];
    
    [KYAEventHandler.defaultHandler registerActionNamed:@"deactivate" block:^(KYAEvent *event) {
        [weakSelf terminateTimer];
    }];
    
    [KYAEventHandler.defaultHandler registerActionNamed:@"toggle" block:^(KYAEvent *event) {
        [weakSelf.statusItemController toggle];
    }];
}

#pragma mark - KYAStatusItemControllerDelegate

- (void)statusItemControllerShouldPerformMainAction:(KYAStatusItemController *)controller
{
    if([self.sleepWakeTimer isScheduled])
    {
        [self terminateTimer];
    }
    else
    {
        [self activateTimer];
    }
}

- (void)statusItemControllerShouldPerformAlternativeAction:(KYAStatusItemController *)controller
{
    [self.statusItemController showMenu:self.menu];
}

@end
