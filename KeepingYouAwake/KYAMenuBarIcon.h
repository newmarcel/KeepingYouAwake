//
//  KYAMenuBarIcon.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 17.08.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/NSImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYAMenuBarIcon : NSObject

/**
 *  An icon image representing the active state.
 */
@property (nonatomic, readonly) NSImage *activeIcon;

/**
 *  An icon image representing the inactive state.
 */
@property (nonatomic, readonly) NSImage *inactiveIcon;

/**
 *  Returns a menubar icon set for either the default icon
 *  or a set of custom icons from the application support
 *  directory.
 *
 *  @return A KYAMenuBarIcon instance.
 */
+ (instancetype)currentIcon;

/**
 *  Returns a menubar icon set for the default
 *  KeepingYouAwake menubar icon.
 *
 *  @return A KYAMenuBarIcon instance.
 */
+ (instancetype)defaultIcon;

/**
 *  The designated initializer for a menubar icon.
 *
 *  @param activeIcon   An NSImage representing the active state, a nil value sets the default icon.
 *  @param inactiveIcon An NSImage representing the inactive state, a nil value sets the default icon.
 *
 *  @return A KYAMenuBarIcon instance.
 */
- (instancetype)initWithActiveIcon:(nullable NSImage *)activeIcon inactiveIcon:(nullable NSImage *)inactiveIcon NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
