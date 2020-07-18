//
//  KYAPreferencesWindowController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 30.12.16.
//  Copyright © 2016 Marcel Dierkes. All rights reserved.
//

#import "KYAPreferencesWindowController.h"
#import "KYADefines.h"

@interface KYAPreferencesWindowController ()
@end

@implementation KYAPreferencesWindowController

#pragma mark - Life Cycle

- (instancetype)init
{
    self = [[NSStoryboard storyboardWithName:@"Preferences" bundle:nil] instantiateInitialController];
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    self.windowFrameAutosaveName = @"PreferencesWindow";
    
#if KYA_SDK_IS_MACOS_11
    if(@available(macOS 10.16, *))
    {
        [self updateTabViewItems];
    }
#endif
}

- (void)updateTabViewItems
{
#if KYA_SDK_IS_MACOS_11
    if(@available(macOS 10.16, *))
    {
        KYA_AUTO tabController = (NSTabViewController *)self.contentViewController;
        KYA_AUTO tabViewItems = tabController.tabViewItems;
        
        tabViewItems[0].image = [NSImage imageWithSystemSymbolName:@"gearshape"
                                          accessibilityDescription:nil];
        tabViewItems[1].image = [NSImage imageWithSystemSymbolName:@"timer"
                                          accessibilityDescription:nil];
        tabViewItems[2].image = [NSImage imageWithSystemSymbolName:@"gearshape.2"
                                          accessibilityDescription:nil];
        tabViewItems[3].image = [NSImage imageWithSystemSymbolName:@"network"
                                          accessibilityDescription:nil];
        tabViewItems[4].image = [NSImage imageWithSystemSymbolName:@"info.circle"
                                          accessibilityDescription:nil];
    }
#endif
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
