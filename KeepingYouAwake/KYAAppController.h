//
//  KYAAppController.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 17.10.14.
//  Copyright (c) 2014 Marcel Dierkes. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@class KYASleepWakeTimer, KYAStatusItemController;

@interface KYAAppController : NSObject

/**
 The associated KYASleepWakeTimer instance of this app controller.
 */
@property (nonatomic, readonly) KYASleepWakeTimer *sleepWakeTimer;

/**
 Controls the display a action handling for the status bar item.
 */
@property (nonatomic, readonly) KYAStatusItemController *statusItemController;

@end

NS_ASSUME_NONNULL_END
