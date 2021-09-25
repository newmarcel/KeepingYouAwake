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

@interface KYAAdvancedPreferencesViewController ()
@property (nonatomic) NSArray<KYAPreference *> *preferences;
@property (nonatomic, readwrite) BOOL batteryStatusAvailable;
@property (weak, nonatomic) IBOutlet NSUserDefaultsController *defaultsController;
@end

@implementation KYAAdvancedPreferencesViewController

+ (NSImage *)tabViewItemImage
{
    if(@available(macOS 11.0, *))
    {
        return [NSImage imageWithSystemSymbolName:@"gearshape.2"
                         accessibilityDescription:nil];
    }
    else
    {
        return [NSImage imageNamed:NSImageNameAdvanced];
    }
}

+ (NSString *)preferredTitle
{
    return KYA_PREFS_L10N_ADVANCED;
}

- (BOOL)resizesView
{
    return NO;
}

#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Check the battery status
    self.batteryStatusAvailable = [[KYABatteryStatus new] isBatteryStatusAvailable];

    [self configureAdvancedPreferences];
}

#pragma mark - Configuration

- (void)configureAdvancedPreferences
{
    Auto preferences = [NSMutableArray<KYAPreference *> new];

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
    AutoVar keyPath = [NSString stringWithFormat:@"values.%@", KYAUserDefaultsKeyBatteryCapacityThresholdEnabled];
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
