//
//  KYABatteryMonitor+Private.h
//  KYADeviceInfo
//
//  Created by Marcel Dierkes on 19.02.22.
//  Copyright © 2022 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <KYADeviceInfo/KYABatteryMonitor.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^KYABatteryMonitorChangeBlock)(CGFloat capacity);

@interface KYABatteryMonitor ()
@property (nonatomic, nullable) CFRunLoopSourceRef runLoopSource;
@property (nonatomic, readonly, getter=isRegistered) BOOL registered;

/// An optional block that will be called when the power source changes and
/// -registerForCapacityChanges was called.
@property (copy, nonatomic, nullable) KYABatteryMonitorChangeBlock capacityChangeHandler;

/// Registers the current instance with the runloop to receive power source change notifications.
///
/// The `capacityChangeHandler` block will be called when a power source change occurs.
- (void)registerForCapacityChangesIfNeeded;

/// Unregisters the current instance from all capacity change notifications.
/// This method will automatically be called on dealloc.
- (void)unregisterFromCapacityChanges;

@end

NS_ASSUME_NONNULL_END
