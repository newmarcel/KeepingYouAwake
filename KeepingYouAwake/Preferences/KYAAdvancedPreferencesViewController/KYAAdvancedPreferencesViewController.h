//
//  KYAAdvancedPreferencesViewController.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 18.12.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <KYAKit/KYAKit.h>
#import <KYADeviceInfo/KYADeviceInfo.h>
#import "KYAPreferencesContentViewController.h"

/// Shows "Advanced" preferences.
@interface KYAAdvancedPreferencesViewController : KYAPreferencesContentViewController <NSTableViewDataSource, NSTableViewDelegate>

/// Determines if the current Mac has a built-in battery.
@property (nonatomic, readonly, getter=isBatteryStatusAvailable) BOOL batteryStatusAvailable;

/// A table view that lists individual preferences
@property (weak, nonatomic, nullable) IBOutlet NSTableView *tableView;

/// Resets all advanced preferences to their default values.
/// @param sender The sending control
- (IBAction)resetAdvancedPreferences:(nullable id)sender;

/// Is responsible for notifying the app controller about any
/// battery status preference changes.
/// @param sender The sending control
- (IBAction)batteryStatusPreferencesChanged:(nullable id)sender;

@end
