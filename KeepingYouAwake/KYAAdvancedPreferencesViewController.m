//
//  KYAAdvancedPreferencesViewController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 18.12.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import "KYAAdvancedPreferencesViewController.h"
#import "KYAPreference.h"
#import "NSUserDefaults+Keys.h"

@interface KYAAdvancedPreferencesViewController () <NSTableViewDataSource, NSTableViewDelegate>
@property (nonatomic, nonnull) NSArray<KYAPreference *> *preferences;
@end

@implementation KYAAdvancedPreferencesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureAdvancedPreferences];
}

- (void)viewWillAppear
{
    [super viewWillAppear];
    
    self.preferredContentSize = self.view.fittingSize;
}

#pragma mark - Configuration

- (void)configureAdvancedPreferences
{
    NSMutableArray *preferences = [NSMutableArray new];
    
    [preferences addObject:[[KYAPreference alloc] initWithTitle:NSLocalizedString(@"Disable menu bar icon highlight color", nil)
                                                    defaultsKey:KYAUserDefaultsKeyMenuBarIconHighlightDisabled
                            ]];
    
    [preferences addObject:[[KYAPreference alloc] initWithTitle:NSLocalizedString(@"Enable experimental Notification Center integration", nil)
                                                    defaultsKey:KYAUserDefaultsKeyNotificationsEnabled
                            ]];
    
    [preferences addObject:[[KYAPreference alloc] initWithTitle:NSLocalizedString(@"Allow the display to sleep (when connected to AC power)", nil)
                                                    defaultsKey:KYAUserDefaultsKeyAllowDisplaySleep
                            ]];
    
    self.preferences = [preferences copy];
}

#pragma mark - Reset Advanced Preferences

- (IBAction)resetAdvancedPreferences:(id)sender
{
    for(KYAPreference *pref in self.preferences)
    {
        [pref reset];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.tableView reloadData];
}

#pragma mark - Table View Delegate & Data Source

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.preferences.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return self.preferences[row];
}

@end
