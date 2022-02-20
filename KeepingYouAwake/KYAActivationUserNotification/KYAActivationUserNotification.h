//
//  KYAActivationUserNotification.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 27.02.21.
//  Copyright © 2021 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KYAUserNotifications/KYAUserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const KYAActivationUserNotificationIdentifier;

/// A user notification representing activation and deactivation
/// events of a sleep/wake timer.
API_AVAILABLE(macos(11.0))
@interface KYAActivationUserNotification : KYAUserNotification
/// The fire date of the sleep/wake timer.
@property (nonatomic, nullable, readonly) NSDate *fireDate;

/// Returns true if the user notification represents an
/// activation event.
@property (nonatomic, getter=isActivating, readonly) BOOL activating;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/// Creates a user notification for an activiation/deactivation event
/// with an optional fireDate representing the sleep/wake timer end date.
/// @param fireDate The sleep/wake timer's end date
/// @param activating YES if the sleep/wake timer was activated
///                   or NO if deactivated.
- (instancetype)initWithFireDate:(nullable NSDate *)fireDate
                      activating:(BOOL)activating NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
