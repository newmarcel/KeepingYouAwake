//
//  KYAKit.h
//  KYAKit
//
//  Created by Marcel Dierkes on 26.02.21.
//  Copyright © 2021 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Project version number for KYAKit.
FOUNDATION_EXPORT double KYAKitVersionNumber;

/// Project version string for KYAKit.
FOUNDATION_EXPORT const unsigned char KYAKitVersionString[];

#import <KYAKit/KYAActivationDuration.h>
#import <KYAKit/KYAActivationDurationsController.h>
#import <KYAKit/KYAEvent.h>
#import <KYAKit/KYAEventHandler.h>
#import <KYAKit/KYASleepWakeTimer.h>
#import <KYAKit/KYAUserNotificationCenter.h>

#import <KYAKit/NSApplication+KYALauncher.h>
#import <KYAKit/NSBundle+KYAVersion.h>
#import <KYAKit/NSDate+RemainingTime.h>
#import <KYAKit/NSUserDefaults+Keys.h>
#import <KYAKit/NSURL+KYAUserNotificationCenter.h>
#import <KYAKit/NSWorkspace+KYAUserNotificationCenter.h>
