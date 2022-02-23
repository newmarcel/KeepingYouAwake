//
//  NSApplication+KYALauncher.h
//  KYAApplicationSupport
//
//  Created by Marcel Dierkes on 25.12.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

/**
 An NSApplication category to simply enable or disable the application
 as login item for the currently logged in user.
 
 This uses `KYALauncher` as helper application.
 */
@interface NSApplication (KYALauncher)

/**
 Control if the app should be launched at login.
 
 Adapted from http://blog.mcohen.me/2012/01/12/login-items-in-the-sandbox/
 */
@property (nonatomic, getter=kya_isLaunchAtLoginEnabled) BOOL kya_launchAtLoginEnabled;

@end

NS_ASSUME_NONNULL_END
