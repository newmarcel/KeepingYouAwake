//
//  NSUserDefaults+Keys.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 25.10.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// User Default Keys
FOUNDATION_EXPORT NSString * const KYAUserDefaultsKeyActivateOnLaunch;
FOUNDATION_EXPORT NSString * const KYAUserDefaultsKeyNotificationsEnabled;
FOUNDATION_EXPORT NSString * const KYAUserDefaultsKeyDefaultTimeInterval;
FOUNDATION_EXPORT NSString * const KYAUserDefaultsKeyMenuBarIconHighlightDisabled;
FOUNDATION_EXPORT NSString * const KYAUserDefaultsKeyBatteryCapacityThresholdEnabled;
FOUNDATION_EXPORT NSString * const KYAUserDefaultsKeyBatteryCapacityThreshold;
FOUNDATION_EXPORT NSString * const KYAUserDefaultsKeyPreReleaseUpdatesEnabled;

@interface NSUserDefaults (Keys)

/**
 Returns YES if the sleep wake timer should be activated on app launch.
 */
@property (nonatomic, getter = kya_isActivatedOnLaunch) BOOL kya_activateOnLaunch;

/**
 Returns YES if user notifications should be displayed.
 */
@property (nonatomic, getter = kya_areNotificationsEnabled) BOOL kya_notificationsEnabled;

/**
 Returns the default time interval for the sleep wake timer.
 */
@property (nonatomic) NSTimeInterval kya_defaultTimeInterval;

/**
 Returns YES if the menu bar icon should not be highlighted on left and right click.
 */
@property (nonatomic, getter = kya_isMenuBarIconHighlightDisabled) BOOL kya_menuBarIconHighlightDisabled;

/**
 Returns YES if the sleep wake timer should deactivate below a defined battery capacity threshold.
 */
@property (nonatomic, getter = kya_isBatteryCapacityThresholdEnabled) BOOL kya_batteryCapacityThresholdEnabled;

/**
 A battery capacity threshold.
 
 If the user defaults value is below 10.0, 10.0 will be returned.
 */
@property (nonatomic) CGFloat kya_batteryCapacityThreshold;

/**
 Returns YES if Sparkle should check for pre-release updates.
 */
@property (nonatomic, getter = kya_arePreReleaseUpdatesEnabled) BOOL kya_preReleaseUpdatesEnabled;

@end

NS_ASSUME_NONNULL_END
