//
//  NSURL+KYAUserNotificationCenter.h
//  KYAUserNotifications
//
//  Created by Marcel Dierkes on 20.02.21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (KYAUserNotificationCenter)
@property (class, nonatomic, readonly) NSURL *kya_notificationSettingsURL;
@end

NS_ASSUME_NONNULL_END
