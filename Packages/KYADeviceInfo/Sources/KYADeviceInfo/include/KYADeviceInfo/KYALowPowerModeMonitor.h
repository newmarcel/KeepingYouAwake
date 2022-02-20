//
//  KYALowPowerModeMonitor.h
//  KYADeviceInfo
//
//  Created by Marcel Dierkes on 20.09.21.
//  Copyright © 2021 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Monitors the status of the device's Low Power Mode.
@interface KYALowPowerModeMonitor : NSObject

/// Returns `YES` if the current device supports the Low Power Mode.
@property (class, nonatomic, readonly) BOOL supportsLowPowerMode;

/// Returns `YES` if Low Power Mode is currently enabled.
@property (nonatomic, readonly, getter=isLowPowerModeEnabled) BOOL lowPowerModeEnabled;

@end

NS_ASSUME_NONNULL_END
