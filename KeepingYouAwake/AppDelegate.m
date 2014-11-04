//
//  AppDelegate.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 17.10.14.
//  Copyright (c) 2014 Marcel Dierkes. All rights reserved.
//

#import "AppDelegate.h"
#import "KYASleepWakeController.h"

@interface AppDelegate ()
@property (weak, nonatomic) IBOutlet KYASleepWakeController *sleepWakeController;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Request to resume on login
    [[NSApplication sharedApplication] enableRelaunchOnLogin];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
}

@end
