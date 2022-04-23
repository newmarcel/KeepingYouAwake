//
//  KYAStatusItemImageProvider.h
//  KYAStatusItemUI
//
//  Created by Marcel Dierkes on 17.08.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/NSImage.h>

NS_ASSUME_NONNULL_BEGIN

/// Provides active and inactive icon images for the status item.
@interface KYAStatusItemImageProvider : NSObject

/// Returns a status item icon provider for either the default
/// or custom icon images.
///
/// @note This class method will always return the same instance
///       during the lifetime of the app.
@property (class, nonatomic, readonly) KYAStatusItemImageProvider *currentProvider;

/// Returns a menu bar icon provider for the built-in icon images.
/// @note This provider requires 'ActiveIcon' and 'InactiveIcon' assets
///       in the main bundle.
@property (class, nonatomic, readonly) KYAStatusItemImageProvider *standardProvider;

/// Returns a status item icon provider for the custom active/inactive
/// icon images from the application container.
@property (class, nonatomic, readonly, nullable) KYAStatusItemImageProvider *customProvider;

/// An icon image representing the active state.
@property (nonatomic, readonly) NSImage *activeIconImage;

/// An icon image representing the inactive state.
@property (nonatomic, readonly) NSImage *inactiveIconImage;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
