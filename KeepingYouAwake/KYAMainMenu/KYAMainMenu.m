//
//  KYAMainMenu.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 12.02.22.
//  Copyright © 2022 Marcel Dierkes. All rights reserved.
//

#import "KYAMainMenu.h"
#import "KYADefines.h"
#import "KYALocalizedStrings.h"
#import "KYAAppDelegate.h"

NSMenu *KYACreateMainMenuWithActivationDurationsSubMenu(NSMenu *activationDurationsSubMenu)
{
    NSCParameterAssert(activationDurationsSubMenu);
    
    Auto mainMenu = [[NSMenu alloc] initWithTitle:@""];
    
    Auto activateForDuration = [[NSMenuItem alloc] initWithTitle:KYA_L10N_ACTIVATE_FOR_DURATION
                                                          action:nil
                                                   keyEquivalent:@""];
    activateForDuration.submenu = activationDurationsSubMenu;
    [mainMenu addItem:activateForDuration];
    
    [mainMenu addItem:NSMenuItem.separatorItem];
    
    Auto preferences = [[NSMenuItem alloc] initWithTitle:KYA_L10N_PREFERENCES
                                                  action:@selector(showPreferencesWindow:)
                                           keyEquivalent:@","];
    [mainMenu addItem:preferences];
    
    [mainMenu addItem:NSMenuItem.separatorItem];
    
    Auto quit = [[NSMenuItem alloc] initWithTitle:KYA_L10N_QUIT
                                           action:@selector(terminate:)
                                    keyEquivalent:@"q"];
    [mainMenu addItem:quit];
    
    return mainMenu;
}
