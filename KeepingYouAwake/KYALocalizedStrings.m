//
//  KYALocalizedStrings.c
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 10.08.19.
//  Copyright © 2019 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Generic

#define KYA_L10N_OK NSLocalizedString(@"OK", @"OK")
#define KYA_L10N_CANCEL NSLocalizedString(@"Cancel", @"Cancel")
#define KYA_L10N_DEFAULT NSLocalizedString(@"Default", @"Default")

#pragma mark -

#define KYA_L10N_ALLOWING_YOUR_MAC_TO_GO_TO_SLEEP NSLocalizedString(@"Allowing your Mac to go to sleep…", @"Allowing your Mac to go to sleep…")
#define KYA_L10N_PREVENTING_YOUR_MAC_FROM_GOING_TO_SLEEP NSLocalizedString(@"Preventing your Mac from going to sleep…", @"Preventing your Mac from going to sleep…")

#define KYA_L10N_FORMAT_PREVENTING_SLEEP_FOR_REMAINING_TIME NSLocalizedString(@"Preventing your Mac from going to sleep for\n%@…", @"Preventing your Mac from going to sleep for\n%@…")
#define KYA_L10N_PREVENTING_SLEEP_FOR_REMAINING_TIME(_str) [NSString stringWithFormat:KYA_L10N_FORMAT_PREVENTING_SLEEP_FOR_REMAINING_TIME, (NSString *)(_str)]

#define KYA_L10N_INDEFINITELY NSLocalizedString(@"Indefinitely", @"Indefinitely")

#define KYA_L10N_ACTIVATE_FOR_DURATION NSLocalizedString(@"Activate for Duration", @"Activate for Duration")

#define KYA_L10N_IS_DEFAULT_SUFFIX NSLocalizedString(@"(Default)", @"(Default)")

#define KYA_L10N_DURATION_ALREADY_ADDED NSLocalizedString(@"This duration has already been added.", @"This duration has already been added.")

#define KYA_L10N_DURATION_INVALID_INPUT NSLocalizedString(@"The entered duration is invalid. Please try again.", @"The entered duration is invalid. Please try again.")

#pragma mark - Preferences

#define KYA_L10N_ENABLE_EXPERIMENTAL_NOTIFICATION_CENTER_INTEGRATION NSLocalizedString(@"Enable experimental Notification Center integration", @"Enable experimental Notification Center integration")
#define KYA_L10N_DISABLE_MENU_BAR_ICON_HIGHLIGHT_COLOR NSLocalizedString(@"Disable menu bar icon highlight color", @"Disable menu bar icon highlight color")
#define KYA_L10N_QUIT_ON_TIMER_EXPIRATION NSLocalizedString(@"Quit when activation duration is over", @"Quit when activation duration is over")
#define KYA_L10N_ALLOW_DISPLAY_SLEEP NSLocalizedString(@"Allow the display to sleep", @"Allow the display to sleep")

#define KYA_L10N_DURATIONS_ALERT_REALLY_RESET_TITLE NSLocalizedString(@"Reset Activation Durations", @"Reset Activation Durations")
#define KYA_L10N_DURATIONS_ALERT_REALLY_RESET_MESSAGE NSLocalizedString(@"Do you really want to reset the activation durations to the default values?", @"Do you really want to reset the activation durations to the default values?")

#define KYA_L10N_SET_DEFAULT_ACTIVATION_DURATION(_str) [NSString stringWithFormat:NSLocalizedString(@"Set Default: %@", @"Set Default: %@"), (NSString *)(_str)]
