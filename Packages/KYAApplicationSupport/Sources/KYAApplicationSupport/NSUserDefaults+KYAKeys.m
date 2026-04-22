//
//  NSUserDefaults+KYAKeys.m
//  KYAApplicationSupport
//
//  Created by Marcel Dierkes on 25.10.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import <KYAApplicationSupport/NSUserDefaults+KYAKeys.h>
#import <KYACommon/KYACommon.h>

// A macro to define a new user defaults convenience property for BOOL values.
// - _short_getter_name represents the name of the getter,
//                      e.g. `isSomethingEnabled` without the `kya_` prefix.
// - _property_name represents the name of the property and the setter,
//                      e.g. `somethingEnabled` without the `kya_` prefix.
// - _short_defaults_key represents a user defaults key,
//                      e.g. `SomethingEnabled` without any prefixes
//
// These values will generate the implementation for a property
// e.g. `@property (nonatomic, getter=kya_isSomethingEnabled) BOOL kya_somethingEnabled;`
// and for a user defaults key constant
// e.g. `KYA_EXPORT NSString * const KYAUserDefaultsKeySomethingEnabled;`
// which will create an actual string key in the pre-defined format
// e.g. `info.marcel-dierkes.KeepingYouAwake.SomethingEnabled`
#define KYA_GENERATE_BOOL_PROPERTY(_short_getter_name, _property_name, _short_defaults_key) \
NSString * const KYAUserDefaultsKey##_short_defaults_key =                                  \
    @"info.marcel-dierkes.KeepingYouAwake." #_short_defaults_key;                           \
                                                                                            \
