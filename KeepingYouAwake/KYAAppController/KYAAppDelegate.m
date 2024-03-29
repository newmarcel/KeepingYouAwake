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
#import "KYAUpdateSettingsViewController.h"

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
    
    AutoVar settingsWindow = self.settingsWindow;
    if(settingsWindow == nil)
    {
        NSArray<NSTabViewItem *> *additionalTabViewItems;
#if KYA_APP_UPDATER_ENABLED
        additionalTabViewItems = @[KYAUpdateSettingsViewController.preferredTabViewItem];
#endif
        settingsWindow = [[KYASettingsWindow alloc] initWithAdditionalTabViewItems:additionalTabViewItems];
        self.settingsWindow = settingsWindow;
    }
    [settingsWindow makeKeyAndOrderFront:sender];
}

@end
