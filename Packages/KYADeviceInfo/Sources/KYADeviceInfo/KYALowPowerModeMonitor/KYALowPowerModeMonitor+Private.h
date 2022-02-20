//
//  KYALowPowerModeMonitor+Private.h
//  KYADeviceInfo
//
//  Created by Marcel Dierkes on 19.02.22.
//  Copyright © 2022 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KYADeviceInfo/KYALowPowerModeMonitor.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^KYALowPowerModeChangeBlock)(BOOL enabled);

@interface KYALowPowerModeMonitor ()
@property (nonatomic, getter=isRegistered) BOOL registered;

/// An optional block that will be called when the Low Power Mode status
/// changes and -registerForLowPowerModeChanges was called.
@property (copy, nonatomic, nullable) KYALowPowerModeChangeBlock lowPowerModeChangeHandler;

/// Registers for receiving changes to the Low Power Mode.
///
/// The `lowPowerModeChangeHandler` will be called when the status changes.
- (void)registerForLowPowerModeChanges;

/// Unregisters from receiving changes to the Low Power Mode.
- (void)unregisterFromLowPowerModeChanges;

@end

NS_ASSUME_NONNULL_END
