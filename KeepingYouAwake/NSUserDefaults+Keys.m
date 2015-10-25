//
//  NSUserDefaults+Keys.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 25.10.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import "NSUserDefaults+Keys.h"

// User Default Keys
NSString * const KYAUserDefaultsKeyActivateOnLaunch = @"info.marcel-dierkes.KeepingYouAwake.ActivateOnLaunch";
NSString * const KYAUserDefaultsKeyNotificationsEnabled = @"info.marcel-dierkes.KeepingYouAwake.NotificationsEnabled";
NSString * const KYAUserDefaultsKeyDefaultTimeInterval = @"info.marcel-dierkes.KeepingYouAwake.TimeInterval";
NSString * const KYAUserDefaultsKeyPreventSleepOnACPower = @"info.marcel-dierkes.KeepingYouAwake.PreventSleepOnACPower";
NSString * const KYAUserDefaultsKeyMenuBarIconHighlightDisabled = @"info.marcel-dierkes.KeepingYouAwake.MenuBarIconHighlightDisabled";


@implementation NSUserDefaults (Keys)
@dynamic kya_activateOnLaunch, kya_defaultTimeInterval, kya_notificationsEnabled;
@dynamic kya_preventSleepOnACPower, kya_menuBarIconHighlightDisabled;

#pragma mark - Activate on Launch

- (BOOL)kya_isActivatedOnLaunch
{
    return [self boolForKey:KYAUserDefaultsKeyActivateOnLaunch];
}

- (void)setKya_activateOnLaunch:(BOOL)activateOnLaunch
{
    [self setBool:activateOnLaunch forKey:KYAUserDefaultsKeyActivateOnLaunch];
}

#pragma mark - Notifications Enabled

- (BOOL)kya_areNotificationsEnabled
{
    return [self boolForKey:KYAUserDefaultsKeyNotificationsEnabled];
}

- (void)setKya_notificationsEnabled:(BOOL)notificationsEnabled
{
    [self setBool:notificationsEnabled forKey:KYAUserDefaultsKeyNotificationsEnabled];
}

#pragma mark - Default Time Interval

- (NSTimeInterval)kya_defaultTimeInterval
{
    return (NSTimeInterval)[self integerForKey:KYAUserDefaultsKeyDefaultTimeInterval];
}

- (void)setKya_defaultTimeInterval:(NSTimeInterval)defaultTimeInterval
{
    [self setInteger:(NSInteger)defaultTimeInterval forKey:KYAUserDefaultsKeyDefaultTimeInterval];  // decimal places will be cut-off
}

#pragma mark - Prevent Sleep On AC Power

- (BOOL)kya_isPreventingSleepOnACPower
{
    return [self boolForKey:KYAUserDefaultsKeyPreventSleepOnACPower];
}

- (void)setKya_preventSleepOnACPower:(BOOL)preventSleepOnACPower
{
    [self setBool:preventSleepOnACPower forKey:KYAUserDefaultsKeyPreventSleepOnACPower];
}

#pragma mark - Menu Bar Icon Highlight Disabled

- (BOOL)kya_isMenuBarIconHighlightDisabled
{
    return [self boolForKey:KYAUserDefaultsKeyMenuBarIconHighlightDisabled];
}

- (void)setKya_menuBarIconHighlightDisabled:(BOOL)menuBarIconHighlightDisabled
{
    [self setBool:menuBarIconHighlightDisabled forKey:KYAUserDefaultsKeyMenuBarIconHighlightDisabled];
}

@end
