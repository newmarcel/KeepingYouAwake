//
//  NSBundle+KYAVersion.m
//  KYAKit
//
//  Created by Marcel Dierkes on 30.03.21.
//  Copyright © 2021 Marcel Dierkes. All rights reserved.
//

#import "NSBundle+KYAVersion.h"
#import "KYADefines.h"

static NSString * const KYAShortVersionKey = @"CFBundleShortVersionString";
static NSString * const KYABundleVersionKey = @"CFBundleVersion";
static NSString * const KYACopyrightKey = @"NSHumanReadableCopyright";

@implementation NSBundle (KYAVersion)

- (NSString *)kya_shortVersionString
{
    return self.infoDictionary[KYAShortVersionKey];
}

- (NSString *)kya_buildVersionString
{
    return self.infoDictionary[KYABundleVersionKey];
}

- (NSString *)kya_fullVersionString
{
    return [NSString stringWithFormat:@"%@ (%@)",
            self.kya_shortVersionString,
            self.kya_buildVersionString];
}

#pragma mark - Copyright String

- (NSString *)kya_localizedCopyrightString
{
    return self.infoDictionary[KYACopyrightKey];
}

@end
