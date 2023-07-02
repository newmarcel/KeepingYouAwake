//
//  KYAAdvancedPreferencesViewController.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 18.12.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <KYAApplicationSupport/KYAApplicationSupport.h>
#import "KYASettingsContentViewController.h"

/// Shows "Advanced" preferences.
@interface KYAAdvancedPreferencesViewController : KYASettingsContentViewController <NSTableViewDataSource, NSTableViewDelegate>

/// A table view that lists individual preferences
@property (weak, nonatomic, nullable) IBOutlet NSTableView *tableView;

/// Resets all advanced preferences to their default values.
/// @param sender The sending control
- (IBAction)resetAdvancedPreferences:(nullable id)sender;

@end
