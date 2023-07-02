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
#import "KYAUserDefaultsSetting.h"
#import "KYABatteryCapacityThreshold.h"

@interface KYAAdvancedPreferencesViewController ()
@property (nonatomic) NSArray<KYAUserDefaultsSetting *> *settings;
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
    return KYA_SETTINGS_L10N_ADVANCED;
}

- (BOOL)resizesView
{
    return NO;
}

#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self configureAdvancedSettings];
}

#pragma mark - Configuration

- (void)configureAdvancedSettings
{
    Auto settings = [NSMutableArray<KYAUserDefaultsSetting *> new];
    
    [settings addObject:[[KYAUserDefaultsSetting alloc] initWithTitle:KYA_L10N_DISABLE_MENU_BAR_ICON_HIGHLIGHT_COLOR key:KYAUserDefaultsKeyMenuBarIconHighlightDisabled]];
    [settings addObject:[[KYAUserDefaultsSetting alloc] initWithTitle:KYA_L10N_QUIT_ON_TIMER_EXPIRATION key:KYAUserDefaultsKeyIsQuitOnTimerExpirationEnabled]];
    [settings addObject:[[KYAUserDefaultsSetting alloc] initWithTitle:KYA_L10N_ALLOW_DISPLAY_SLEEP key:KYAUserDefaultsKeyAllowDisplaySleep]];
    [settings addObject:[[KYAUserDefaultsSetting alloc] initWithTitle:KYA_L10N_ACTIVATE_ON_EXTERNAL_DISPLAY key:KYAUserDefaultsKeyActivateOnExternalDisplayConnectedEnabled]];
    [settings addObject:[[KYAUserDefaultsSetting alloc] initWithTitle:KYA_L10N_DEACTIVATE_ON_USER_SWITCH key:KYAUserDefaultsKeyDeactivateOnUserSwitchEnabled]];
    
    self.settings = [settings copy];
}

#pragma mark - Reset Advanced Settings

- (IBAction)resetAdvancedSettings:(id)sender
{
    for(KYAUserDefaultsSetting *setting in self.settings)
    {
        [setting reset];
    }
    [NSUserDefaults.standardUserDefaults synchronize];
    [self.tableView reloadData];
}

#pragma mark - Table View Delegate & Data Source

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return (NSInteger)self.settings.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return self.settings[(NSUInteger)row];
}

@end
