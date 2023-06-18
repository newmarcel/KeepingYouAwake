//
//  KYAUpdatePreferencesViewController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 30.12.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import "KYAUpdatePreferencesViewController.h"
#import "KYADefines.h"

#if KYA_APP_UPDATER_ENABLED

@implementation KYAUpdatePreferencesViewController

+ (NSImage *)tabViewItemImage
{
    if(@available(macOS 11.0, *))
    {
        return [NSImage imageWithSystemSymbolName:@"network"
                         accessibilityDescription:nil];
    }
    else
    {
        return [NSImage imageNamed:NSImageNameNetwork];
    }
}

+ (NSString *)preferredTitle
{
    return KYA_SETTINGS_L10N_UPDATES;
}

- (BOOL)resizesView
{
    return NO;
}

#pragma mark -

- (KYAAppUpdater *)appUpdater
{
    return KYAAppUpdater.defaultAppUpdater;
}

- (void)checkForUpdates:(id)sender
{
    [self.appUpdater checkForUpdates:sender];
}

@end

#endif
