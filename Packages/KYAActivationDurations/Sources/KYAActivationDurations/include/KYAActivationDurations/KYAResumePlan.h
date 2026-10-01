//
//  KYAResumePlan.h
//  KYAActivationDurations
//
//  Created by Austin Taylor on 30.09.26.
//  Copyright © 2026 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KYAActivationDurations/KYAActivationDuration.h>
#import <KYACommon/KYAExport.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, KYAResumeAction)
{
    /// Stay deactivated: the end has already passed.
    KYAResumeActionNone,
    /// Activate the same clock time duration again.
    KYAResumeActionActivationDuration,
    /// Activate until the recorded end date.
    KYAResumeActionUntilDate,
    /// Activate for the recorded interval (indefinite or fixed with no end date).
    KYAResumeActionTimeInterval,
};

/// Decides how a timer that was stopped (e.g. on a user switch) resumes,
/// so a clock time or one-off resumes at its original end instead of
/// replaying its full interval.
KYA_EXPORT
@interface KYAResumePlan : NSObject

@property (nonatomic, readonly) KYAResumeAction action;
@property (nonatomic, readonly, nullable) KYAActivationDuration *activationDuration;
@property (nonatomic, readonly, nullable) NSDate *endDate;
@property (nonatomic, readonly) NSTimeInterval timeInterval;

/// @param duration The activation duration the stopped timer was started with, if any
/// @param fireDate The stopped timer's fire date, if any
/// @param timeInterval The stopped timer's scheduled interval (0 is indefinite)
/// @param now The current date
+ (instancetype)planForResumingDuration:(nullable KYAActivationDuration *)duration
                               fireDate:(nullable NSDate *)fireDate
                           timeInterval:(NSTimeInterval)timeInterval
                                    now:(NSDate *)now;

@end

NS_ASSUME_NONNULL_END
