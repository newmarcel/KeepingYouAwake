//
//  KYASleepWakeTimer.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 07.11.14.
//  Copyright (c) 2014 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KYAApplicationSupport/KYAApplicationSupport.h>
#import <KYACommon/KYAExport.h>

NS_ASSUME_NONNULL_BEGIN

KYA_EXPORT NSTimeInterval const KYASleepWakeTimeIntervalIndefinite;

typedef void (^KYASleepWakeTimerCompletionBlock)(BOOL cancelled);

@protocol KYASleepWakeTimerDelegate;

@interface KYASleepWakeTimer : NSObject

/// An optional delegate.
@property (weak, nonatomic, nullable) id<KYASleepWakeTimerDelegate> delegate;

/// Returns the completion date for the currently scheduled timer.
///
/// If the timer was scheduled for 0 seconds (Infinity), the fireDate is nil.
@property (copy, nonatomic, readonly, nullable) NSDate *fireDate;

/// The initial time interval that was set to schedule the timer.
@property (nonatomic, readonly) NSTimeInterval scheduledTimeInterval;

/// Returns YES if a task is scheduled and running.
@property (readonly, nonatomic, getter=isScheduled) BOOL scheduled;

/// An optional completion block when the task finishes at the fireDate
/// or when invalidate is called manually.
@property (copy, nonatomic, nullable) KYASleepWakeTimerCompletionBlock completionBlock;

/// Schedule the Caffeinate Task for a given amount of seconds.
/// The optional completion block will be called after the interval.
/// If you pass 0 seconds, the task will be scheduled without a fireDate.
/// After invocation, the fireDate property is set.
/// @param timeInterval A time interval in seconds
/// @param completion An optional completion block
- (void)scheduleWithTimeInterval:(NSTimeInterval)timeInterval
                      completion:(nullable KYASleepWakeTimerCompletionBlock)completion;

/// Invalidates the timer, cancels the Caffeinate Task and resets
/// the fireDate to nil.
- (void)invalidate;

@end

@protocol KYASleepWakeTimerDelegate <NSObject>
@optional
/// The sleep wake timer will activate with the provided time interval.
/// @param sleepWakeTimer The delegating sleep wake timer
/// @param timeInterval A time interval
- (void)sleepWakeTimer:(KYASleepWakeTimer *)sleepWakeTimer willActivateWithTimeInterval:(NSTimeInterval)timeInterval;

/// The sleep wake timer did deactivate.
/// @param sleepWakeTimer The delegating sleep wake timer
- (void)sleepWakeTimerDidDeactivate:(KYASleepWakeTimer *)sleepWakeTimer;
@end

NS_ASSUME_NONNULL_END
