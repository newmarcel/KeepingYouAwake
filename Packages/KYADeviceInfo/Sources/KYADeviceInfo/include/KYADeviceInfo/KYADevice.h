//
//  KYADevice.h
//  KYADeviceInfo
//
//  Created by Marcel Dierkes on 19.02.22.
//  Copyright © 2022 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KYADeviceInfo/KYABatteryMonitor.h>
#import <KYADeviceInfo/KYALowPowerModeMonitor.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT const NSNotificationName KYADeviceParameterDidChangeNotification;
FOUNDATION_EXPORT NSString * const KYADeviceParameterKey;

typedef NSString *KYADeviceParameter;
FOUNDATION_EXPORT const KYADeviceParameter KYADeviceParameterBattery;
FOUNDATION_EXPORT const KYADeviceParameter KYADeviceParameterLowPowerMode;

/// Provides access to physical device parameters, like battery status and Low Power Mode.
@interface KYADevice : NSObject

/// Represents the current device
@property (class, nonatomic, readonly) KYADevice *currentDevice;

#pragma mark - Battery Monitor

/// The battery status monitor for devices that support this feature.
@property (nonatomic, readonly) KYABatteryMonitor *batteryMonitor;

/// Starts or stops receiving changes to the device's battery status.
///
/// When set to `YES`, you can observe the `KYADeviceParameterDidChangeNotification` with
/// the `KYADeviceParameterKey` user info value of `KYADeviceParameterBattery` to
/// receive notifications for each battery status change on supported devices.
/// ///
/// Defaults to `NO`.
@property(nonatomic, getter=isBatteryMonitoringEnabled) BOOL batteryMonitoringEnabled;

#pragma mark - Lower Power Mode

/// The Low Power Mode monitor for devices that support this feature.
@property (nonatomic, readonly) KYALowPowerModeMonitor *lowPowerModeMonitor;

/// Starts or stops receiving changes to the device's Low Power Mode.
///
/// When set to `YES`, you can observe the `KYADeviceParameterDidChangeNotification` with
/// the `KYADeviceParameterKey` user info value of `KYADeviceParameterLowPowerMode` to
/// receive notifications for each Low Power Mode change on supported devices.
///
/// Defaults to `NO`.
@property(nonatomic, getter=isLowPowerModeMonitoringEnabled) BOOL lowPowerModeMonitoringEnabled;

#pragma mark -

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
