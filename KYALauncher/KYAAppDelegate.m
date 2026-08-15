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
    NSArray<NSString *> *pathComponents = NSBundle.mainBundle.bundlePath.pathComponents;
    NSRange pathRange = NSMakeRange(0, pathComponents.count - 4);
    pathComponents = [pathComponents subarrayWithRange:pathRange];

    NSString *path = [NSString pathWithComponents:pathComponents];
    NSURL *appURL = [NSURL fileURLWithPath:path];
    
    if(@available(macOS 11.0, *))
    {
        NSWorkspaceOpenConfiguration *configuration = [NSWorkspaceOpenConfiguration configuration];
        [NSWorkspace.sharedWorkspace openApplicationAtURL:appURL
                                            configuration:configuration
                                        completionHandler:^(NSRunningApplication *app, NSError *error) {
            [NSApplication.sharedApplication terminate:nil];
        }];
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [NSWorkspace.sharedWorkspace launchApplication:path];
#pragma clang diagnostic pop
        [NSApplication.sharedApplication terminate:nil];
    }
}

@end

