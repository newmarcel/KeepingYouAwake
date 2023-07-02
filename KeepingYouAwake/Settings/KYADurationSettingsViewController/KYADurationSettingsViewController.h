//
//  KYADurationSettingsViewController.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 27.07.19.
//  Copyright © 2019 Marcel Dierkes. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <KYAActivationDurations/KYAActivationDurations.h>
#import "KYASettingsContentViewController.h"

NS_ASSUME_NONNULL_BEGIN

/// Shows "Activation Durations" settings and offers an
/// interface to add and remove durations.
@interface KYADurationSettingsViewController : KYASettingsContentViewController <NSTableViewDataSource, NSTableViewDelegate>
@property (weak, nonatomic) IBOutlet NSTableView *tableView;
@property (weak, nonatomic) IBOutlet NSSegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet NSButton *setDefaultButton;

@property (weak, nonatomic) IBOutlet NSButton *touchBarSetDefaultButton;
@property (weak, nonatomic) IBOutlet NSButton *touchBarRemoveDurationButton;

- (IBAction)toggleSegmentedControl:(NSSegmentedControl *)segmentedControl;
- (IBAction)addDuration:(nullable id)sender;
- (IBAction)removeDuration:(nullable id)sender;

- (IBAction)setDefaultDuration:(nullable id)sender;
- (IBAction)resetToDefaults:(nullable id)sender;

@end

NS_ASSUME_NONNULL_END
