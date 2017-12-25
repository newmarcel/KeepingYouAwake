//
//  KYAAppDelegate.m
//  KeepingYouAwake Launcher
//
//  Created by Marcel Dierkes on 25.12.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import "KYAAppDelegate.h"

@implementation KYAAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSArray *pathComponents = NSBundle.mainBundle.bundlePath.pathComponents;
    pathComponents = [pathComponents subarrayWithRange:NSMakeRange(0, pathComponents.count - 4)];
    NSString *path = [NSString pathWithComponents:pathComponents];
    [[NSWorkspace sharedWorkspace] launchApplication:path];
    
    [NSApplication.sharedApplication terminate:nil];
}

@end
