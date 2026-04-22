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

@protocol KYAStatusItemControllerDataSource;
@protocol KYAStatusItemControllerDelegate;

/// Manages the display and interaction with the menu bar status item.
@interface KYAStatusItemController : NSObject

/// The underlying system status bar item.
@property (nonatomic, readonly) NSStatusItem *systemStatusItem;

/// Controls the activate/inactive appearance of the status item image.
@property (nonatomic) KYAStatusItemAppearance appearance;

/// The date at which the timer will fire. When set to a non-nil date and the
/// user has opted in (`kya_showRemainingTimeInMenuBar`), the controller will
/// render a live-updating remaining-time label next to the status item icon.
@property (copy, nonatomic, nullable) NSDate *fireDate;

/// The date at which the active session started. When set and `fireDate` is
/// nil (indefinite activation), the controller renders a live-updating
/// elapsed-time label next to the status item icon.
@property (copy, nonatomic, nullable) NSDate *startDate;

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
