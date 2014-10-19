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
@property (strong, nonatomic) KYASleepWakeController *sleepWakeController;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.sleepWakeController = [[KYASleepWakeController alloc] init];
    
    // Request to resume on login
    [[NSApplication sharedApplication] enableRelaunchOnLogin];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
}

@end
