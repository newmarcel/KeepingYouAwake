//
//  KYAAppDelegate.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 17.10.14.
//  Copyright (c) 2014 Marcel Dierkes. All rights reserved.
//

#import "KYAAppDelegate.h"

@interface KYAAppDelegate ()
@end

@implementation KYAAppDelegate
{
    NSWindowController *_preferencesWindowController;  // TODO: Make a property
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self showPreferencesWindow:nil];  // TODO: Remove
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
}

#pragma mark - Preferences Window

- (IBAction)showPreferencesWindow:(id)sender
{
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    
    if(_preferencesWindowController == nil)
    {
        _preferencesWindowController = [[NSStoryboard storyboardWithName:@"Preferences" bundle:nil] instantiateInitialController];
    }
    [_preferencesWindowController showWindow:sender];
}

@end
