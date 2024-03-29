//
//  KYABatterySettingsViewController.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 23.09.21.
//  Copyright © 2021 Marcel Dierkes. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <KYADeviceInfo/KYADeviceInfo.h>
#import "KYASettingsContentViewController.h"

NS_ASSUME_NONNULL_BEGIN

/// Shows "Battery" settings.
@interface KYABatterySettingsViewController : KYASettingsContentViewController
/// Provides access to the battery level and
/// low power mode of the physical device.
@property (nonatomic, readonly) KYADevice *device;

/// Is responsible for notifying the app controller about any
/// battery status settings changes.
/// @param sender The sending control
- (IBAction)batterySettingsDidChange:(nullable id)sender;

@end

NS_ASSUME_NONNULL_END
