//
//  KYAUserNotificationCenter.m
//  KYAUserNotifications
//
//  Created by Marcel Dierkes on 13.02.21.
//

#import <KYAUserNotifications/KYAUserNotificationCenter.h>
#import <UserNotifications/UserNotifications.h>
#import "KYADefines.h"

@interface KYAUserNotificationCenter ()
@property (nonatomic) UNUserNotificationCenter *center;
@property (nonatomic) os_log_t log;
@end

@interface KYAUserNotification ()
- (UNNotificationContent *)createNotificationContent;
@end

@implementation KYAUserNotificationCenter

+ (instancetype)sharedCenter
{
    static dispatch_once_t once;
    static KYAUserNotificationCenter *sharedCenter;
    dispatch_once(&once, ^{
        sharedCenter = [self new];
    });
    return sharedCenter;
}

- (instancetype)init
{
    return [self initWithUserNotificationCenter:UNUserNotificationCenter.currentNotificationCenter];
}

- (instancetype)initWithUserNotificationCenter:(UNUserNotificationCenter *)center
{
    NSParameterAssert(center);
    self = [super init];
    if(self)
    {
        self.center = center;
        self.log = KYALogCreateWithCategory("UserNotifications");
    }
    return self;
}

#pragma mark - Authorization Status

- (void)getAuthorizationStatusWithCompletion:(void(^)(KYAUserNotificationAuthorizationStatus))completion
{
    NSParameterAssert(completion);
    
    [self.center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *settings) {
        KYAUserNotificationAuthorizationStatus authStatus;
        switch(settings.authorizationStatus)
        {
            case UNAuthorizationStatusNotDetermined:
                authStatus = KYAUserNotificationAuthorizationStatusUndetermined;
                break;
            case UNAuthorizationStatusProvisional:
                // fallthrough
            case KYAUserNotificationAuthorizationStatusGranted:
                authStatus = KYAUserNotificationAuthorizationStatusGranted;
                break;
            default:
                authStatus = KYAUserNotificationAuthorizationStatusDenied;
                break;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(authStatus);
        });
    }];
}

- (void)requestAuthorizationWithCompletion:(KYAUserNotificationsAuthorizationCompletion)completion
{
    UNAuthorizationOptions options = UNAuthorizationOptionAlert | UNAuthorizationOptionProvisional;
    [self.center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError *error) {
        KYAUserNotificationAuthorizationStatus status;
        if(error != nil)
        {
            os_log_error(self.log, "Failed to request notification access: %{public}@", error.userInfo);
            status = KYAUserNotificationAuthorizationStatusDenied;
        }
        else if(granted == YES)
        {
            status = KYAUserNotificationAuthorizationStatusGranted;
        }
        else
        {
            status = KYAUserNotificationAuthorizationStatusUndetermined;
        }
        
        if(completion != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(status, error);
            });
        }
    }];
}

- (void)requestAuthorizationIfUndetermined
{
    [self.center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *settings) {
        if(settings.authorizationStatus == UNAuthorizationStatusNotDetermined)
        {
            [self requestAuthorizationWithCompletion:nil];
        }
    }];
}

#pragma mark - Notification Handling

- (void)clearAllDeliveredNotifications
{
    [self.center removeAllDeliveredNotifications];
}

- (void)postNotification:(__kindof KYAUserNotification *)notification
{
    NSParameterAssert(notification);
    
    Auto content = [notification createNotificationContent];
    Auto identifier = notification.identifier;
    
    Auto request = [UNNotificationRequest requestWithIdentifier:identifier
                                                        content:content
                                                        trigger:nil];
    
    Auto log = self.log;
    [self.center addNotificationRequest:request withCompletionHandler:^(NSError *error) {
        if(error != nil)
        {
            os_log_error(log, "Failed to add notification request. %{public}@", error.userInfo);
        }
    }];
}

@end

@implementation KYAUserNotification

- (void)setLocalizedTitleWithKey:(NSString *)key arguments:(nullable NSArray *)arguments
{
    self.title = [NSString localizedUserNotificationStringForKey:key arguments:arguments];
}

- (void)setLocalizedSubtitleWithKey:(NSString *)key arguments:(nullable NSArray *)arguments
{
    self.subtitle = [NSString localizedUserNotificationStringForKey:key arguments:arguments];
}

- (void)setLocalizedBodyTextWithKey:(NSString *)key arguments:(nullable NSArray *)arguments
{
    self.bodyText = [NSString localizedUserNotificationStringForKey:key arguments:arguments];
}

- (UNNotificationContent *)createNotificationContent
{
    Auto content = [UNMutableNotificationContent new];
    content.title = self.title;
    content.subtitle = self.subtitle;
    content.body = self.bodyText;
    if(self.userInfo != nil)
    {
        content.userInfo = self.userInfo;
    }
    return [content copy];
}

@end
