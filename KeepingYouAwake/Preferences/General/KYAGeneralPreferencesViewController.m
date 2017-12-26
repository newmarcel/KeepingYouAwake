//
//  KYAGeneralPreferencesViewController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 18.12.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import "KYAGeneralPreferencesViewController.h"
#import "KYAActivationDuration.h"
#import "NSApplication+KYALauncher.h"
#import "NSUserDefaults+Keys.h"

@interface KYAGeneralPreferencesViewController ()
@property (nonatomic) NSArray<KYAActivationDuration *> *activationDurations;
@property (nonatomic) KYAActivationDuration *selectedActivationDuration;
@property (weak, nonatomic) IBOutlet NSButton *startAtLoginCheckBoxButton;
@end

@implementation KYAGeneralPreferencesViewController
@dynamic selectedActivationDuration;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Pre-populate the activation durations
    self.activationDurations = @[
                                 KYADurationForSeconds((NSInteger)KYAActivationDurationIndefinite),
                                 KYADurationForMinutes(5), KYADurationForMinutes(10), KYADurationForMinutes(15),
                                 KYADurationForMinutes(30),
                                 KYADurationForHours(1), KYADurationForHours(2), KYADurationForHours(5)
                                 ];
    
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

- (void)viewWillAppear
{
    [super viewWillAppear];
    
    self.preferredContentSize = self.view.fittingSize;
}

- (void)dealloc
{
    [self.startAtLoginCheckBoxButton unbind:@"value"];
}
#pragma mark - Selected Activation Duration

- (KYAActivationDuration *)selectedActivationDuration
{
    NSTimeInterval storedDefaultInterval = NSUserDefaults.standardUserDefaults.kya_defaultTimeInterval;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"seconds == %@", @(storedDefaultInterval)];
    KYAActivationDuration *defaultDuration = [self.activationDurations filteredArrayUsingPredicate:predicate].firstObject;
    return defaultDuration;
}

- (void)setSelectedActivationDuration:(KYAActivationDuration *)selectedActivationDuration
{
    [self willChangeValueForKey:@"selectedActivationDuration"];
    NSUserDefaults.standardUserDefaults.kya_defaultTimeInterval = selectedActivationDuration.seconds;
    [NSUserDefaults.standardUserDefaults synchronize];
    [self didChangeValueForKey:@"selectedActivationDuration"];
}

@end
