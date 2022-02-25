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
#import "KYAPreferencesWindowController.h"

@interface KYAAppDelegate () <NSWindowDelegate>
@property (nonatomic, nullable) KYAPreferencesWindowController *preferencesWindowController;
@end

@implementation KYAAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
#if KYA_APP_UPDATER_ENABLED
    [KYAAppUpdater defaultAppUpdater];
#endif
}

#pragma mark - Preferences Window

- (NSWindowController *)preferencesWindowController
{
    if(_preferencesWindowController == nil)
    {
        _preferencesWindowController = [KYAPreferencesWindowController new];
    }
    return _preferencesWindowController;
}

- (void)showPreferencesWindow:(id)sender
{
    [NSApplication.sharedApplication activateIgnoringOtherApps:YES];

    [self.preferencesWindowController showWindow:sender];
    self.preferencesWindowController.window.delegate = self;
}

#pragma mark - Window Delegate

- (void)windowWillClose:(NSNotification *)notification
{
    self.preferencesWindowController = nil;
}

@end
