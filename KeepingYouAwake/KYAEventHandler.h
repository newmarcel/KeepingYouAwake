//
//  KYAEventHandler.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 31.03.15.
//  Copyright (c) 2014 - 2015 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KYAEvent.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^KYAEventHandlerActionBlock)(KYAEvent *event);

@interface KYAEventHandler : NSObject

+ (instancetype)mainHandler;

- (void)registerActionNamed:(NSString *)actionName block:(KYAEventHandlerActionBlock)block;
- (void)removeActionNamed:(NSString *)actionName;

- (void)handleEventForURL:(NSURL *)URL;

@end

NS_ASSUME_NONNULL_END
