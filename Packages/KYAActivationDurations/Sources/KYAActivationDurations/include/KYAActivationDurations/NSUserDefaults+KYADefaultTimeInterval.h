//
//  NSUserDefaults+KYADefaultTimeInterval.h
//  KYAActivationDurations
//
//  Created by Marcel Dierkes on 23.02.22.
//

#import <Foundation/Foundation.h>
#import <KYACommon/KYAExport.h>

NS_ASSUME_NONNULL_BEGIN

KYA_EXPORT NSString * const KYAUserDefaultsKeyDefaultTimeInterval;
KYA_EXPORT NSString * const KYAUserDefaultsKeyDefaultClockTimeSeconds;

/// Marks that no clock time is set as the default activation duration.
KYA_EXPORT NSInteger const KYADefaultClockTimeSecondsNone;

@interface NSUserDefaults (KYADefaultTimeInterval)

/// Returns the default time interval for the sleep wake timer.
/// @warning When setting a value with decimal places, these will
///          be cut off.
@property (nonatomic) NSTimeInterval kya_defaultTimeInterval;

/// Seconds since midnight of a clock time that is the default activation
/// duration, or KYADefaultClockTimeSecondsNone. Takes precedence over
/// kya_defaultTimeInterval when set.
@property (nonatomic) NSInteger kya_defaultClockTimeSeconds;

@end

NS_ASSUME_NONNULL_END
