//
//  KYAActivationDuration.h
//  KYAActivationDurations
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

typedef NSString *_Nonnull (^KYAActivationDurationLocalizationHandler)(NSTimeInterval);

/**
 The object representation of a sleep wake timer activation duration.
 */
@interface KYAActivationDuration : NSObject <NSSecureCoding>

/**
 Returns a default set of activation durations.
 */
@property (class, nonatomic, readonly) NSArray<KYAActivationDuration *> *defaultActivationDurations;

/**
 Returns an activation duration for an indefinite amount of time.
 */
@property (class, nonatomic, readonly) KYAActivationDuration *indefiniteActivationDuration;

@property (class, copy, nonatomic, nullable) KYAActivationDurationLocalizationHandler localizationHandler;

/**
 An activation duration. 0 seconds represent KYAActivationDurationIndefinite.
 */
@property (nonatomic, readonly) NSTimeInterval seconds;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/**
 The designated initializer for the activation duration.

 @param seconds Some seconds.
 @return A new instance.
 */
- (instancetype)initWithSeconds:(NSTimeInterval)seconds NS_DESIGNATED_INITIALIZER;

/**
 Convenience initializer to create a new activation
 duration from the provided components.

 @param hours Hours component
 @param minutes Minutes component
 @param seconds Seconds component
 @return A new instance or nil
 */
- (nullable instancetype)initWithHours:(NSInteger)hours
                               minutes:(NSInteger)minutes
                               seconds:(NSInteger)seconds;

/**
 Returns YES if other matches the stored seconds of the receiver.

 @param other Another activation duration to compare to
 @return YES if other is equal to the receiver
 */
- (BOOL)isEqualToActivationDuration:(KYAActivationDuration *)other;

@end

NS_ASSUME_NONNULL_END
