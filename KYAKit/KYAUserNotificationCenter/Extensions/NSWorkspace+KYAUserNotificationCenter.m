//
//  NSWorkspace+KYAUserNotificationCenter.m
//  KYAKit
//
//  Created by Marcel Dierkes on 20.02.21.
//

#import "NSWorkspace+KYAUserNotificationCenter.h"
#import "KYADefines.h"
#import "NSURL+KYAUserNotificationCenter.h"

@implementation NSWorkspace (KYAUserNotificationCenter)

- (void)kya_openNotificationPreferencesWithCompletionHandler:(KYAOpenNotificationsCompletionHandler)completionHandler
{
    Auto prefURL = NSURL.kya_notificationPreferencesURL;
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
