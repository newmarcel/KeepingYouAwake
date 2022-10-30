//
//  NSApplication+KYALaunchAtLogin.h
//  KYAApplicationSupport
//
//  Created by Marcel Dierkes on 25.12.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSApplication (KYALaunchAtLogin)

/// Launches the app at login when enabled
@property (nonatomic, getter=kya_isLaunchAtLoginEnabled) BOOL kya_launchAtLoginEnabled;

/// Migrates the application login service from `SMLoginItemSetEnabled` to
/// `SMAppService` on macOS 13.0.
- (void)kya_migrateLaunchAtLoginToAppServiceIfNeeded API_AVAILABLE(macos(13.0));

@end

NS_ASSUME_NONNULL_END
