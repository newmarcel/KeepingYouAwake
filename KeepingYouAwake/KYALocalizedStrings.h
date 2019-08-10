//
//  KYALocalizedStrings.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 03.05.19.
//  Copyright © 2019 Marcel Dierkes. All rights reserved.
//

#ifndef KYA_LOCALIZED_STRINGS_H
#define KYA_LOCALIZED_STRINGS_H

#import <Foundation/Foundation.h>

#define KYA_L10N_ALLOWING_YOUR_MAC_TO_GO_TO_SLEEP NSLocalizedString(@"Allowing your Mac to go to sleep…", @"Allowing your Mac to go to sleep…")
#define KYA_L10N_PREVENTING_YOUR_MAC_FROM_GOING_TO_SLEEP NSLocalizedString(@"Preventing your Mac from going to sleep…", @"Preventing your Mac from going to sleep…")

#define KYA_L10N_FORMAT_PREVENTING_SLEEP_FOR_REMAINING_TIME NSLocalizedString(@"Preventing your Mac from going to sleep for\n%@…", @"Preventing your Mac from going to sleep for\n%@…")
#define KYA_L10N_PREVENTING_SLEEP_FOR_REMAINING_TIME(_str) [NSString stringWithFormat:KYA_L10N_FORMAT_PREVENTING_SLEEP_FOR_REMAINING_TIME, (NSString *)(_str)]

#define KYA_L10N_INDEFINITELY NSLocalizedString(@"Indefinitely", @"Indefinitely")

#pragma mark - Preferences

#define KYA_L10N_ENABLE_EXPERIMENTAL_NOTIFICATION_CENTER_INTEGRATION NSLocalizedString(@"Enable experimental Notification Center integration", @"Enable experimental Notification Center integration")
#define KYA_L10N_DISABLE_MENU_BAR_ICON_HIGHLIGHT_COLOR NSLocalizedString(@"Disable menu bar icon highlight color", @"Disable menu bar icon highlight color")
#define KYA_L10N_QUIT_ON_TIMER_EXPIRATION NSLocalizedString(@"Quit when activation duration is over", @"Quit when activation duration is over")

#endif /* KYA_LOCALIZED_STRINGS_H */
