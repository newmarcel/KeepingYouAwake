//
//  NSBundle+KYAUpdateFeed.m
//  KYAKit
//
//  Created by Marcel Dierkes on 26.02.21.
//  Copyright © 2021 Marcel Dierkes. All rights reserved.
//

#import "NSBundle+KYAUpdateFeed.h"
#import "KYADefines.h"

static NSString * const KYAUpdateFeedKey = @"SUFeedURL";

@implementation NSBundle (KYAUpdateFeed)

- (NSString *)kya_updateFeedURLString
{
    Auto feedURLString = (NSString *)self.infoDictionary[KYAUpdateFeedKey];
    NSAssert(feedURLString != nil, @"A feed URL should be set in Info.plist");
    
    return feedURLString;
}

- (NSString *)kya_preReleaseUpdateFeedURLString
{
    Auto feedURLString = self.kya_updateFeedURLString;
    Auto lastComponent = feedURLString.lastPathComponent;
    Auto baseURLString = feedURLString.stringByDeletingLastPathComponent;
    
    return [NSString stringWithFormat:@"%@/prerelease-%@", baseURLString, lastComponent];
}

@end
