//
//  KYASettingsContentViewController.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 20.09.21.
//  Copyright © 2021 Marcel Dierkes. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KYASettingsLocalizedStrings.h"

NS_ASSUME_NONNULL_BEGIN

/// A settings content view controller that is represented
/// by a tab view item and loads its view from a Nib file.
@interface KYASettingsContentViewController : NSViewController
/// Creates and returns a new tab view item with
/// a configured view controller.
@property (class, nonatomic, readonly) NSTabViewItem *preferredTabViewItem;

/// A tab bar icon image for this content view controller
/// @note Should be implemented by a subclass.
@property (class, nonatomic, readonly, nullable) NSImage *tabViewItemImage;

/// A tab bar title for this content view controller
/// @note Should be implemented by a subclass.
@property (class, nonatomic, readonly, nullable) NSString *preferredTitle;

/// Resizes the view to its contents when this property return `YES`.
@property (nonatomic, readonly) BOOL resizesView;

/// The designated initializer
- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
