//
//  KYADurationPreferencesViewController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 27.07.19.
//  Copyright © 2019 Marcel Dierkes. All rights reserved.
//

#import "KYADurationPreferencesViewController.h"
#import "KYADefines.h"
#import "KYALocalizedStrings.h"
#import "KYADurationCell.h"
#import "KYAAddDurationPreferencesViewController.h"
#import "KYAActivationDuration+KYALocalizedTitle.h"

/// The allowed number of activation durations. If this limit is reached,
/// you cannot add more durations to the list.
static NSInteger const KYAActivationDurationLimit = 42;

@interface KYADurationPreferencesViewController ()
@property (nonatomic) KYAActivationDurationsController *durationsController;
@end

@implementation KYADurationPreferencesViewController

+ (NSImage *)tabViewItemImage
{
    if(@available(macOS 11.0, *))
    {
        return [NSImage imageWithSystemSymbolName:@"timer"
                         accessibilityDescription:nil];
    }
    else
    {
        return [NSImage imageNamed:@"ToolbarDurations"];
    }
}

+ (NSString *)preferredTitle
{
    return KYA_PREFS_L10N_ACTIVATION_DURATION;
}

- (BOOL)resizesView
{
    return NO;
}

#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Auto durationsController = KYAActivationDurationsController.sharedController;
    self.durationsController = durationsController;
    
    Auto notificationCenter = NSNotificationCenter.defaultCenter;
    [notificationCenter addObserver:self
                           selector:@selector(activationDurationsDidChange:)
                               name:KYAActivationDurationsDidChangeNotification
                             object:durationsController];
    
    [KYADurationCell registerInTableView:self.tableView];
    
    [self updateViewForSelectedRow];
    
    self.touchBarRemoveDurationButton.image = [NSImage imageNamed:NSImageNameTouchBarRemoveTemplate];
}

#pragma mark - Actions

- (IBAction)toggleSegmentedControl:(NSSegmentedControl *)segmentedControl
{
    NSInteger index = segmentedControl.selectedSegment;
    if(index == 0)
    {
        [self removeDuration:segmentedControl];
    }
    else if(index == 1)
    {
        [self addDuration:segmentedControl];
    }
}

- (IBAction)addDuration:(id)sender
{
    Auto controller = [[KYAAddDurationPreferencesViewController alloc] initWithActivationDurationsController:self.durationsController];
    [self presentViewControllerAsSheet:controller];
}

- (IBAction)resetToDefaults:(nullable id)sender
{
    Auto alert = [NSAlert new];
    alert.alertStyle = NSAlertStyleWarning;
    alert.icon = [NSImage imageNamed:NSImageNameCaution];
    
    alert.informativeText = KYA_L10N_DURATIONS_ALERT_REALLY_RESET_MESSAGE;
    alert.messageText = KYA_L10N_DURATIONS_ALERT_REALLY_RESET_TITLE;
    Auto okButton = [alert addButtonWithTitle:KYA_L10N_DURATIONS_ALERT_REALLY_RESET_TITLE];
    okButton.tag = NSModalResponseOK;
    [alert addButtonWithTitle:KYA_L10N_CANCEL];
    
    [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
        if(returnCode == NSModalResponseOK)
        {
            [self.durationsController resetActivationDurations];
        }
    }];
}

- (IBAction)setDefaultDuration:(nullable id)sender
{
    NSInteger selectedRow = self.tableView.clickedRow;
    if([sender isKindOfClass:[NSButton class]])
    {
        selectedRow = self.tableView.selectedRow;
    }
    
    if(selectedRow < 0) { return; }
    [self.durationsController setActivationDurationAsDefaultAtIndex:(NSUInteger)selectedRow];
}

- (IBAction)removeDuration:(nullable id)sender
{
    NSInteger selectedRow = self.tableView.clickedRow;
    if([sender isKindOfClass:[NSControl class]])
    {
        selectedRow = self.tableView.selectedRow;
    }
    
    if(selectedRow < 0) { return; }
    [self.durationsController removeActivationDurationAtIndex:(NSUInteger)selectedRow];
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return (NSInteger)self.durationsController.activationDurations.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return self.durationsController.activationDurations[(NSUInteger)row];
}

#pragma mark - NSTableViewDelegate

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    Auto cell = [KYADurationCell dequeueFromTableView:tableView owner:self];
    Auto duration = (KYAActivationDuration *)[self tableView:tableView
                                   objectValueForTableColumn:tableColumn row:row];
    cell.textLabel.stringValue = duration.localizedTitle;
    
    BOOL isDefault = [self.durationsController.defaultActivationDuration isEqualToActivationDuration:duration];
    cell.isDefaultDuration = isDefault;
    
    return cell;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    [self updateViewForSelectedRow];
}

- (void)updateViewForSelectedRow
{
    NSInteger row = self.tableView.selectedRow;
    BOOL enabled = [self.durationsController canRemoveActivationDurationAtIndex:(NSUInteger)row];
    self.setDefaultButton.enabled = (row >= 0);
    [self.segmentedControl setEnabled:enabled forSegment:0];
    
    self.touchBarSetDefaultButton.enabled = enabled;
    self.touchBarRemoveDurationButton.enabled = enabled;
    
    // Check if the limit of allowed durations was reached
    BOOL isLimited = self.durationsController.activationDurations.count >= KYAActivationDurationLimit;
    [self.segmentedControl setEnabled:!isLimited forSegment:1];
}

#pragma mark - KYAActivationDurationsController Did Change Notification

- (void)activationDurationsDidChange:(id)sender
{
    [self.tableView reloadData];
    [self tableViewSelectionDidChange:sender];
}

@end
