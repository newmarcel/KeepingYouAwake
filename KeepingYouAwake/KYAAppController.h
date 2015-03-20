//
//  KYAAppController.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 17.10.14.
//  Copyright (c) 2014 - 2015 Marcel Dierkes. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class KYASleepWakeTimer;

@interface KYAAppController : NSObject <NSMenuDelegate>
@property (strong, nonatomic, readonly) KYASleepWakeTimer *sleepWakeTimer;

@end
