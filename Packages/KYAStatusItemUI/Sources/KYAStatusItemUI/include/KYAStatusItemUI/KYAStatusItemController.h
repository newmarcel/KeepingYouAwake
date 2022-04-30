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

@protocol KYAStatusItemControllerDataSource;
@protocol KYAStatusItemControllerDelegate;

/// Manages the display and interaction with the menu bar status item.
@interface KYAStatusItemController : NSObject

/// The underlying system status bar item.
@property (nonatomic, readonly) NSStatusItem *systemStatusItem;

/// A delegate for receiving click events.
@property (weak, nonatomic, nullable) id<KYAStatusItemControllerDataSource> dataSource;

/// A delegate for receiving click events.
@property (weak, nonatomic, nullable) id<KYAStatusItemControllerDelegate> delegate;

/// Controls the appearance of the status bar item.
/// YES represents "active" appearance, NO represents "inactive".
@property (nonatomic, getter=isActiveAppearanceEnabled) BOOL activeAppearanceEnabled;

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
