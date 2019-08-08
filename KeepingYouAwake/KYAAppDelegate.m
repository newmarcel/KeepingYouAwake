//
//  KYAAppDelegate.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 17.10.14.
//  Copyright (c) 2014 Marcel Dierkes. All rights reserved.
//

#import "KYAAppDelegate.h"
#import <Sparkle/Sparkle.h>
#import "NSUserDefaults+Keys.h"
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

- (void)showPreferenceWindowAndEditActivationDurations
{
    [self showPreferencesWindow:nil];
    NSTabViewController *tabViewController = (NSTabViewController *)self.preferencesWindowController.window.contentViewController;
    tabViewController.selectedTabViewItemIndex = 1;
}

#pragma mark - Window Delegate

- (void)windowWillClose:(NSNotification *)notification
{
    self.preferencesWindowController = nil;
}

#pragma mark - SPUUpdaterDelegate

- (NSString *)feedURLStringForUpdater:(SPUUpdater *)updater
{
    NSString *feedURLString = NSBundle.mainBundle.infoDictionary[@"SUFeedURL"];
    NSAssert(feedURLString != nil, @"A feed URL should be set in Info.plist");

    if([NSUserDefaults.standardUserDefaults kya_arePreReleaseUpdatesEnabled])
    {
        NSString *lastComponent = feedURLString.lastPathComponent;
        NSString *baseURLString = feedURLString.stringByDeletingLastPathComponent;
        return [NSString stringWithFormat:@"%@/prerelease-%@", baseURLString, lastComponent];
    }

    return feedURLString;
}

@end
