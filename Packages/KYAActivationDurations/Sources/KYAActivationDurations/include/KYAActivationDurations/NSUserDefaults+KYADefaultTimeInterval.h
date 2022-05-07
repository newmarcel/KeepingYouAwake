//
//  NSUserDefaults+KYADefaultTimeInterval.h
//  KYAActivationDurations
//
//  Created by Marcel Dierkes on 23.02.22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const KYAUserDefaultsKeyDefaultTimeInterval;

@interface NSUserDefaults (KYADefaultTimeInterval)

/// Returns the default time interval for the sleep wake timer.
/// @warning When setting a value with decimal places, these will
///          be cut off.
@property (nonatomic) NSTimeInterval kya_defaultTimeInterval;

@end

NS_ASSUME_NONNULL_END
