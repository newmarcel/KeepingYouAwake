//
//  KYAPreferencesLocalizedStrings.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 20.09.21.
//  Copyright © 2021 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KYA_PREFS_LOCALIZED_STRING(__key, __comment) \
    NSLocalizedStringFromTableInBundle( \
    __key, \
    @"KYAPreferences", \
    NSBundle.mainBundle, \
    __comment)

#define KYA_PREFS_L10N_PREFERENCES_TITLE KYA_PREFS_LOCALIZED_STRING(@"KeepingYouAwake – Preferences", @"KeepingYouAwake – Preferences")

#define KYA_PREFS_L10N_GENERAL KYA_PREFS_LOCALIZED_STRING(@"General", @"General")
#define KYA_PREFS_L10N_ACTIVATION_DURATION KYA_PREFS_LOCALIZED_STRING(@"Activation Duration", @"Activation Duration")
#define KYA_PREFS_L10N_ADVANCED KYA_PREFS_LOCALIZED_STRING(@"Advanced", @"Advanced")
#define KYA_PREFS_L10N_UPDATES KYA_PREFS_LOCALIZED_STRING(@"Updates", @"Updates")
#define KYA_PREFS_L10N_ABOUT KYA_PREFS_LOCALIZED_STRING(@"About", @"About")
