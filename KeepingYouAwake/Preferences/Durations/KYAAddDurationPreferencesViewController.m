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

typedef NS_ENUM(NSUInteger, KYAValidationReason) {
    KYAValidationReasonSuccess = 0,
    KYAValidationReasonInvalid,
    KYAValidationReasonAlreadyAdded
};

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
    [self setInputsEnabled:NO];
    
    KYAValidationReason validationResult = [self validateInputs];
    switch(validationResult)
    {
        case KYAValidationReasonInvalid:
            self.errorMessage = KYA_L10N_DURATION_INVALID_INPUT;
            [self setInputsEnabled:YES];
            break;
        case KYAValidationReasonAlreadyAdded:
            self.errorMessage = KYA_L10N_DURATION_ALREADY_ADDED;
            [self setInputsEnabled:YES];
            break;
        default:
            [self dismissController:sender];
            break;
    }
}

- (KYAValidationReason)validateInputs
{
    if(self.hours.integerValue > 999)
    {
        self.hours = @999;
        return KYAValidationReasonInvalid;
    }
    if(self.hours == nil) { self.hours = @0; }
    
    if(self.minutes.integerValue > 59)
    {
        self.minutes = @59;
        return KYAValidationReasonInvalid;
    }
    if(self.minutes == nil) { self.minutes = @0; }
    
    if(self.seconds.integerValue > 59)
    {
        self.seconds = @59;
        return KYAValidationReasonInvalid;
    }
    if(self.seconds == nil) { self.seconds = @0; }
    
    KYA_AUTO duration = [[KYAActivationDuration alloc] initWithHours:self.hours.integerValue
                                                             minutes:self.minutes.integerValue
                                                             seconds:self.seconds.integerValue];
    if(duration == nil)
    {
        return KYAValidationReasonInvalid;
    }
    BOOL didAdd = [self.durationsController addActivationDuration:duration];
    if(didAdd == NO)
    {
        return KYAValidationReasonAlreadyAdded;
    }
    
    return KYAValidationReasonSuccess;
}

- (void)setInputsEnabled:(BOOL)enabled
{
    if(enabled == NO)
    {
        [self.hoursTextField resignFirstResponder];
        [self.minutesTextField resignFirstResponder];
        [self.secondsTextField resignFirstResponder];
    }
    
    self.hoursTextField.editable = enabled;
    self.minutesTextField.editable = enabled;
    self.secondsTextField.editable = enabled;
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
