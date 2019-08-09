//
//  KYASleepWakeTimer.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 07.11.14.
//  Copyright (c) 2014 Marcel Dierkes. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSTimeInterval const KYASleepWakeTimeIntervalIndefinite;

typedef void (^KYASleepWakeTimerCompletionBlock)(BOOL cancelled);

@interface KYASleepWakeTimer : NSObject

/**
 Returns the completion date for the currently scheduled timer.
 
 If the timer was scheduled for 0 seconds (Infinity), the fireDate is nil.
 */
@property (copy, nonatomic, readonly, nullable) NSDate *fireDate;

/**
 The initial time interval that was set to schedule the timer.
 */
@property (nonatomic, readonly) NSTimeInterval scheduledTimeInterval;

/**
 Returns YES if a task is scheduled and running.
 */
@property (readonly, nonatomic, getter=isScheduled) BOOL scheduled;

/**
 An optional completion block when the task finishes at the fireDate
 or when invalidate is called manually.
 */
@property (copy, nonatomic, nullable) KYASleepWakeTimerCompletionBlock completionBlock;

/**
 Schedule the Caffeinate Task for a given amount of seconds.
 The optional completion block will be called after the interval.
 
 If you pass 0 seconds, the task will be scheduled without a fireDate.
 
 After invocation, the fireDate property is set.

 @param timeInterval A time interval in seconds.
 @param completion An optional completion block.
 */
- (void)scheduleWithTimeInterval:(NSTimeInterval)timeInterval
                      completion:(nullable KYASleepWakeTimerCompletionBlock)completion;

/**
 Invalidates the timer, cancels the Caffeinate Task and resets
 the fireDate to nil.
 */
- (void)invalidate;

@end

NS_ASSUME_NONNULL_END
