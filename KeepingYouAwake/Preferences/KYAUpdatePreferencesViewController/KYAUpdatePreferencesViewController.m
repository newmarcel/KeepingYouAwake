//
//  KYAUpdatePreferencesViewController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 30.12.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import "KYAUpdatePreferencesViewController.h"
#import "KYADefines.h"

@implementation KYAUpdatePreferencesViewController

+ (NSImage *)tabViewItemImage
{
    if(@available(macOS 11.0, *))
    {
        return [NSImage imageWithSystemSymbolName:@"network"
                         accessibilityDescription:nil];
    }
    else
    {
        return [NSImage imageNamed:NSImageNameNetwork];
    }
}

+ (NSString *)preferredTitle
{
    return KYA_PREFS_L10N_UPDATES;
}

- (BOOL)resizesView
{
    return NO;
}

#pragma mark - SPUUpdaterDelegate

- (NSString *)feedURLStringForUpdater:(SPUUpdater *)updater
{
    NSString *feedURLString = NSBundle.mainBundle.infoDictionary[@"SUFeedURL"];
    NSAssert(feedURLString != nil, @"A feed URL should be set in Info.plist");
    
    if([NSUserDefaults.standardUserDefaults kya_arePreReleaseUpdatesEnabled])
    {
        Auto lastComponent = feedURLString.lastPathComponent;
        Auto baseURLString = feedURLString.stringByDeletingLastPathComponent;
        return [NSString stringWithFormat:@"%@/prerelease-%@", baseURLString, lastComponent];
    }
    
    return feedURLString;
}

@end
