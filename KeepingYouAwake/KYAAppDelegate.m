//
//  KYAAppDelegate.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 17.10.14.
//  Copyright (c) 2014 - 2015 Marcel Dierkes. All rights reserved.
//

#import "KYAAppDelegate.h"
#import <Sparkle/Sparkle.h>
#import "NSUserDefaults+Keys.h"

@interface KYAAppDelegate () <NSWindowDelegate, SUUpdaterDelegate>
@property (nonatomic, nullable) NSWindowController *preferencesWindowController;
@end

@implementation KYAAppDelegate

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

#pragma mark - Updater Delegate

- (NSString *)feedURLStringForUpdater:(SUUpdater *)updater
{
    NSString *feedURLString = [NSBundle mainBundle].infoDictionary[@"SUFeedURL"];
    NSAssert(feedURLString != nil, @"A feed URL should be set in Info.plist");
    
    if([[NSUserDefaults standardUserDefaults] kya_arePreReleaseUpdatesEnabled])
    {
        NSString *lastComponent = feedURLString.lastPathComponent;
        NSString *baseURLString = feedURLString.stringByDeletingLastPathComponent;
        return [NSString stringWithFormat:@"%@/prerelease-%@", baseURLString, lastComponent];
    }
    
    return feedURLString;
}

@end
