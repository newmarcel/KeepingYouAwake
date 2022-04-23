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

/// The designated initializer for an image provider.
/// @param activeIcon An NSImage representing the active state, a nil value sets the default icon.
/// @param inactiveIcon An NSImage representing the inactive state, a nil value sets the default icon.
- (instancetype)initWithActiveIconName:(NSImage *)activeIcon
                      inactiveIconName:(NSImage *)inactiveIcon NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
