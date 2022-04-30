//
//  KYAStatusItemController.h
//  KYAStatusItemUI
//
//  Created by Marcel Dierkes on 10.09.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <KYAApplicationSupport/KYAApplicationSupport.h>

NS_ASSUME_NONNULL_BEGIN

/// The appearance of the status item icon image.
typedef NS_ENUM(NSUInteger, KYAStatusItemAppearance)
{
    /// Represents the inactive state of the status bar item
    KYAStatusItemAppearanceInactive = 0,
    /// Represents the active state of the status bar item
    KYAStatusItemAppearanceActive
};

typedef NS_ENUM(NSUInteger, KYAStatusItemInteractionMode)
{
    /// An interaction mode where the primary click activates the
    /// sleep wake timer and the alternative click shows a menu.
    KYAStatusItemInteractionModeActivateAndShowMenu = 0,
    /// An interaction mode where the primary click and the
    /// alternative click both show a menu.
    KYAStatusItemInteractionModeAlwaysShowMenu,
};

@protocol KYAStatusItemControllerDataSource;
@protocol KYAStatusItemControllerDelegate;

/// Manages the display and interaction with the menu bar status item.
@interface KYAStatusItemController : NSObject

/// The underlying system status bar item.
@property (nonatomic, readonly) NSStatusItem *systemStatusItem;

/// Controls the activate/inactive appearance of the status item image.
@property (nonatomic) KYAStatusItemAppearance appearance;

/// The click interaction mode of the status item.
@property (nonatomic) KYAStatusItemInteractionMode interactionMode;

/// A delegate for receiving click events.
@property (weak, nonatomic, nullable) id<KYAStatusItemControllerDataSource> dataSource;

/// A delegate for receiving click events.
@property (weak, nonatomic, nullable) id<KYAStatusItemControllerDelegate> delegate;

/// The designated initializer.
- (instancetype)init NS_DESIGNATED_INITIALIZER;

@end

@protocol KYAStatusItemControllerDataSource <NSObject>
@optional
/// The menu that is displayed when the status item is clicked.
- (nullable NSMenu *)menuForStatusItemController:(KYAStatusItemController *)controller;
@end

@protocol KYAStatusItemControllerDelegate <NSObject>
@optional
/// Notifies the delegate that the primary click action was invoked.
/// @param controller The delegating status item controller
- (void)statusItemControllerShouldPerformPrimaryAction:(KYAStatusItemController *)controller;
@end

NS_ASSUME_NONNULL_END
