//
//  KYADurationPreferencesViewController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 27.07.19.
//  Copyright © 2019 Marcel Dierkes. All rights reserved.
//

#import "KYADurationPreferencesViewController.h"
#import "KYADefines.h"
#import "KYADurationCell.h"
#import "KYAActivationDurationsController.h"

static NSStoryboardSegueIdentifier const KYAShowAddDurationSegueIdentifier = @"showAddDuration";

@interface KYADurationPreferencesViewController ()
@property (nonatomic) KYAActivationDurationsController *activationsController;
@end

@implementation KYADurationPreferencesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.activationsController = KYAActivationDurationsController.sharedController;
    
    [NSNotificationCenter.defaultCenter
     addObserver:self
     selector:@selector(activationDurationsDidChange:)
     name:KYAActivationDurationsControllerActivationDurationsDidChangeNotification
     object:nil];
    
    [KYADurationCell registerInTableView:self.tableView];
}

#pragma mark - Actions

- (IBAction)resetToDefaults:(id)sender
{
    [self.activationsController resetActivationDurations];
}

- (IBAction)toggleSegmentedControl:(NSSegmentedControl *)segmentedControl
{
    NSInteger index = segmentedControl.selectedSegment;
    if(index == 0)
    {
        [self removeSelectedDuration];
    }
    else if(index == 1)
    {
        [self performSegueWithIdentifier:KYAShowAddDurationSegueIdentifier sender:nil];
    }
}

#pragma mark -

- (BOOL)canAddDurations
{
    return NO;
}

- (void)removeSelectedDuration
{
    NSInteger selectedRow = self.tableView.selectedRow;
    if(selectedRow < 0) { return; }
    
    [self.activationsController removeActivationDurationAtIndex:(NSUInteger)selectedRow];
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return (NSInteger)self.activationsController.activationDurationsIncludingInfinite.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return self.activationsController.activationDurationsIncludingInfinite[(NSUInteger)row];
}

#pragma mark - NSTableViewDelegate

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    KYA_AUTO cell = [KYADurationCell dequeueFromTableView:tableView owner:self];
    KYA_AUTO duration = (KYAActivationDuration *)[self tableView:tableView objectValueForTableColumn:tableColumn row:row];
    cell.textLabel.stringValue = duration.localizedTitle;
    
    BOOL isDefault = [self.activationsController.defaultActivationDuration isEqualToActivationDuration:duration];
    
    return cell;
}

#pragma mark - KYAActivationDurationsController Did Change Notification

- (void)activationDurationsDidChange:(id)sender
{
    [self.tableView reloadData];
}

@end
