//
//  KYAActivationDurationsMenuController.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 07.08.19.
//  Copyright © 2019 Marcel Dierkes. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYAActivationDurationsMenuController : NSObject <NSMenuDelegate>
@property (nonatomic, readonly) NSMenu *menu;

- (void)selectActivationDuration:(nullable NSMenuItem *)sender;

@end

NS_ASSUME_NONNULL_END
