//
//  NSUserDefaults+KYAKeys.m
//  KYAApplicationSupport
//
//  Created by Marcel Dierkes on 25.10.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import <KYAApplicationSupport/NSUserDefaults+KYAKeys.h>
#import "KYADefines.h"

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
// e.g. `FOUNDATION_EXPORT NSString * const KYAUserDefaultsKeySomethingEnabled;`
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

@end
