//
//  KYAResumePlan.m
//  KYAActivationDurations
//
//  Created by Austin Taylor on 30.09.26.
//  Copyright © 2026 Marcel Dierkes. All rights reserved.
//

#import <KYAActivationDurations/KYAResumePlan.h>
#import <KYACommon/KYACommon.h>

@interface KYAResumePlan ()
@property (nonatomic, readwrite) KYAResumeAction action;
@property (nonatomic, readwrite, nullable) KYAActivationDuration *activationDuration;
@property (nonatomic, readwrite, nullable) NSDate *endDate;
@property (nonatomic, readwrite) NSTimeInterval timeInterval;
@end

@implementation KYAResumePlan

+ (instancetype)planForResumingDuration:(KYAActivationDuration *)duration
                               fireDate:(NSDate *)fireDate
                           timeInterval:(NSTimeInterval)timeInterval
                                    now:(NSDate *)now
{
    Auto plan = [KYAResumePlan new];
    BOOL endHasPassed = fireDate != nil && [fireDate compare:now] != NSOrderedDescending;
    
    if(duration != nil && [duration isClockTime])
    {
        plan.action = endHasPassed ? KYAResumeActionNone : KYAResumeActionActivationDuration;
        plan.activationDuration = duration;
        return plan;
    }
    
    if(fireDate != nil && timeInterval != KYAActivationDurationIndefinite)
    {
        plan.action = endHasPassed ? KYAResumeActionNone : KYAResumeActionUntilDate;
        plan.endDate = fireDate;
        return plan;
    }
    
    plan.action = KYAResumeActionTimeInterval;
    plan.timeInterval = timeInterval;
    return plan;
}

@end
