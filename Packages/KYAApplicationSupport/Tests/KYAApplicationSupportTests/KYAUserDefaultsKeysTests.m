//
//  KYAUserDefaultsKeysTests.m
//  KYAApplicationSupport
//
//  Created by Marcel Dierkes on 11.05.22.
//

#import <XCTest/XCTest.h>
#import <KYAApplicationSupport/KYAApplicationSupport.h>
#import "../../Sources/KYAApplicationSupport/KYADefines.h"
#import "../../Sources/KYAApplicationSupport/KYAApplicationSupportLog.h"

#define KYA_GENERATE_BOOL_TEST(_short_getter_name, _property_name, _defaults_key)           \
- (void)testProperty_##_property_name                                                       \
{                                                                                           \
    Auto defaults = self.defaults;                                                          \
    Auto key = _defaults_key;                                                               \
                                                                                            \
    defaults.kya_##_property_name = YES;                                                    \
    XCTAssertTrue([defaults kya_##_short_getter_name]);                                     \
    XCTAssertTrue([defaults boolForKey:key]);                                               \
                                                                                            \
    defaults.kya_##_property_name = NO;                                                     \
    XCTAssertFalse([defaults kya_##_short_getter_name]);                                    \
    XCTAssertFalse([defaults boolForKey:key]);                                              \
                                                                                            \
    [defaults setBool:YES forKey:key];                                                      \
    XCTAssertTrue([defaults kya_##_short_getter_name]);                                     \
    os_log(KYAApplicationSupportLog(), "Tested User Defaults Key '%{public}@'.", key);      \
}

@interface KYAUserDefaultsKeysTests : XCTestCase
@property (nonatomic) NSUserDefaults *defaults;
@end

@implementation KYAUserDefaultsKeysTests

- (void)setUp
{
    [super setUp];
    
    self.defaults = [[NSUserDefaults alloc] initWithSuiteName:NSStringFromClass([self class])];
}

KYA_GENERATE_BOOL_TEST(isActivatedOnLaunch,
                       activateOnLaunch,
                       KYAUserDefaultsKeyActivateOnLaunch);

KYA_GENERATE_BOOL_TEST(shouldAllowDisplaySleep,
                       allowDisplaySleep,
                       KYAUserDefaultsKeyAllowDisplaySleep);

KYA_GENERATE_BOOL_TEST(isMenuBarIconHighlightDisabled,
                       menuBarIconHighlightDisabled,
                       KYAUserDefaultsKeyMenuBarIconHighlightDisabled);

KYA_GENERATE_BOOL_TEST(arePreReleaseUpdatesEnabled,
                       preReleaseUpdatesEnabled,
                       KYAUserDefaultsKeyPreReleaseUpdatesEnabled);

KYA_GENERATE_BOOL_TEST(isQuitOnTimerExpirationEnabled,
                       quitOnTimerExpirationEnabled,
                       KYAUserDefaultsKeyIsQuitOnTimerExpirationEnabled);

KYA_GENERATE_BOOL_TEST(isActivateOnExternalDisplayConnectedEnabled,
                       activateOnExternalDisplayConnectedEnabled,
                       KYAUserDefaultsKeyActivateOnExternalDisplayConnectedEnabled);

KYA_GENERATE_BOOL_TEST(isDeactivateOnUserSwitchEnabled,
                       deactivateOnUserSwitchEnabled,
                       KYAUserDefaultsKeyDeactivateOnUserSwitchEnabled);

KYA_GENERATE_BOOL_TEST(isBatteryCapacityThresholdEnabled,
                       batteryCapacityThresholdEnabled,
                       KYAUserDefaultsKeyBatteryCapacityThresholdEnabled);

KYA_GENERATE_BOOL_TEST(isLowPowerModeMonitoringEnabled,
                       lowPowerModeMonitoringEnabled,
                       KYAUserDefaultsKeyLowPowerModeMonitoringEnabled);

- (void)testBatteryCapacityThreshold
{
    Auto defaults = self.defaults;
    Auto key = KYAUserDefaultsKeyBatteryCapacityThreshold;
    
    defaults.kya_batteryCapacityThreshold = 90.0f;
    XCTAssertEqual([defaults kya_batteryCapacityThreshold], 90.0f);
    XCTAssertEqual([defaults floatForKey:key], 90.0f);
    
    [defaults setFloat:50.0f forKey:key];
    XCTAssertEqual([defaults kya_batteryCapacityThreshold], 50.0f);
    
    // Below 10%
    defaults.kya_batteryCapacityThreshold = 0.1f;
    XCTAssertEqual([defaults kya_batteryCapacityThreshold], 10.0f);
    XCTAssertEqual([defaults floatForKey:key], 0.1f); // TODO: Maybe the setter should catch this?
    
    [defaults setFloat:0.2f forKey:key];
    XCTAssertEqual([defaults kya_batteryCapacityThreshold], 10.0f);
    
    // Over 100%
    defaults.kya_batteryCapacityThreshold = 512.0f; // TODO: Maybe this should be invalid?
    XCTAssertEqual([defaults kya_batteryCapacityThreshold], 512.0f);
    XCTAssertEqual([defaults floatForKey:key], 512.0f);
}

@end
