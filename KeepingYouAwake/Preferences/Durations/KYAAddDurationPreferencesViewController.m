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
@property (nonatomic) KYAActivationDurationsController *durationsController;

@property (nonatomic) NSNumber *hours;
@property (nonatomic) NSNumber *minutes;
@property (nonatomic) NSNumber *seconds;

@property (nonatomic, nullable) NSString *errorMessage;
@end

@implementation KYAAddDurationPreferencesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.durationsController = KYAActivationDurationsController.sharedController;
    
    [self resetValues];
}

- (void)addDuration:(id)sender
{
    self.errorMessage = @"That doesn't work yet.";
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

#pragma mark - NSTextFieldDelegate

- (BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor
{
    // Reset the error message when the user starts typing again
    self.errorMessage = nil;
    
    return YES;
}

@end
