//
//  KYAMainMenu.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 12.02.22.
//  Copyright © 2022 Marcel Dierkes. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

/// Creates a main menu with common commands like Quit, Preferences… and the
/// activation durations sub menu.
/// @param activationDurationsSubMenu An activation durations sub menu
NSMenu *KYACreateMainMenuWithActivationDurationsSubMenu(NSMenu *activationDurationsSubMenu);

NS_ASSUME_NONNULL_END
