//
//  KYASettingsLocalizedStrings.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 20.09.21.
//  Copyright © 2021 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KYA_SETTINGS_LOCALIZED_STRING(__key, __comment) \
    NSLocalizedStringFromTableInBundle( \
    __key, \
    @"KYASettings", \
    NSBundle.mainBundle, \
    __comment)

#define KYA_SETTINGS_L10N_TITLE KYA_SETTINGS_LOCALIZED_STRING(@"KeepingYouAwake – Settings", @"KeepingYouAwake – Settings")

#define KYA_SETTINGS_L10N_GENERAL KYA_SETTINGS_LOCALIZED_STRING(@"General", @"General")
#define KYA_SETTINGS_L10N_ACTIVATION_DURATION KYA_SETTINGS_LOCALIZED_STRING(@"Activation Duration", @"Activation Duration")
#define KYA_SETTINGS_L10N_BATTERY KYA_SETTINGS_LOCALIZED_STRING(@"Battery", @"Battery")
#define KYA_SETTINGS_L10N_ADVANCED KYA_SETTINGS_LOCALIZED_STRING(@"Advanced", @"Advanced")
#define KYA_SETTINGS_L10N_UPDATES KYA_SETTINGS_LOCALIZED_STRING(@"Updates", @"Updates")
#define KYA_SETTINGS_L10N_ABOUT KYA_SETTINGS_LOCALIZED_STRING(@"About", @"About")
