//
//  KYAUserNotificationCenter.h
//  KYAKit
//
//  Created by Marcel Dierkes on 13.02.21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class KYAUserNotification;

typedef NS_ENUM(NSUInteger, KYAUserNotificationAuthorizationStatus) {
    KYAUserNotificationAuthorizationStatusUndetermined = 0,
    KYAUserNotificationAuthorizationStatusGranted,
    KYAUserNotificationAuthorizationStatusDenied,
};

typedef void(^KYAUserNotificationsAuthorizationCompletion)(KYAUserNotificationAuthorizationStatus, NSError *_Nullable);

API_AVAILABLE(macos(11.0))
@interface KYAUserNotificationCenter : NSObject
@property (class, nonatomic, readonly) KYAUserNotificationCenter *sharedCenter;

- (void)getAuthorizationStatusWithCompletion:(void(NS_NOESCAPE ^)(KYAUserNotificationAuthorizationStatus))completion;
- (void)requestAuthorizationWithCompletion:(nullable NS_NOESCAPE KYAUserNotificationsAuthorizationCompletion)completion;
- (void)requestAuthorizationIfUndetermined;

- (void)postNotification:(__kindof KYAUserNotification *)notification;
- (void)clearAllDeliveredNotifications;

@end

API_AVAILABLE(macos(11.0))
@interface KYAUserNotification : NSObject
@property (copy, nonatomic) NSString *identifier;
@property (copy, nonatomic, nullable) NSString *title; // use the localized setter instead
@property (copy, nonatomic, nullable) NSString *subtitle; // use the localized setter instead
@property (copy, nonatomic, nullable) NSString *bodyText;
@property (copy, nonatomic, nullable) NSDictionary *userInfo;

- (void)setLocalizedTitleWithKey:(NSString *)key arguments:(nullable NSArray *)arguments;
- (void)setLocalizedSubtitleWithKey:(NSString *)key arguments:(nullable NSArray *)arguments;
- (void)setLocalizedBodyTextWithKey:(NSString *)key arguments:(nullable NSArray *)arguments;

@end

NS_ASSUME_NONNULL_END