- (BOOL)kya_##_short_getter_name                                                            \
{                                                                                           \
    return [self boolForKey:KYAUserDefaultsKey##_short_defaults_key];                       \
}                                                                                           \
- (void)setKya_##_property_name:(BOOL)enabled                                               \
{                                                                                           \
    [self setBool:enabled forKey:KYAUserDefaultsKey##_short_defaults_key];                  \
}

@implementation NSUserDefaults (KYAKeys)

KYA_GENERATE_BOOL_PROPERTY(isActivatedOnLaunch,
                           activateOnLaunch,
                           ActivateOnLaunch);

KYA_GENERATE_BOOL_PROPERTY(shouldAllowDisplaySleep,
                           allowDisplaySleep,
                           AllowDisplaySleep);

KYA_GENERATE_BOOL_PROPERTY(isMenuBarIconHighlightDisabled,
                           menuBarIconHighlightDisabled,
                           MenuBarIconHighlightDisabled);

KYA_GENERATE_BOOL_PROPERTY(arePreReleaseUpdatesEnabled,
                           preReleaseUpdatesEnabled,
                           PreReleaseUpdatesEnabled);

KYA_GENERATE_BOOL_PROPERTY(isQuitOnTimerExpirationEnabled,
                           quitOnTimerExpirationEnabled,
                           IsQuitOnTimerExpirationEnabled);

KYA_GENERATE_BOOL_PROPERTY(isActivateOnExternalDisplayConnectedEnabled,
                           activateOnExternalDisplayConnectedEnabled,
                           ActivateOnExternalDisplayConnectedEnabled);


KYA_GENERATE_BOOL_PROPERTY(isDeactivateOnUserSwitchEnabled,
                           deactivateOnUserSwitchEnabled,
                           DeactivateOnUserSwitchEnabled);

KYA_GENERATE_BOOL_PROPERTY(isBatteryCapacityThresholdEnabled,
                           batteryCapacityThresholdEnabled,
                           BatteryCapacityThresholdEnabled);

KYA_GENERATE_BOOL_PROPERTY(isLowPowerModeMonitoringEnabled,
                           lowPowerModeMonitoringEnabled,
                           LowPowerModeMonitoringEnabled);

#pragma mark - Battery Capacity Threshold

NSString * const KYAUserDefaultsKeyBatteryCapacityThreshold = @"info.marcel-dierkes.KeepingYouAwake.BatteryCapacityThreshold";

- (CGFloat)kya_batteryCapacityThreshold
{
    CGFloat threshold = [self floatForKey:KYAUserDefaultsKeyBatteryCapacityThreshold];
    return MAX(10.0f , threshold);
}

- (void)setKya_batteryCapacityThreshold:(CGFloat)batteryCapacityThreshold
{
    [self setFloat:(float)batteryCapacityThreshold forKey:KYAUserDefaultsKeyBatteryCapacityThreshold];
}

#pragma mark - Menu Bar Icon Styles

NSString * const KYAUserDefaultsKeyMenuBarActiveIconStyle = @"info.marcel-dierkes.KeepingYouAwake.MenuBarActiveIconStyle";
NSString * const KYAUserDefaultsKeyMenuBarInactiveIconStyle = @"info.marcel-dierkes.KeepingYouAwake.MenuBarInactiveIconStyle";
NSString * const KYAUserDefaultsKeyMenuBarActiveCustomIconFile = @"info.marcel-dierkes.KeepingYouAwake.MenuBarActiveCustomIconFile";
NSString * const KYAUserDefaultsKeyMenuBarInactiveCustomIconFile = @"info.marcel-dierkes.KeepingYouAwake.MenuBarInactiveCustomIconFile";
NSString * const KYAUserDefaultsKeyShowRemainingTimeInMenuBar = @"info.marcel-dierkes.KeepingYouAwake.ShowRemainingTimeInMenuBar";
NSString * const KYAUserDefaultsKeyRemainingTimeFormat = @"info.marcel-dierkes.KeepingYouAwake.RemainingTimeFormat";

KYARemainingTimeFormat const KYARemainingTimeFormatCompact = @"compact";
KYARemainingTimeFormat const KYARemainingTimeFormatDigital = @"digital";
KYARemainingTimeFormat const KYARemainingTimeFormatMinutes = @"minutes";

- (NSString *)kya_menuBarActiveIconStyle
{
    return [self stringForKey:KYAUserDefaultsKeyMenuBarActiveIconStyle];
}

- (void)setKya_menuBarActiveIconStyle:(NSString *)kya_menuBarActiveIconStyle
{
    [self setObject:kya_menuBarActiveIconStyle forKey:KYAUserDefaultsKeyMenuBarActiveIconStyle];
}

- (NSString *)kya_menuBarInactiveIconStyle
{
    return [self stringForKey:KYAUserDefaultsKeyMenuBarInactiveIconStyle];
}

- (void)setKya_menuBarInactiveIconStyle:(NSString *)kya_menuBarInactiveIconStyle
{
    [self setObject:kya_menuBarInactiveIconStyle forKey:KYAUserDefaultsKeyMenuBarInactiveIconStyle];
}

- (NSString *)kya_menuBarActiveCustomIconFile
{
    return [self stringForKey:KYAUserDefaultsKeyMenuBarActiveCustomIconFile];
}

- (void)setKya_menuBarActiveCustomIconFile:(NSString *)filename
{
    if(filename.length == 0)
    {
        [self removeObjectForKey:KYAUserDefaultsKeyMenuBarActiveCustomIconFile];
    }
    else
    {
        [self setObject:filename forKey:KYAUserDefaultsKeyMenuBarActiveCustomIconFile];
    }
}

- (NSString *)kya_menuBarInactiveCustomIconFile
{
    return [self stringForKey:KYAUserDefaultsKeyMenuBarInactiveCustomIconFile];
}

- (void)setKya_menuBarInactiveCustomIconFile:(NSString *)filename
{
    if(filename.length == 0)
    {
        [self removeObjectForKey:KYAUserDefaultsKeyMenuBarInactiveCustomIconFile];
    }
    else
    {
        [self setObject:filename forKey:KYAUserDefaultsKeyMenuBarInactiveCustomIconFile];
    }
}

#pragma mark - Remaining Time Display

- (BOOL)kya_isShowRemainingTimeInMenuBarEnabled
{
    return [self boolForKey:KYAUserDefaultsKeyShowRemainingTimeInMenuBar];
}

- (void)setKya_showRemainingTimeInMenuBar:(BOOL)enabled
{
    [self setBool:enabled forKey:KYAUserDefaultsKeyShowRemainingTimeInMenuBar];
}

- (KYARemainingTimeFormat)kya_remainingTimeFormat
{
    NSString *value = [self stringForKey:KYAUserDefaultsKeyRemainingTimeFormat];
    if(value.length == 0) { return KYARemainingTimeFormatCompact; }
    return value;
}

- (void)setKya_remainingTimeFormat:(KYARemainingTimeFormat)format
{
    [self setObject:format forKey:KYAUserDefaultsKeyRemainingTimeFormat];
}

@end
