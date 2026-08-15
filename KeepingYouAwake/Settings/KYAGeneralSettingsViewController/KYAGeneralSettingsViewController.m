//
//  KYAGeneralSettingsViewController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 18.12.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import "KYAGeneralSettingsViewController.h"
#import <KYACommon/KYACommon.h>

@interface KYAGeneralSettingsViewController ()
@property (weak, nonatomic) IBOutlet NSButton *startAtLoginCheckBoxButton;
@property (weak, nonatomic) IBOutlet NSButton *notificationSettingsButton;
@end

@implementation KYAGeneralSettingsViewController

+ (NSImage *)tabViewItemImage
{
    return [NSImage imageWithSystemSymbolName:@"gearshape" accessibilityDescription:nil];
}

+ (NSString *)preferredTitle
{
    return KYA_SETTINGS_L10N_GENERAL;
}

#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Bind the start at login checkbox value to NSApplication
    [self.startAtLoginCheckBoxButton bind:@"value"
                                 toObject:NSApplication.sharedApplication
                              withKeyPath:@"kya_launchAtLoginEnabled"
                                  options:@{
                                      NSRaisesForNotApplicableKeysBindingOption: @YES,
                                      NSConditionallySetsEnabledBindingOption: @YES
                                  }
     ];
}

- (void)dealloc
{
    [self.startAtLoginCheckBoxButton unbind:@"value"];
}

- (void)openNotificationSettings:(id)sender
{
    Auto workspace = NSWorkspace.sharedWorkspace;
    [workspace kya_openNotificationSettingsWithCompletionHandler:nil];
}

@end
