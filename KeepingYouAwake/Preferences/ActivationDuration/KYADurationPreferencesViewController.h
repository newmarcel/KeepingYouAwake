//
//  KYADurationPreferencesViewController.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 27.07.19.
//  Copyright © 2019 Marcel Dierkes. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYADurationPreferencesViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>
@property (weak, nonatomic) IBOutlet NSTableView *tableView;
@property (weak, nonatomic) IBOutlet NSSegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet NSButton *setDefaultButton;

@property (weak, nonatomic) IBOutlet NSButton *touchBarSetDefaultButton;
@property (weak, nonatomic) IBOutlet NSButton *touchBarRemoveDurationButton;

- (IBAction)toggleSegmentedControl:(NSSegmentedControl *)segmentedControl;
- (IBAction)addDuration:(id)sender;
- (IBAction)removeDuration:(id)sender;

- (IBAction)setDefaultDuration:(nullable id)sender;
- (IBAction)resetToDefaults:(nullable id)sender;

@end

NS_ASSUME_NONNULL_END
