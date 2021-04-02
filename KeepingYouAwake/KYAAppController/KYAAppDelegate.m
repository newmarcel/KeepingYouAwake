//
//  KYAAppDelegate.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 17.10.14.
//  Copyright (c) 2014 Marcel Dierkes. All rights reserved.
//

#import "KYAAppDelegate.h"
#import <Sparkle/Sparkle.h>
#import <KYAKit/KYAKit.h>
#import "KYADefines.h"
#import "KYAPreferencesWindowController.h"

@interface KYAAppDelegate () <NSWindowDelegate, SPUUpdaterDelegate>
@property (nonatomic, nullable) KYAPreferencesWindowController *preferencesWindowController;
@end

@implementation KYAAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
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

- (IBAction)showPreferencesWindow:(id)sender
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

#pragma mark - SPUUpdaterDelegate

- (NSString *)feedURLStringForUpdater:(SPUUpdater *)updater
{
    Auto bundle = NSBundle.mainBundle;
    Auto defaults = NSUserDefaults.standardUserDefaults;
    if([defaults kya_arePreReleaseUpdatesEnabled])
    {
        return bundle.kya_preReleaseUpdateFeedURLString;
    }
    else
    {
        return bundle.kya_updateFeedURLString;
    }
}

@end
