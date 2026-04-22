//
//  NSUserDefaults+KYAKeys.h
//  KYAApplicationSupport
//
//  Created by Marcel Dierkes on 25.10.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KYACommon/KYAExport.h>

NS_ASSUME_NONNULL_BEGIN

// User Default Keys
KYA_EXPORT NSString * const KYAUserDefaultsKeyActivateOnLaunch;
KYA_EXPORT NSString * const KYAUserDefaultsKeyAllowDisplaySleep;
KYA_EXPORT NSString * const KYAUserDefaultsKeyActivateOnExternalDisplayConnectedEnabled;
KYA_EXPORT NSString * const KYAUserDefaultsKeyDeactivateOnUserSwitchEnabled;
KYA_EXPORT NSString * const KYAUserDefaultsKeyMenuBarIconHighlightDisabled;
KYA_EXPORT NSString * const KYAUserDefaultsKeyIsQuitOnTimerExpirationEnabled;
KYA_EXPORT NSString * const KYAUserDefaultsKeyBatteryCapacityThresholdEnabled;
KYA_EXPORT NSString * const KYAUserDefaultsKeyBatteryCapacityThreshold;
KYA_EXPORT NSString * const KYAUserDefaultsKeyLowPowerModeMonitoringEnabled;
KYA_EXPORT NSString * const KYAUserDefaultsKeyPreReleaseUpdatesEnabled;
KYA_EXPORT NSString * const KYAUserDefaultsKeyMenuBarActiveIconStyle;
KYA_EXPORT NSString * const KYAUserDefaultsKeyMenuBarInactiveIconStyle;
KYA_EXPORT NSString * const KYAUserDefaultsKeyMenuBarActiveCustomIconFile;
KYA_EXPORT NSString * const KYAUserDefaultsKeyMenuBarInactiveCustomIconFile;
KYA_EXPORT NSString * const KYAUserDefaultsKeyShowRemainingTimeInMenuBar;
KYA_EXPORT NSString * const KYAUserDefaultsKeyRemainingTimeFormat;

/// Raw values for `KYAUserDefaultsKeyRemainingTimeFormat`.
typedef NSString *KYARemainingTimeFormat NS_TYPED_EXTENSIBLE_ENUM;
/// "2h 30m" — compact natural-language style.
KYA_EXPORT KYARemainingTimeFormat const KYARemainingTimeFormatCompact;
/// "2:30:00" — digital clock style.
KYA_EXPORT KYARemainingTimeFormat const KYARemainingTimeFormatDigital;
/// "150m" — total minutes remaining.
KYA_EXPORT KYARemainingTimeFormat const KYARemainingTimeFormatMinutes;

@interface NSUserDefaults (KYAKeys)

/// Returns YES if the sleep wake timer should be activated on app launch.
@property (nonatomic, getter = kya_isActivatedOnLaunch) BOOL kya_activateOnLaunch;

/// Returns YES if the app should allow the display to sleep while still keeping
/// the system awake. This exposes the `caffeinate -i` command.
@property (nonatomic, getter = kya_shouldAllowDisplaySleep) BOOL kya_allowDisplaySleep;

/// Returns YES if the menu bar icon should not be highlighted on left and right click.
@property (nonatomic, getter = kya_isMenuBarIconHighlightDisabled) BOOL kya_menuBarIconHighlightDisabled;

/// Returns YES if the sleep wake timer should deactivate below a defined battery capacity threshold.
@property (nonatomic, getter = kya_isBatteryCapacityThresholdEnabled) BOOL kya_batteryCapacityThresholdEnabled;

/// A battery capacity threshold.
///
/// If the user defaults value is below 10.0, 10.0 will be returned.
@property (nonatomic) CGFloat kya_batteryCapacityThreshold;

/// Returns YES if the sleep wake timer should deactivate when Low Power Mode is enabled.
@property (nonatomic, getter=kya_isLowPowerModeMonitoringEnabled) BOOL kya_lowPowerModeMonitoringEnabled;

/// Returns YES if Sparkle should check for pre-release updates.
@property (nonatomic, getter = kya_arePreReleaseUpdatesEnabled) BOOL kya_preReleaseUpdatesEnabled;

/// Returns YES if the app should quit when the sleep wake timer expires.
@property (nonatomic, getter=kya_isQuitOnTimerExpirationEnabled) BOOL kya_quitOnTimerExpirationEnabled;

/// Returns YES if the app should activate when external display is connected.
@property (nonatomic, getter=kya_isActivateOnExternalDisplayConnectedEnabled) BOOL kya_activateOnExternalDisplayConnectedEnabled;

/// Returns YES if the app should deactivate when the user account is switched.
@property (nonatomic, getter=kya_isDeactivateOnUserSwitchEnabled) BOOL kya_deactivateOnUserSwitchEnabled;

/// Identifier of the selected menu bar icon style for the active state.
/// A nil/empty value means the built-in default icon.
@property (nonatomic, nullable, copy) NSString *kya_menuBarActiveIconStyle;

/// Identifier of the selected menu bar icon style for the inactive state.
/// A nil/empty value means the built-in default icon.
@property (nonatomic, nullable, copy) NSString *kya_menuBarInactiveIconStyle;

/// Filename (relative to the app's Documents directory) of the user-picked
/// custom icon file for the active state. When set, this overrides the
/// catalog style for that slot.
@property (nonatomic, nullable, copy) NSString *kya_menuBarActiveCustomIconFile;

/// Filename (relative to the app's Documents directory) of the user-picked
/// custom icon file for the inactive state. When set, this overrides the
/// catalog style for that slot.
@property (nonatomic, nullable, copy) NSString *kya_menuBarInactiveCustomIconFile;

/// Returns YES if the remaining timer time should be rendered next to the
/// menu bar icon while the timer is active.
@property (nonatomic, getter=kya_isShowRemainingTimeInMenuBarEnabled) BOOL kya_showRemainingTimeInMenuBar;

/// Format for the remaining-time label rendered next to the menu bar icon.
/// Defaults to `KYARemainingTimeFormatCompact` when unset.
@property (nonatomic, copy) KYARemainingTimeFormat kya_remainingTimeFormat;

@end

NS_ASSUME_NONNULL_END
