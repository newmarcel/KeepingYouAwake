//
//  KYAActivationDuration.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 19.12.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 An indefinite activation duration (represents a time interval of 0.0).
 */
FOUNDATION_EXPORT NSTimeInterval const KYAActivationDurationIndefinite;

/**
 The object representation of a sleep wake timer activation duration.
 */
@interface KYAActivationDuration : NSObject <NSSecureCoding>

/**
 An activation duration. 0 seconds represent KYAActivationDurationIndefinite.
 */
@property (nonatomic, readonly) NSTimeInterval seconds;

/**
 A localized title text.
 */
@property (nonatomic, readonly) NSString *localizedTitle;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/**
 The designated initializer for the activation duration.

 @param seconds Some seconds.
 @return A new instance.
 */
- (instancetype)initWithSeconds:(NSTimeInterval)seconds NS_DESIGNATED_INITIALIZER;

/**
 Returns YES if other matches the stored seconds and
 displayUnit values of the receiver.

 @param other Another activation duration to compare to
 @return YES if other is equal to the receiver
 */
- (BOOL)isEqualToActivationDuration:(KYAActivationDuration *)other;

@end

#pragma mark - Convenience Helper Functions

/**
 *  Returns a KYAActivationDuration object for the supplied number of seconds.
 *
 *  @param seconds Some seconds.
 *
 *  @return A new KYAActivationDuration instance.
 */
FOUNDATION_EXTERN KYAActivationDuration *KYADurationForSeconds(NSInteger seconds);

/**
 *  Returns a KYAActivationDuration object for the supplied number of minutes formatted as minutes.
 *
 *  @param minutes Some minutes.
 *
 *  @return A new KYAActivationDuration instance.
 */
FOUNDATION_EXTERN KYAActivationDuration *KYADurationForMinutes(NSInteger minutes);

/**
 *  Returns a KYAActivationDuration object for the supplied number of hours formatted as hours.
 *
 *  @param hours Some hours.
 *
 *  @return A new KYAActivationDuration instance.
 */
FOUNDATION_EXTERN KYAActivationDuration *KYADurationForHours(NSInteger hours);

NS_ASSUME_NONNULL_END
