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

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Request to resume on login
    [[NSApplication sharedApplication] enableRelaunchOnLogin];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
}

@end
