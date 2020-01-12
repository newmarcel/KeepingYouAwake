//
//  KYAUpdatePreferencesViewController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 30.12.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import "KYAUpdatePreferencesViewController.h"
#import "KYADefines.h"
#import "NSUserDefaults+Keys.h"

@implementation KYAUpdatePreferencesViewController

#pragma mark - SPUUpdaterDelegate

- (NSString *)feedURLStringForUpdater:(SPUUpdater *)updater
{
    NSString *feedURLString = NSBundle.mainBundle.infoDictionary[@"SUFeedURL"];
    NSAssert(feedURLString != nil, @"A feed URL should be set in Info.plist");
    
    if([NSUserDefaults.standardUserDefaults kya_arePreReleaseUpdatesEnabled])
    {
        NSString *lastComponent = feedURLString.lastPathComponent;
        NSString *baseURLString = feedURLString.stringByDeletingLastPathComponent;
        return [NSString stringWithFormat:@"%@/prerelease-%@", baseURLString, lastComponent];
    }
    
    return feedURLString;
}

@end
