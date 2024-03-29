//
//  NSURL+KYAUserNotificationCenter.m
//  KYAUserNotifications
//
//  Created by Marcel Dierkes on 20.02.21.
//

#import <KYAUserNotifications/NSURL+KYAUserNotificationCenter.h>
#import <KYACommon/KYACommon.h>

@implementation NSURL (KYAUserNotificationCenter)

+ (NSURL *)kya_notificationSettingsURL
{
    return [self URLWithString:@"x-apple.systempreferences:com.apple.preference.notifications"];
}

@end
