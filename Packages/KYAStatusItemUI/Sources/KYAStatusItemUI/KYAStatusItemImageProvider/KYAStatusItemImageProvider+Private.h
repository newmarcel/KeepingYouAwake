//
//  KYAStatusItemImageProvider+Private.h
//  KYAStatusItemUI
//
//  Created by Marcel Dierkes on 30.04.22.
//

#import <Foundation/Foundation.h>
#import <KYAStatusItemUI/KYAStatusItemImageProvider.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYAStatusItemImageProvider ()
@property (nonatomic, readwrite) NSImage *activeIconImage;
@property (nonatomic, readwrite) NSImage *inactiveIconImage;

/// Convenience initializer that bypasses the defaults-driven style lookup
/// and pins the provider to a specific pair of images. Used by the
/// `standardProvider` / `customProvider` class accessors.
- (instancetype)initWithActiveIconName:(NSImage *)activeIcon
                      inactiveIconName:(NSImage *)inactiveIcon;

@end

NS_ASSUME_NONNULL_END
