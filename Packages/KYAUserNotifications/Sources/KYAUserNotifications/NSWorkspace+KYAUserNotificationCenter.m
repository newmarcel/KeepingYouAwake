//
//  NSWorkspace+KYAUserNotificationCenter.m
//  KYAUserNotifications
//
//  Created by Marcel Dierkes on 20.02.21.
//

#import <KYAUserNotifications/NSWorkspace+KYAUserNotificationCenter.h>
#import <KYACommon/KYACommon.h>
#import <KYAUserNotifications/NSURL+KYAUserNotificationCenter.h>

@implementation NSWorkspace (KYAUserNotificationCenter)

- (void)kya_openNotificationSettingsWithCompletionHandler:(KYAOpenNotificationsCompletionHandler)completionHandler
{
    Auto prefURL = NSURL.kya_notificationSettingsURL;
    Auto config = [NSWorkspaceOpenConfiguration configuration];
    config.addsToRecentItems = NO;
    
    [self openApplicationAtURL:prefURL
                 configuration:config
             completionHandler:^(NSRunningApplication *app, NSError *error) {
        if(completionHandler != nil)
        {
            completionHandler(app, error);
        }
    }];
}

@end
