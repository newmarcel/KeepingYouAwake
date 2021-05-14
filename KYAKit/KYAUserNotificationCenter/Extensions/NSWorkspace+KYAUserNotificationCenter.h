//
//  NSWorkspace+KYAUserNotificationCenter.h
//  KYAKit
//
//  Created by Marcel Dierkes on 20.02.21.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^KYAOpenNotificationsCompletionHandler)(NSRunningApplication *_Nullable,
                                                     NSError *_Nullable);

@interface NSWorkspace (KYAUserNotificationCenter)

/// Opens the notifications pane in System Preferences.
/// @param completionHandler An optional completion handler, called on a private queue
- (void)kya_openNotificationPreferencesWithCompletionHandler:(nullable KYAOpenNotificationsCompletionHandler)completionHandler API_AVAILABLE(macos(11.0));

@end

NS_ASSUME_NONNULL_END
