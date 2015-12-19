//
//  KYAAppDelegate.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 17.10.14.
//  Copyright (c) 2014 Marcel Dierkes. All rights reserved.
//

#import "KYAAppDelegate.h"

@interface KYAAppDelegate () <NSWindowDelegate>
@property (nonatomic, nullable) NSWindowController *preferencesWindowController;
@end

@implementation KYAAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self showPreferencesWindow:nil];  // TODO: Remove
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
}

#pragma mark - Preferences Window

- (NSWindowController *)preferencesWindowController
{
    if(_preferencesWindowController == nil)
    {
        _preferencesWindowController = [[NSStoryboard storyboardWithName:@"Preferences" bundle:nil] instantiateInitialController];
    }
    return _preferencesWindowController;
}

- (IBAction)showPreferencesWindow:(id)sender
{
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    
    [self.preferencesWindowController showWindow:sender];
    self.preferencesWindowController.window.delegate = self;
}

#pragma mark - Window Delegate

- (void)windowWillClose:(NSNotification *)notification
{
    self.preferencesWindowController = nil;
}

@end
