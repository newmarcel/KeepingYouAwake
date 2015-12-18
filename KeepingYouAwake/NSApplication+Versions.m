//
//  NSApplication+Versions.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 18.12.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import "NSApplication+Versions.h"

@implementation NSApplication (Versions)

- (NSString * _Nonnull)kya_shortVersionString
{
    return [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
}

- (NSString * _Nonnull)kya_buildVersionString
{
    return [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
}

- (NSString * _Nonnull)kya_localizedVersionString
{
    NSString *localizedVersionText = NSLocalizedString(@"Version", nil);
    return [NSString stringWithFormat:@"%@ %@ (%@)", localizedVersionText, self.kya_shortVersionString, self.kya_buildVersionString];
}

#pragma mark - Copyright String

- (NSString * _Nonnull)kya_localizedCopyrightString
{
    return [NSBundle mainBundle].infoDictionary[@"NSHumanReadableCopyright"];
}

@end
