//
//  KYAActivationDurationsMenuController.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 07.08.19.
//  Copyright © 2019 Marcel Dierkes. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <KYAKit/KYAKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KYAActivationDurationsMenuControllerDelegate;

/**
 Manages the primary activation durations menu.
 */
@interface KYAActivationDurationsMenuController : NSObject <NSMenuDelegate>

/**
 The model controller that provides the list of activation durations.
 */
@property (nonatomic) KYAActivationDurationsController *activationDurationsController;

/**
 The delegate for receiving user selection events.
 */
@property (weak, nonatomic, nullable) id<KYAActivationDurationsMenuControllerDelegate> delegate;

/**
 The managed activation durations menu.
 
 @note This menu can be attached to another menu item as submenu.
 */
@property (nonatomic, readonly) NSMenu *menu;

/**
 Tells the delegate that the user selected a duration
 by clicking on a menu item.

 @param sender The clicked menu item
 */
- (void)selectActivationDuration:(nullable NSMenuItem *)sender;

@end

/**
 A menu controller delegate that provides status values of
 the sleep wake timer and notifies about user selection.
 */
@protocol KYAActivationDurationsMenuControllerDelegate <NSObject>
@optional

/**
 Returns the currently selected activation duration.

 @return An activation duration or nil of none is active
 */
- (nullable KYAActivationDuration *)currentActivationDuration;

/**
 Returns the fire date of the currently selected activation duration.

 @param controller The delegating menu controller
 @return A fire date or nil of none is active
 */
- (nullable NSDate *)fireDateForMenuController:(KYAActivationDurationsMenuController *)controller;

/**
 Tells the receiver that the user selected an activation duration from the menu.

 @param controller The delegating menu controller
 @param activationDuration The user-selected activation duration
 */
- (void)activationDurationsMenuController:(KYAActivationDurationsMenuController *)controller
              didSelectActivationDuration:(KYAActivationDuration *)activationDuration;
@end

NS_ASSUME_NONNULL_END
