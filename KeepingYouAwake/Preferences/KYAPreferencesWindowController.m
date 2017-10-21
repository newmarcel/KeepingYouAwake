//
//  KYAPreferencesWindowController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 30.12.16.
//  Copyright © 2016 Marcel Dierkes. All rights reserved.
//

#import "KYAPreferencesWindowController.h"

@interface KYAPreferencesWindowController ()
@end

@implementation KYAPreferencesWindowController

#pragma mark - Life Cycle

+ (instancetype)preferencesWindowController
{
    return [[NSStoryboard storyboardWithName:@"Preferences" bundle:nil] instantiateInitialController];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    self.windowFrameAutosaveName = @"PreferencesWindow";
}

#pragma mark - NSResponder

- (void)keyDown:(NSEvent *)event
{
    if(event.type != NSKeyDown) { return; }
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
