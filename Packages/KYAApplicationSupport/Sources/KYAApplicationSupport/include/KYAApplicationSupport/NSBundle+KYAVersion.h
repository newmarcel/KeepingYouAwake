//
//  NSBundle+KYAVersion.h
//  KYAApplicationSupport
//
//  Created by Marcel Dierkes on 30.03.21.
//  Copyright © 2021 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (KYAVersion)

/// Returns the marketing version of this bundle, that is set
/// as the `CFBundleShortVersionString` Info.plist value.
/// e.g. 1.2.3
@property (copy, nonatomic, readonly) NSString *kya_shortVersionString;

/// Returns the build number of this bundle, that is set
/// as the `CFBundleVersion` Info.plist value.
/// e.g. 1020301
@property (copy, nonatomic, readonly) NSString *kya_buildVersionString;

/// Returns the full version string by combining the short version and build version.
/// e.g. 1.2.3 (1020301)
@property (copy, nonatomic, readonly) NSString *kya_fullVersionString;

/// Returns the `NSHumanReadableCopyright` Info.plist value for
/// the human-readable copyright.
@property (copy, nonatomic, readonly) NSString *kya_localizedCopyrightString;

@end

NS_ASSUME_NONNULL_END
