//
//  KYAAdvancedSettingsViewController.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 18.12.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <KYAApplicationSupport/KYAApplicationSupport.h>
#import "KYASettingsContentViewController.h"

/// Shows "Advanced" settings.
@interface KYAAdvancedSettingsViewController : KYASettingsContentViewController <NSTableViewDataSource, NSTableViewDelegate>

/// A table view that lists individual settings
@property (weak, nonatomic, nullable) IBOutlet NSTableView *tableView;

/// Resets all advanced settings to their default values.
/// @param sender The sending control
- (IBAction)resetAdvancedSettings:(nullable id)sender;

@end
