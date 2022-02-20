//
//  KYABatteryPreferencesViewController.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 23.09.21.
//  Copyright © 2021 Marcel Dierkes. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <KYADeviceInfo/KYADeviceInfo.h>
#import "KYAPreferencesContentViewController.h"

NS_ASSUME_NONNULL_BEGIN

/// Shows "Battery" preferences.
@interface KYABatteryPreferencesViewController : KYAPreferencesContentViewController
@property (nonatomic, readonly) KYADevice *device;
@end

NS_ASSUME_NONNULL_END
