//
//  KYAAddDurationPreferencesViewController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 08.08.19.
//  Copyright © 2019 Marcel Dierkes. All rights reserved.
//

#import "KYAAddDurationPreferencesViewController.h"
#import "KYADefines.h"
#import "KYALocalizedStrings.h"
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
    [self.hoursTextField resignFirstResponder];
    self.hoursTextField.editable = NO;
    [self.minutesTextField resignFirstResponder];
    self.minutesTextField.editable = NO;
    [self.secondsTextField resignFirstResponder];
    self.secondsTextField.editable = NO;
    
    KYA_AUTO duration = [[KYAActivationDuration alloc] initWithHours:self.hours.integerValue
                                                             minutes:self.minutes.integerValue
                                                             seconds:self.seconds.integerValue];
    BOOL didAddDuration = [self.durationsController addActivationDuration:duration];
    if(didAddDuration == NO)
    {
        self.errorMessage = KYA_L10N_DURATION_ALREADY_ADDED;
        self.hoursTextField.editable = YES;
        self.minutesTextField.editable = YES;
        self.secondsTextField.editable = YES;
        return;
    }

    [self dismissController:sender];
}

- (void)resetValues
{
    self.hours = @1;
    self.minutes = @0;
    self.seconds = @0;
}

#pragma mark - NSTextFieldDelegate

- (BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor
{
    // Reset the error message when the user starts typing again
    self.errorMessage = nil;
    
    return YES;
}

@end
