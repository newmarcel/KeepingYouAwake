//
//  KYAAdvancedPreferencesViewController.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 18.12.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface KYAAdvancedPreferencesViewController : NSViewController
@property (weak, nonatomic, nullable) IBOutlet NSTableView *tableView;

/**
 *  Resets all advanced preferences to their default value.
 *
 *  @param sender A sender.
 */
- (IBAction)resetAdvancedPreferences:(nullable id)sender;

@end
