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
NSString * const KYAUserDefaultsKeyAllowDisplaySleep = @"info.marcel-dierkes.KeepingYouAwake.AllowDisplaySleep";
NSString * const KYAUserDefaultsKeyMenuBarIconHighlightDisabled = @"info.marcel-dierkes.KeepingYouAwake.MenuBarIconHighlightDisabled";
NSString * const KYAUserDefaultsKeyIsQuitOnTimerExpirationEnabled = @"info.marcel-dierkes.KeepingYouAwake.QuitOnTimerExpirationEnabled";

NSString * const KYAUserDefaultsKeyBatteryCapacityThresholdEnabled = @"info.marcel-dierkes.KeepingYouAwake.BatteryCapacityThresholdEnabled";
NSString * const KYAUserDefaultsKeyBatteryCapacityThreshold = @"info.marcel-dierkes.KeepingYouAwake.BatteryCapacityThreshold";
NSString * const KYAUserDefaultsKeyPreReleaseUpdatesEnabled = @"info.marcel-dierkes.KeepingYouAwake.PreReleaseUpdatesEnabled";

@implementation NSUserDefaults (Keys)
@dynamic kya_activateOnLaunch, kya_defaultTimeInterval, kya_notificationsEnabled;
@dynamic kya_allowDisplaySleep, kya_menuBarIconHighlightDisabled;
@dynamic kya_menuBarIconHighlightDisabled;
@dynamic kya_batteryCapacityThresholdEnabled, kya_batteryCapacityThreshold;
@dynamic kya_preReleaseUpdatesEnabled;
@dynamic kya_quitOnTimerExpirationEnabled;

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

#pragma mark - Allow Display Sleep

- (BOOL)kya_shouldAllowDisplaySleep
{
    return [self boolForKey:KYAUserDefaultsKeyAllowDisplaySleep];
}

- (void)setKya_allowDisplaySleep:(BOOL)allowDisplaySleep
{
    [self setBool:allowDisplaySleep forKey:KYAUserDefaultsKeyAllowDisplaySleep];
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

#pragma mark - Battery Capacity Threshold

- (BOOL)kya_isBatteryCapacityThresholdEnabled
{
    return [self boolForKey:KYAUserDefaultsKeyBatteryCapacityThresholdEnabled];
}

- (void)setKya_batteryCapacityThresholdEnabled:(BOOL)batteryCapacityThresholdEnabled
{
    [self setBool:batteryCapacityThresholdEnabled forKey:KYAUserDefaultsKeyBatteryCapacityThresholdEnabled];
}

- (CGFloat)kya_batteryCapacityThreshold
{
    CGFloat threshold = [self floatForKey:KYAUserDefaultsKeyBatteryCapacityThreshold];
    return MAX(10.0f , threshold);
}

- (void)setKya_batteryCapacityThreshold:(CGFloat)batteryCapacityThreshold
{
    [self setFloat:(float)batteryCapacityThreshold forKey:KYAUserDefaultsKeyBatteryCapacityThreshold];
}

#pragma mark - Pre-Release Updates Enabled

- (BOOL)kya_arePreReleaseUpdatesEnabled
{
    return [self boolForKey:KYAUserDefaultsKeyPreReleaseUpdatesEnabled];
}

- (void)setKya_preReleaseUpdatesEnabled:(BOOL)preReleaseUpdatesEnabled
{
    [self setBool:preReleaseUpdatesEnabled forKey:KYAUserDefaultsKeyPreReleaseUpdatesEnabled];
}

#pragma mark - Quit on Timer Expiration Enabled

- (BOOL)kya_isQuitOnTimerExpirationEnabled
{
    return [self boolForKey:KYAUserDefaultsKeyIsQuitOnTimerExpirationEnabled];
}

- (void)setKya_quitOnTimerExpirationEnabled:(BOOL)quitOnTimerExpirationEnabled
{
    [self setBool:quitOnTimerExpirationEnabled forKey:KYAUserDefaultsKeyIsQuitOnTimerExpirationEnabled];
}

@end
