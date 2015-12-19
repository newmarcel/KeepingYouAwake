//
//  KYAGeneralPreferencesViewController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 18.12.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import "KYAGeneralPreferencesViewController.h"
#import "NSApplication+LoginItem.h"
#import "KYAActivationDuration.h"

#define KYA_MINUTES(m) (m*60.0f)
#define KYA_HOURS(h) (h*3600.0f)
#define KYA_DURATION(s, u) ([[KYAActivationDuration alloc] initWithSeconds:s displayUnit:u])
#define KYA_DURATION_S(s) KYA_DURATION(s, NSCalendarUnitSecond)
#define KYA_DURATION_M(m) KYA_DURATION(KYA_MINUTES(m), NSCalendarUnitMinute)
#define KYA_DURATION_H(h) KYA_DURATION(KYA_HOURS(h), NSCalendarUnitHour)

@interface KYAGeneralPreferencesViewController ()
@property (nonatomic) NSArray<KYAActivationDuration *> *activationDurations;
@property (weak, nonatomic) IBOutlet NSButton *startAtLoginCheckBoxButton;
@end

@implementation KYAGeneralPreferencesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Pre-populate the activation durations
    self.activationDurations = @[
                                 KYA_DURATION_S(0), KYA_DURATION_S(10),
                                 KYA_DURATION_M(5), KYA_DURATION_M(10), KYA_DURATION_M(15), KYA_DURATION_M(30),
                                 KYA_DURATION_H(1), KYA_DURATION_H(2), KYA_DURATION_H(5)
                                 ];
    
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
    [self.startAtLoginCheckBoxButton unbind:@"value"];
}

@end
