//
//  KYAEventHandler.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 31.03.15.
//  Copyright (c) 2015 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KYAEvent.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^KYAEventHandlerActionBlock)(KYAEvent *event);

@interface KYAEventHandler : NSObject

/**
 *  Returns the main event handle for the current app.
 *
 *  @return A KYAEventHandler instance.
 */
+ (instancetype)mainHandler;

/**
 *  Registers a block that will be executed when an event with the supplied actionName
 *  is executed.
 *
 *  @param actionName An action identifier.
 *  @param block      A block.
 */
- (void)registerActionNamed:(NSString *)actionName block:(KYAEventHandlerActionBlock)block;

/**
 *  Removes the registered action and block with the supplied actionName.
 *
 *  @param actionName An action identifier.
 */
- (void)removeActionNamed:(NSString *)actionName;

/**
 *  Call this method with a callback URL. The URL will be
 *  tokenized and any action that matches the token will be executed.
 *
 *  @param URL A callback URL.
 */
- (void)handleEventForURL:(NSURL *)URL;

@end

NS_ASSUME_NONNULL_END
