//
//  KYAMainMenu.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 12.02.22.
//  Copyright © 2022 Marcel Dierkes. All rights reserved.
//

#import "KYAMainMenu.h"
#import <KYACommon/KYACommon.h>
#import "KYALocalizedStrings.h"
#import "KYAAppDelegate.h"

NSMenu *KYACreateMainMenuWithActivationDurationsSubMenu(NSMenu *activationDurationsSubMenu)
{
    NSCParameterAssert(activationDurationsSubMenu);
    
    Auto mainMenu = [[NSMenu alloc] initWithTitle:@""];
    
    Auto activateForDuration = [[NSMenuItem alloc] initWithTitle:KYA_L10N_ACTIVATE_FOR_DURATION
                                                          action:nil
                                                   keyEquivalent:@""];
    if(@available(macOS 26.0, *))
    {
        activateForDuration.image = [NSImage imageWithSystemSymbolName:@"timer" accessibilityDescription:nil];
    }
    activateForDuration.submenu = activationDurationsSubMenu;
    [mainMenu addItem:activateForDuration];

    [mainMenu addItem:NSMenuItem.separatorItem];

    Auto allowDisplaySleep = [[NSMenuItem alloc] initWithTitle:KYA_L10N_ALLOW_DISPLAY_SLEEP
                                                       action:@selector(toggleAllowDisplaySleep:)
                                                keyEquivalent:@""];
    allowDisplaySleep.target = NSApplication.sharedApplication.delegate;
    [mainMenu addItem:allowDisplaySleep];

    [mainMenu addItem:NSMenuItem.separatorItem];
    
    Auto settings = [[NSMenuItem alloc] initWithTitle:KYA_L10N_SETTINGS_ELLIPSIS
                                               action:@selector(showSettingsWindow:)
                                        keyEquivalent:@","];
    if(@available(macOS 26.0, *))
    {
        settings.image = [NSImage imageWithSystemSymbolName:@"gear" accessibilityDescription:nil];
    }
    [mainMenu addItem:settings];
    
    [mainMenu addItem:NSMenuItem.separatorItem];
    
    Auto quit = [[NSMenuItem alloc] initWithTitle:KYA_L10N_QUIT
                                           action:@selector(terminate:)
                                    keyEquivalent:@"q"];
    [mainMenu addItem:quit];
    
    return mainMenu;
}
