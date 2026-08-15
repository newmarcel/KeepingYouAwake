//
//  KYAUpdateSettingsViewController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 30.12.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import "KYAUpdateSettingsViewController.h"
#import <KYACommon/KYACommon.h>

#if KYA_APP_UPDATER_ENABLED

@implementation KYAUpdateSettingsViewController

+ (NSImage *)tabViewItemImage
{
    return [NSImage imageWithSystemSymbolName:@"network" accessibilityDescription:nil];
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
