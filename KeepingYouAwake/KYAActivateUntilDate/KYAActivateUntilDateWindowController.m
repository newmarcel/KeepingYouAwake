//
//  KYAActivateUntilDateWindowController.m
//  KeepingYouAwake
//
//  Created by Austin Taylor on 30.09.26.
//  Copyright © 2026 Marcel Dierkes. All rights reserved.
//

#import "KYAActivateUntilDateWindowController.h"
#import <KYACommon/KYACommon.h>
#import "KYALocalizedStrings.h"

static const CGFloat KYAPanelMargin = 20.0f;
static const NSTimeInterval KYAMinimumLeadTime = 60.0f;

@interface KYAActivateUntilDateWindowController ()
@property (nonatomic) NSDatePicker *datePicker;
@property (nonatomic) NSDatePicker *timePicker;
@property (nonatomic) NSTextField *errorLabel;
@end

@implementation KYAActivateUntilDateWindowController

- (instancetype)init
{
    Auto panel = [[NSPanel alloc] initWithContentRect:NSMakeRect(0.0f, 0.0f, 340.0f, 130.0f)
                                            styleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskClosable
                                              backing:NSBackingStoreBuffered
                                                defer:YES];
    panel.title = KYA_L10N_ACTIVATE_UNTIL_DATE_TITLE;
    panel.releasedWhenClosed = NO;
    
    self = [super initWithWindow:panel];
    if(self)
    {
        [self buildContentView];
    }
    return self;
}

- (void)buildContentView
{
    Auto contentView = self.window.contentView;
    
    Auto label = [NSTextField labelWithString:KYA_L10N_KEEP_AWAKE_UNTIL];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    Auto datePicker = [NSDatePicker new];
    datePicker.translatesAutoresizingMaskIntoConstraints = NO;
    datePicker.datePickerStyle = NSDatePickerStyleTextFieldAndStepper;
    datePicker.datePickerElements = NSDatePickerElementFlagYearMonthDay;
    datePicker.target = self;
    datePicker.action = @selector(dateDidChange:);
    self.datePicker = datePicker;
    
    Auto timePicker = [NSDatePicker new];
    timePicker.translatesAutoresizingMaskIntoConstraints = NO;
    timePicker.datePickerStyle = NSDatePickerStyleTextFieldAndStepper;
    timePicker.datePickerElements = NSDatePickerElementFlagHourMinute;
    timePicker.target = self;
    timePicker.action = @selector(dateDidChange:);
    self.timePicker = timePicker;
    
    Auto pickers = [NSStackView stackViewWithViews:@[datePicker, timePicker]];
    pickers.translatesAutoresizingMaskIntoConstraints = NO;
    pickers.orientation = NSUserInterfaceLayoutOrientationHorizontal;
    pickers.spacing = 8.0f;
    
    Auto errorLabel = [NSTextField labelWithString:@""];
    errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    errorLabel.textColor = NSColor.secondaryLabelColor;
    errorLabel.font = [NSFont systemFontOfSize:NSFont.smallSystemFontSize];
    self.errorLabel = errorLabel;
    
    Auto cancelButton = [NSButton buttonWithTitle:KYA_L10N_CANCEL target:self action:@selector(cancel:)];
    cancelButton.keyEquivalent = @"\e";
    Auto activateButton = [NSButton buttonWithTitle:KYA_L10N_ACTIVATE target:self action:@selector(activate:)];
    activateButton.keyEquivalent = @"\r";
    
    Auto buttons = [NSStackView stackViewWithViews:@[cancelButton, activateButton]];
    buttons.translatesAutoresizingMaskIntoConstraints = NO;
    buttons.orientation = NSUserInterfaceLayoutOrientationHorizontal;
    
    [contentView addSubview:label];
    [contentView addSubview:pickers];
    [contentView addSubview:errorLabel];
    [contentView addSubview:buttons];
    
    [NSLayoutConstraint activateConstraints:@[
        [label.topAnchor constraintEqualToAnchor:contentView.topAnchor constant:KYAPanelMargin],
        [label.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:KYAPanelMargin],
        [pickers.topAnchor constraintEqualToAnchor:label.bottomAnchor constant:8.0f],
        [pickers.leadingAnchor constraintEqualToAnchor:label.leadingAnchor],
        [pickers.trailingAnchor constraintLessThanOrEqualToAnchor:contentView.trailingAnchor constant:-KYAPanelMargin],
        [datePicker.widthAnchor constraintEqualToConstant:[self paddedWidthForPicker:datePicker]],
        [timePicker.widthAnchor constraintEqualToConstant:[self paddedWidthForPicker:timePicker]],
        [errorLabel.topAnchor constraintEqualToAnchor:pickers.bottomAnchor constant:8.0f],
        [errorLabel.leadingAnchor constraintEqualToAnchor:label.leadingAnchor],
        [errorLabel.trailingAnchor constraintLessThanOrEqualToAnchor:contentView.trailingAnchor constant:-KYAPanelMargin],
        [buttons.topAnchor constraintEqualToAnchor:errorLabel.bottomAnchor constant:12.0f],
        [buttons.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-KYAPanelMargin],
        [buttons.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor constant:-KYAPanelMargin],
    ]];
}

