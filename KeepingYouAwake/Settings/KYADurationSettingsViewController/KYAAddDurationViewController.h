//
//  KYAAddDurationViewController.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 08.08.19.
//  Copyright © 2019 Marcel Dierkes. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <KYAActivationDurations/KYAActivationDurations.h>

NS_ASSUME_NONNULL_BEGIN

/// Allows adding Activation Durations using `KYAActivationDurationsController`.
@interface KYAAddDurationViewController : NSViewController <NSTextFieldDelegate>
@property (nonatomic, readonly) KYAActivationDurationsController *activationDurationsController;
@property (weak, nonatomic) IBOutlet NSTextField *hoursTextField;
@property (weak, nonatomic) IBOutlet NSTextField *minutesTextField;
@property (weak, nonatomic) IBOutlet NSTextField *secondsTextField;
@property (weak, nonatomic) IBOutlet NSTextField *warningLabel;
@property (weak, nonatomic) IBOutlet NSButton *addButton;
@property (weak, nonatomic) IBOutlet NSDatePicker *clockTimeDatePicker;
@property (weak, nonatomic) IBOutlet NSStackView *fieldsStackView;
@property (weak, nonatomic) IBOutlet NSStackView *inputStackView;

/// The designated initializer
/// @param controller The activation durations controller
- (instancetype)initWithActivationDurationsController:(KYAActivationDurationsController *)controller;

- (IBAction)addDuration:(nullable id)sender;

@end

NS_ASSUME_NONNULL_END
