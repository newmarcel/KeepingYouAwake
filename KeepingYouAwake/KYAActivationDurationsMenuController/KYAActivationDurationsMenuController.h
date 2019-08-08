//
//  KYAActivationDurationsMenuController.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 07.08.19.
//  Copyright © 2019 Marcel Dierkes. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KYAActivationDurationsController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol KYAActivationDurationsMenuControllerDelegate;

@interface KYAActivationDurationsMenuController : NSObject <NSMenuDelegate>
@property (nonatomic) KYAActivationDurationsController *activationDurationsController;
@property (weak, nonatomic, nullable) id<KYAActivationDurationsMenuControllerDelegate> delegate;
@property (nonatomic, readonly) NSMenu *menu;

- (void)selectActivationDuration:(nullable NSMenuItem *)sender;

@end

@protocol KYAActivationDurationsMenuControllerDelegate <NSObject>
@optional
- (nullable KYAActivationDuration *)currentActivationDuration;

- (nullable NSDate *)fireDateForMenuController:(KYAActivationDurationsMenuController *)controller;

- (void)activationDurationsMenuController:(KYAActivationDurationsMenuController *)controller
              didSelectActivationDuration:(KYAActivationDuration *)activationDuration;
@end

NS_ASSUME_NONNULL_END
