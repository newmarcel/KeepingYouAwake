//
//  KYAGeneralPreferencesViewController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 18.12.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import "KYAGeneralPreferencesViewController.h"
#import "NSApplication+LoginItem.h"

@interface KYAGeneralPreferencesViewController ()
@property (weak, nonatomic) IBOutlet NSButton *startAtLoginCheckBoxButton;
@end

@implementation KYAGeneralPreferencesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Bind the start at login checkbox value to NSApplication
    [self.startAtLoginCheckBoxButton bind:@"value"
                                 toObject:[NSApplication sharedApplication]
                              withKeyPath:@"kya_startAtLogin"
                                  options:@{
                                            NSRaisesForNotApplicableKeysBindingOption: @YES,
                                            NSConditionallySetsEnabledBindingOption: @YES
                                            }
     ];
}

- (void)viewWillAppear
{
    [super viewWillAppear];
    
    self.preferredContentSize = self.view.fittingSize;
}

- (void)dealloc
{
    [self.startAtLoginCheckBoxButton unbind:@"state"];
}

@end
