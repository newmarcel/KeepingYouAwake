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
    NSURL *appURL = [NSURL fileURLWithPath:path isDirectory:YES];
    NSWorkspaceOpenConfiguration *configuration = [NSWorkspaceOpenConfiguration configuration];
    [NSWorkspace.sharedWorkspace openApplicationAtURL:appURL
                                        configuration:configuration
                                    completionHandler:^(NSRunningApplication * _Nullable app, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSApplication.sharedApplication terminate:nil];
        });
    }];
}

@end
