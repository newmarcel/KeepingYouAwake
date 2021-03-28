//
//  KYAStatusItemController.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 10.09.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <KYAKit/KYAKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KYAStatusItemControllerDelegate;

/**
 Manages the display and the toggling of the primary status bar icon.
 */
@interface KYAStatusItemController : NSObject

/**
 Toggle
 */
- (void)toggle;

/**
 The underlying system status bar item.
 */
@property (nonatomic, readonly) NSStatusItem *systemStatusItem;

/**
 A delegate for receiving click events.
 */
@property (weak, nonatomic, nullable) id<KYAStatusItemControllerDelegate> delegate;

/**
 Controls the appearance of the status bar item.
 
 YES represents "active" appearance, NO represents "inactive".
 */
@property (nonatomic, getter=isActiveAppearanceEnabled) BOOL activeAppearanceEnabled;

/**
 The designated initializer.

 @return A new instance.
 */
- (instancetype)init NS_DESIGNATED_INITIALIZER;

/**
 Presents the supplied menu anchored underneath the system
 status bar item.

 @param menu A menu.
 */
- (void)showMenu:(NSMenu *)menu;

@end

@protocol KYAStatusItemControllerDelegate <NSObject>
@optional

/**
 Notifies the delegate that the primary click action was invoked.

 @param controller The delegating status item controller
 */
- (void)statusItemControllerShouldPerformMainAction:(KYAStatusItemController *)controller;

/**
 Notifies the delegate that the alternative click action was invoked.
 
 This method will be called for `ctrl`-click, `alt`-click and
 right click events.

 @param controller The delegating status item controller
 */
- (void)statusItemControllerShouldPerformAlternativeAction:(KYAStatusItemController *)controller;

@end

NS_ASSUME_NONNULL_END
