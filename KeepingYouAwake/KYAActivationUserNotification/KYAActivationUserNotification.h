//
//  KYAActivationUserNotification.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 27.02.21.
//  Copyright © 2021 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KYAKit/KYAKit.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const KYAActivationUserNotificationIdentifier;

API_AVAILABLE(macos(11.0))
@interface KYAActivationUserNotification : KYAUserNotification
@property (nonatomic, nullable, readonly) NSDate *fireDate;
@property (nonatomic, getter=isActivating, readonly) BOOL activating;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithFireDate:(nullable NSDate *)fireDate
                      activating:(BOOL)activating NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
