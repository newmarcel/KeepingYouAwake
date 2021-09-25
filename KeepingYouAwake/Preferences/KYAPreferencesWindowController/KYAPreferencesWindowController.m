//
//  KYAPreferencesWindowController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 30.12.16.
//  Copyright © 2016 Marcel Dierkes. All rights reserved.
//

#import "KYAPreferencesWindowController.h"
#import "KYADefines.h"
#import "KYAPreferencesContentViewControllers.h"

@interface KYAPreferencesWindowController ()
@property (nonatomic) NSTabViewController *tabViewController;
@end

@implementation KYAPreferencesWindowController

#pragma mark - Life Cycle

- (instancetype)init
{
    Auto nibName = NSStringFromClass([self class]);
    self = [super initWithWindowNibName:nibName];
    if(self)
    {
        self.windowFrameAutosaveName = @"PreferencesWindow";
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    self.window.title = KYA_PREFS_L10N_PREFERENCES_TITLE;
    
    [self configureTabViewController];
}

#pragma mark - Tab View Controller

- (void)configureTabViewController
{
    Auto tabViewController = [NSTabViewController new];
    tabViewController.tabStyle = NSTabViewControllerTabStyleToolbar;
    tabViewController.transitionOptions = NSViewControllerTransitionNone;
    tabViewController.tabViewItems = @[
        KYAGeneralPreferencesViewController.preferredTabViewItem,
        KYADurationPreferencesViewController.preferredTabViewItem,
        KYAAdvancedPreferencesViewController.preferredTabViewItem,
        KYAUpdatePreferencesViewController.preferredTabViewItem,
        KYAAboutPreferencesViewController.preferredTabViewItem
    ];
    
    self.tabViewController = tabViewController;
    self.contentViewController = tabViewController;
}

#pragma mark - NSResponder

- (void)keyDown:(NSEvent *)event
{
    if(event.type != NSEventTypeKeyDown) { return; }
    if((event.modifierFlags & NSEventModifierFlagCommand) == 0) { return; }
    
    if([event.characters isEqualToString:@"q"])
    {
        [NSApplication.sharedApplication terminate:self];
    }
    if([event.characters isEqualToString:@"w"])
    {
        [self close];
    }
}

@end
