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

#pragma mark - Main Menu

#define KYA_L10N_ACTIVATE_FOR_DURATION NSLocalizedString(@"Activate for Duration", @"Activate for Duration")
#define KYA_L10N_PREFERENCES NSLocalizedString(@"Settings…", @"Settings…")
#define KYA_L10N_QUIT NSLocalizedString(@"Quit", @"Quit")

#pragma mark -

#define KYA_L10N_IS_DEFAULT_SUFFIX NSLocalizedString(@"(Default)", @"(Default)")

#define KYA_L10N_DURATION_ALREADY_ADDED NSLocalizedString(@"This duration has already been added.", @"This duration has already been added.")

#define KYA_L10N_DURATION_INVALID_INPUT NSLocalizedString(@"The entered duration is invalid. Please try again.", @"The entered duration is invalid. Please try again.")

#define KYA_L10N_INDEFINITELY NSLocalizedString(@"Indefinitely", @"Indefinitely")

#define KYA_L10N_VERSION NSLocalizedString(@"Version", @"Version")

#pragma mark - Notifications

#define KYA_L10N_PREVENTING_SLEEP_INDEFINITELY_TITLE NSLocalizedString(@"Preventing Sleep", @"Preventing Sleep")

#define KYA_L10N_PREVENTING_SLEEP_INDEFINITELY_BODY_TEXT NSLocalizedString(@"You can still manually enable sleep mode for your Mac.", @"You can still manually enable sleep mode for your Mac.")

#define KYA_L10N_FORMAT_PREVENTING_SLEEP_FOR_TIME_TITLE NSLocalizedString(@"Preventing Sleep for %@", @"Preventing Sleep for %@")
#define KYA_L10N_PREVENTING_SLEEP_FOR_TIME_TITLE(_str) [NSString stringWithFormat:KYA_L10N_FORMAT_PREVENTING_SLEEP_FOR_TIME_TITLE, (NSString *)(_str)]

#define KYA_L10N_PREVENTING_SLEEP_FOR_TIME_BODY_TEXT NSLocalizedString(@"Afterwards your Mac will automatically go to sleep again when unused.", @"Afterwards your Mac will automatically go to sleep again when unused.")

#define KYA_L10N_ALLOWING_SLEEP_TITLE NSLocalizedString(@"Allowing Sleep", @"Allowing Sleep")

#define KYA_L10N_ALLOWING_SLEEP_BODY_TEXT NSLocalizedString(@"Your Mac will automatically go to sleep when unused.", @"Your Mac will automatically go to sleep when unused.")

#pragma mark - Preferences

#define KYA_L10N_DISABLE_MENU_BAR_ICON_HIGHLIGHT_COLOR NSLocalizedString(@"Disable menu bar icon highlight color", @"Disable menu bar icon highlight color")
#define KYA_L10N_QUIT_ON_TIMER_EXPIRATION NSLocalizedString(@"Quit when activation duration is over", @"Quit when activation duration is over")
#define KYA_L10N_ALLOW_DISPLAY_SLEEP NSLocalizedString(@"Allow the display to sleep", @"Allow the display to sleep")
#define KYA_L10N_ACTIVATE_ON_EXTERNAL_DISPLAY NSLocalizedString(@"Activate when an external display is connected", @"Activate when an external display is connected")
#define KYA_L10N_DEACTIVATE_ON_USER_SWITCH NSLocalizedString(@"Deactivate when switched to another user account", @"Deactivate when switched to another user account")
#define KYA_L10N_DURATIONS_ALERT_REALLY_RESET_TITLE NSLocalizedString(@"Reset Activation Durations", @"Reset Activation Durations")
#define KYA_L10N_DURATIONS_ALERT_REALLY_RESET_MESSAGE NSLocalizedString(@"Do you really want to reset the activation durations to the default values?", @"Do you really want to reset the activation durations to the default values?")

#define KYA_L10N_SET_DEFAULT_ACTIVATION_DURATION(_str) [NSString stringWithFormat:NSLocalizedString(@"Set Default: %@", @"Set Default: %@"), (NSString *)(_str)]
