//
//  KYAActivationDuration.h
//  KYAActivationDurations
//
//  Created by Marcel Dierkes on 19.12.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KYACommon/KYAExport.h>

NS_ASSUME_NONNULL_BEGIN

/// An indefinite activation duration (represents a time interval of 0.0).
KYA_EXPORT NSTimeInterval const KYAActivationDurationIndefinite;

/// The object representation of a sleep wake timer activation duration.
@interface KYAActivationDuration : NSObject <NSSecureCoding>

/// Returns a default set of activation durations.
@property (class, nonatomic, readonly) NSArray<KYAActivationDuration *> *defaultActivationDurations;

/// Returns an activation duration for an indefinite amount of time.
@property (class, nonatomic, readonly) KYAActivationDuration *indefiniteActivationDuration;

/// An activation duration. 0 seconds represent KYAActivationDurationIndefinite.
/// For a clock time duration this is the time remaining until the next
/// occurrence of that clock time and changes every time it is read.
@property (nonatomic, readonly) NSTimeInterval seconds;

/// Seconds since midnight of the local clock time this duration ends at,
/// or -1 for a fixed-length duration.
@property (nonatomic, readonly) NSInteger clockTimeSeconds;

/// YES if this duration ends at a clock time instead of after a fixed length.
@property (nonatomic, readonly, getter=isClockTime) BOOL clockTime;

- (instancetype)init NS_UNAVAILABLE;

/// The designated initializer for the activation duration.
/// @param seconds Some seconds.
- (instancetype)initWithSeconds:(NSTimeInterval)seconds NS_DESIGNATED_INITIALIZER;

/// Creates a duration that ends at the next occurrence of a local clock time.
/// @param clockTimeSeconds Seconds since midnight, 0 to 86399
- (nullable instancetype)initWithClockTimeSeconds:(NSInteger)clockTimeSeconds;

/// Creates a duration that ends at the next occurrence of a local clock time.
/// @param hour Hour component, 0 to 23
/// @param minute Minute component, 0 to 59
- (nullable instancetype)initWithClockTimeHour:(NSInteger)hour minute:(NSInteger)minute;

/// The next date at which a clock time duration ends, nil for fixed-length durations.
@property (nonatomic, readonly, nullable) NSDate *nextClockTimeDate;

/// Convenience initializer to create a new activation duration
/// from the provided components.
/// @param hours Hours component
/// @param minutes Minutes component
/// @param seconds Seconds component
- (nullable instancetype)initWithHours:(NSInteger)hours
                               minutes:(NSInteger)minutes
                               seconds:(NSInteger)seconds;

/// Returns YES if other matches the stored seconds of the receiver.
/// @param other Another activation duration to compare to
/// @returns YES if other is equal to the receiver
- (BOOL)isEqualToActivationDuration:(KYAActivationDuration *)other;

@end

NS_ASSUME_NONNULL_END
