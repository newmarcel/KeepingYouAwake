//
//  KYAAddDurationViewController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 08.08.19.
//  Copyright © 2019 Marcel Dierkes. All rights reserved.
//

#import "KYAAddDurationViewController.h"
#import <KYACommon/KYACommon.h>
#import "KYALocalizedStrings.h"

static const NSInteger KYAMaximumHours = 999;
static const NSInteger KYAMaximumMinutes = 59;
static const NSInteger KYAMaximumSeconds = 59;

typedef NS_ENUM(NSInteger, KYADurationMode)
{
    KYADurationModeFixed = 0,
    KYADurationModeClockTime = 1
};

typedef NS_ENUM(NSUInteger, KYAValidationReason)
{
    KYAValidationReasonSuccess = 0,
    KYAValidationReasonInvalid,
    KYAValidationReasonAlreadyAdded
};

@interface KYAAddDurationViewController ()
@property (nonatomic, readwrite) KYAActivationDurationsController *activationDurationsController;

@property (nonatomic) NSNumber *hours;
@property (nonatomic) NSNumber *minutes;
@property (nonatomic) NSNumber *seconds;

@property (nonatomic, nullable) NSString *errorMessage;

@property (nonatomic) KYADurationMode durationMode;
@property (nonatomic, readonly) BOOL usesClockTime;
@property (nonatomic) NSDate *clockTime;
@end

@implementation KYAAddDurationViewController

- (instancetype)initWithActivationDurationsController:(KYAActivationDurationsController *)controller
{
    NSParameterAssert(controller);
    
    Auto nibName = NSStringFromClass([self class]);
    self = [super initWithNibName:nibName bundle:nil];
    if(self)
    {
        self.activationDurationsController = controller;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // A hidden row must give up its space, which nib-created stack views don't do by default
    self.inputStackView.detachesHiddenViews = YES;
    
    self.clockTimeDatePicker.datePickerElements = NSDatePickerElementFlagHourMinute;
    self.clockTimeDatePicker.datePickerStyle = NSDatePickerStyleTextFieldAndStepper;
    
    [self resetValues];
    [self updateInputVisibility];
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
    if(self.usesClockTime)
    {
        return [self validateClockTimeInput];
    }

    if(self.hours.integerValue > KYAMaximumHours)
    {
        self.hours = @(KYAMaximumHours);
        return KYAValidationReasonInvalid;
    }
    if(self.hours == nil) { self.hours = @0; }
    
    if(self.minutes.integerValue > KYAMaximumMinutes)
    {
        self.minutes = @(KYAMaximumMinutes);
        return KYAValidationReasonInvalid;
    }
    if(self.minutes == nil) { self.minutes = @0; }
    
    if(self.seconds.integerValue > KYAMaximumSeconds)
    {
        self.seconds = @(KYAMaximumSeconds);
        return KYAValidationReasonInvalid;
    }
    if(self.seconds == nil) { self.seconds = @0; }
    
    Auto duration = [[KYAActivationDuration alloc] initWithHours:self.hours.integerValue
                                                         minutes:self.minutes.integerValue
                                                         seconds:self.seconds.integerValue];
    if(duration == nil)
    {
        return KYAValidationReasonInvalid;
    }
    
    BOOL didAdd = [self.activationDurationsController addActivationDuration:duration];
    if(didAdd == NO)
    {
        return KYAValidationReasonAlreadyAdded;
    }
    
    return KYAValidationReasonSuccess;
}

- (KYAValidationReason)validateClockTimeInput
{
    Auto components = [NSCalendar.currentCalendar components:NSCalendarUnitHour | NSCalendarUnitMinute
                                                    fromDate:self.clockTime];
    Auto duration = [[KYAActivationDuration alloc] initWithClockTimeHour:components.hour
                                                                  minute:components.minute];
    if(duration == nil)
    {
        return KYAValidationReasonInvalid;
    }

    BOOL didAdd = [self.activationDurationsController addActivationDuration:duration];
    if(didAdd == NO)
    {
        return KYAValidationReasonAlreadyAdded;
    }

    return KYAValidationReasonSuccess;
}

+ (NSSet<NSString *> *)keyPathsForValuesAffectingUsesClockTime
{
    return [NSSet setWithObject:@"durationMode"];
}

- (BOOL)usesClockTime
{
    return self.durationMode == KYADurationModeClockTime;
}

- (void)setDurationMode:(KYADurationMode)durationMode
{
    _durationMode = durationMode;
    self.errorMessage = nil;
    [self setInputsEnabled:YES];
    [self updateInputVisibility];
}

- (void)updateInputVisibility
{
    BOOL clockTime = self.usesClockTime;
    self.fieldsStackView.hidden = clockTime;
    self.clockTimeDatePicker.hidden = !clockTime;
    
    Auto window = self.view.window;
    if(window == nil) { return; }
    [self.view layoutSubtreeIfNeeded];
    Auto fittingSize = self.view.fittingSize;
    NSRect frame = window.frame;
    CGFloat delta = fittingSize.height - NSHeight(window.contentView.frame);
    frame.size.height += delta;
    frame.origin.y -= delta;
    [window setFrame:frame display:YES animate:YES];
}

- (void)viewDidAppear
{
    [super viewDidAppear];
    [self updateInputVisibility];
}

- (void)setInputsEnabled:(BOOL)enabled
{
    self.clockTimeDatePicker.enabled = enabled && self.usesClockTime;
    enabled = enabled && !self.usesClockTime;

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

    Auto calendar = NSCalendar.currentCalendar;
    self.clockTime = [calendar dateBySettingHour:17 minute:0 second:0 ofDate:[NSDate date] options:0] ?: [NSDate date];
    self.durationMode = KYADurationModeFixed;
}

#pragma mark - NSTextFieldDelegate

- (BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor
{
    // Reset the error message when the user starts typing again
    self.errorMessage = nil;
    
    return YES;
}

@end