/// Width for the widest value the picker can show, plus the same padding
/// the bezel already puts on the left.
- (CGFloat)paddedWidthForPicker:(NSDatePicker *)picker
{
    static const CGFloat KYAPickerInset = 6.0f;
    
    Auto calendar = NSCalendar.currentCalendar;
    Auto widest = [calendar dateWithEra:1 year:2088 month:12 day:28 hour:23 minute:58 second:0 nanosecond:0];
    Auto saved = picker.dateValue;
    picker.dateValue = widest;
    CGFloat width = picker.fittingSize.width + KYAPickerInset;
    picker.dateValue = saved;
    return ceil(width);
}

- (void)showPanel
{
    [self resetDate];
    self.errorLabel.stringValue = @"";
    
    if(@available(macOS 14.0, *))
    {
        [NSApplication.sharedApplication activate];
    }
    else
    {
        [NSApplication.sharedApplication activateIgnoringOtherApps:YES];
    }
    [self.window center];
    [self.window makeKeyAndOrderFront:nil];
}

- (void)resetDate
{
    Auto calendar = NSCalendar.currentCalendar;
    Auto now = [NSDate date];
    Auto earliest = [now dateByAddingTimeInterval:KYAMinimumLeadTime];
    Auto nextHour = [calendar nextDateAfterDate:earliest matchingUnit:NSCalendarUnitMinute value:0 options:NSCalendarMatchNextTime];
    Auto initial = nextHour ?: [now dateByAddingTimeInterval:60.0f * 60.0f];
    self.datePicker.minDate = [calendar startOfDayForDate:now];
    self.datePicker.dateValue = initial;
    self.timePicker.dateValue = initial;
}

- (NSDate *)combinedEndDate
{
    Auto calendar = NSCalendar.currentCalendar;
    Auto day = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                           fromDate:self.datePicker.dateValue];
    Auto time = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute
                            fromDate:self.timePicker.dateValue];
    day.hour = time.hour;
    day.minute = time.minute;
    day.second = 0;
    return [calendar dateFromComponents:day];
}

#pragma mark - Actions

- (void)dateDidChange:(id)sender
{
    self.errorLabel.stringValue = @"";
}

- (void)cancel:(id)sender
{
    [self.window close];
}

- (void)activate:(id)sender
{
    Auto endDate = [self combinedEndDate];
    if(endDate == nil || endDate.timeIntervalSinceNow < KYAMinimumLeadTime)
    {
        self.errorLabel.stringValue = KYA_L10N_DATE_MUST_BE_IN_THE_FUTURE;
        NSBeep();
        return;
    }
    
    [self.window close];
    
    Auto handler = self.completionHandler;
    if(handler != nil)
    {
        handler(endDate);
    }
}

@end
