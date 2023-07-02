//
//  KYAAppDelegate.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 17.10.14.
//  Copyright (c) 2014 Marcel Dierkes. All rights reserved.
//

#import "KYAAppDelegate.h"
#import "KYADefines.h"
#import "KYAAppUpdater.h"
#import "KYASettingsWindow.h"
#import "KYAUpdatePreferencesViewController.h"

@interface KYAAppDelegate () <NSWindowDelegate>
@property (weak, nonatomic, nullable) KYASettingsWindow *settingsWindow;
@end

@implementation KYAAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
#if KYA_APP_UPDATER_ENABLED
    [KYAAppUpdater defaultAppUpdater];
#endif
    
    if(@available(macOS 13.0, *))
    {
        [NSApplication.sharedApplication kya_migrateLaunchAtLoginToAppServiceIfNeeded];
    }
}

#pragma mark - Settings Window

- (void)showSettingsWindow:(id)sender
{
    [NSApplication.sharedApplication activateIgnoringOtherApps:YES];
    
    NSArray<NSTabViewItem *> *additionalTabViewItems;
#if KYA_APP_UPDATER_ENABLED
    additionalTabViewItems = @[KYAUpdatePreferencesViewController.preferredTabViewItem];
#endif
    Auto settingsWindow = self.settingsWindow ?: [[KYASettingsWindow alloc] initWithAdditionalTabViewItems:additionalTabViewItems];
    [settingsWindow makeKeyAndOrderFront:sender];
    self.settingsWindow = settingsWindow;
}

@end
