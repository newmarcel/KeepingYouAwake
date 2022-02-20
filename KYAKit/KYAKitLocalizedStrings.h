//
//  KYAKitLocalizedStrings.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 05.03.21.
//  Copyright © 2021 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KYA_LOCALIZED_STRING(__key, __comment) \
    NSLocalizedStringFromTableInBundle( \
    __key, nil, \
    [NSBundle bundleForClass:NSClassFromString(@"KYASleepWakeTimer")], \
    __comment)

#define KYA_L10N_INDEFINITELY KYA_LOCALIZED_STRING(@"Indefinitely", @"Indefinitely")

#define KYA_L10N_VERSION KYA_LOCALIZED_STRING(@"Version", @"Version")
