//
//  KYAAdvancedPreferencesViewController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 18.12.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import "KYAAdvancedPreferencesViewController.h"
#import "KYADefines.h"
#import "KYALocalizedStrings.h"
#import "KYAPreference.h"
#import "KYABatteryCapacityThreshold.h"

@interface KYAAdvancedPreferencesViewController () <NSTableViewDataSource, NSTableViewDelegate>
@property (nonatomic, nonnull) NSArray<KYAPreference *> *preferences;
@property (nonatomic, readwrite) BOOL batteryStatusAvailable;
@property (weak, nonatomic) IBOutlet NSUserDefaultsController *defaultsController;
@end

@implementation KYAAdvancedPreferencesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Check the battery status
    self.batteryStatusAvailable = [[KYABatteryStatus new] isBatteryStatusAvailable];

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
    KYA_AUTO preferences = [NSMutableArray new];

    [preferences addObject:[[KYAPreference alloc] initWithTitle:KYA_L10N_ENABLE_EXPERIMENTAL_NOTIFICATION_CENTER_INTEGRATION
                                                    defaultsKey:KYAUserDefaultsKeyNotificationsEnabled
                            ]];

    [preferences addObject:[[KYAPreference alloc] initWithTitle:KYA_L10N_DISABLE_MENU_BAR_ICON_HIGHLIGHT_COLOR
                                                    defaultsKey:KYAUserDefaultsKeyMenuBarIconHighlightDisabled
                            ]];
    [preferences addObject:[[KYAPreference alloc] initWithTitle:KYA_L10N_QUIT_ON_TIMER_EXPIRATION
                                                    defaultsKey:KYAUserDefaultsKeyIsQuitOnTimerExpirationEnabled
                            ]];
    [preferences addObject:[[KYAPreference alloc] initWithTitle:KYA_L10N_ALLOW_DISPLAY_SLEEP
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
    [NSUserDefaults.standardUserDefaults synchronize];
    [self.tableView reloadData];

    // Disable battery status integration
    KYA_AUTO_VAR keyPath = [NSString stringWithFormat:@"values.%@", KYAUserDefaultsKeyBatteryCapacityThresholdEnabled];
    [self.defaultsController setValue:@NO forKeyPath:keyPath];
    keyPath = [NSString stringWithFormat:@"values.%@", KYAUserDefaultsKeyBatteryCapacityThreshold];
    [self.defaultsController setValue:@10.0f forKeyPath:keyPath];
}

#pragma mark - Battery Status Preferences

- (void)batteryStatusPreferencesChanged:(id)sender
{
    [NSNotificationCenter.defaultCenter postNotificationName:kKYABatteryCapacityThresholdDidChangeNotification object:nil];
}

#pragma mark - Table View Delegate & Data Source

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return (NSInteger)self.preferences.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return self.preferences[(NSUInteger)row];
}

@end
