//
//  KYAGeneralPreferencesViewController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 18.12.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import "KYAGeneralPreferencesViewController.h"
#import "KYADefines.h"

@interface KYAGeneralPreferencesViewController ()
@property (weak, nonatomic) IBOutlet NSButton *startAtLoginCheckBoxButton;
@property (weak, nonatomic) IBOutlet NSButton *notificationPreferencesButton;
@end

@implementation KYAGeneralPreferencesViewController

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
    
    if(@available(macOS 11.0, *)) {} else
    {
        self.notificationPreferencesButton.hidden = YES;
    }
}

- (void)viewWillAppear
{
    [super viewWillAppear];
    
    self.preferredContentSize = self.view.fittingSize;
}

- (void)dealloc
{
    [self.startAtLoginCheckBoxButton unbind:@"value"];
}

- (void)openNotificationPreferences:(id)sender
{
    Auto workspace = NSWorkspace.sharedWorkspace;
    [workspace kya_openNotificationPreferencesWithCompletionHandler:nil];
}

@end
