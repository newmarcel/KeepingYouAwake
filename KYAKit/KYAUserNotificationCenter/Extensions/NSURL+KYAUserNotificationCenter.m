//
//  NSURL+KYAUserNotificationCenter.m
//  KYAKit
//
//  Created by Marcel Dierkes on 20.02.21.
//

#import "NSURL+KYAUserNotificationCenter.h"
#import "KYADefines.h"

@implementation NSURL (KYAUserNotificationCenter)

+ (NSURL *)kya_notificationPreferencesURL
{
    return [self URLWithString:@"x-apple.systempreferences:com.apple.preference.notifications"];
}

@end
