//
//  KYAAddDurationPreferencesViewController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 08.08.19.
//  Copyright © 2019 Marcel Dierkes. All rights reserved.
//

#import "KYAAddDurationPreferencesViewController.h"
#import "KYADefines.h"
#import "KYAActivationDurationsController.h"

@interface KYAAddDurationPreferencesViewController ()
@property (nonatomic) KYAActivationDurationsController *controller;
@property (nonatomic) NSNumber *hours;
@property (nonatomic) NSNumber *minutes;
@property (nonatomic) NSNumber *seconds;
@end

@implementation KYAAddDurationPreferencesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.controller = KYAActivationDurationsController.sharedController;
    
    [self resetValues];
}

- (void)addDuration:(id)sender
{
    
}

- (void)resetValues
{
    self.hours = @1;
    self.minutes = @0;
    self.seconds = @0;
}

- (void)validateInput
{
    
}

@end
