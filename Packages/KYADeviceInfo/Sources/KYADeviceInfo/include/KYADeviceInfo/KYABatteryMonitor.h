//
//  KYABatteryMonitor.h
//  KYADeviceInfo
//
//  Created by Marcel Dierkes on 21.12.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KYACommon/KYAExport.h>

NS_ASSUME_NONNULL_BEGIN

KYA_EXPORT const CGFloat KYABatteryCapacityUnavailable;

/// The battery state of the device.
typedef NS_ENUM(NSUInteger, KYADeviceBatteryState)
{
    /// The battery state for the device cannot be determined.
    KYADeviceBatteryStateUnknown = 0,
    /// The device is not plugged into power; the battery is discharging.
    KYADeviceBatteryStateUnplugged,
    /// The device is plugged into power and the battery is less than 100% charged.
    KYADeviceBatteryStateCharging,
    /// The device is plugged into power and the battery is less than 100% charged.
    KYADeviceBatteryStateFull,
};

/// Monitors the status for the device's battery.
@interface KYABatteryMonitor : NSObject

/// Returns `YES` if the current device actually has a built-in battery.
@property (nonatomic, readonly) BOOL hasBattery;

/// Returns the current battery charging level of the internal battery,
/// or `KYABatteryCapacityUnavailable`.
@property (nonatomic, readonly) CGFloat currentCapacity;

/// The battery state for the device.
@property (nonatomic, readonly) KYADeviceBatteryState state;

@end

NS_ASSUME_NONNULL_END
