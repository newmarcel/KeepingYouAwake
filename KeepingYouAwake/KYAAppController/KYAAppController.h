//
//  KYAAppController.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 17.10.14.
//  Copyright (c) 2014 Marcel Dierkes. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <KYASleepWakeTimer/KYASleepWakeTimer.h>
#import <KYADeviceInfo/KYADeviceInfo.h>
#import <KYAApplicationEvents/KYAApplicationEvents.h>
#import <KYAStatusItemUI/KYAStatusItemUI.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYAAppController : NSObject

/// The associated KYASleepWakeTimer instance of this app controller.
@property (nonatomic, readonly) KYASleepWakeTimer *sleepWakeTimer;

/// Controls the display a action handling for the status bar item.
@property (nonatomic, readonly) KYAStatusItemController *statusItemController;

@end

NS_ASSUME_NONNULL_END
