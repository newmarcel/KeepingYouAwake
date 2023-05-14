//
//  KYASleepWakeTimer.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 07.11.14.
//  Copyright (c) 2014 Marcel Dierkes. All rights reserved.
//

#import <KYASleepWakeTimer/KYASleepWakeTimer.h>
#import "KYADefines.h"

NSTimeInterval const KYASleepWakeTimeIntervalIndefinite = 0;

@interface KYASleepWakeTimer ()
@property (copy, nonatomic, readwrite) NSDate *fireDate;
@property (nonatomic, readwrite) NSTimeInterval scheduledTimeInterval;
@property (nonatomic) NSTask *caffeinateTask;
@property (nonatomic) os_log_t log;
@end

@implementation KYASleepWakeTimer

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        // Terminate all remaining tasks on app quit
        AutoWeak weakSelf = self;
        Auto center = NSNotificationCenter.defaultCenter;
        [center addObserverForName:NSApplicationWillTerminateNotification
                            object:nil
                             queue:nil
                        usingBlock:^(NSNotification *note) {
            [weakSelf invalidate];
        }];
        
        self.log = KYALogCreateWithCategory("SleepWakeTimer");
    }
    return self;
}

- (void)dealloc
{
    [self invalidate];
}

#pragma mark - Scheduling

- (void)scheduleWithTimeInterval:(NSTimeInterval)timeInterval completion:(KYASleepWakeTimerCompletionBlock)completion
{
    os_log(self.log, "%{public}@ will activate with time interval %{public}@.", self, @(timeInterval));
    
    Auto delegate = self.delegate;
    if([self.delegate respondsToSelector:@selector(sleepWakeTimer:willActivateWithTimeInterval:)])
    {
        [delegate sleepWakeTimer:self willActivateWithTimeInterval:timeInterval];
    }
    
    if(completion)
    {
        self.completionBlock = completion;
    }

    // Set the fireDate
    self.scheduledTimeInterval = timeInterval;
    if(timeInterval != KYASleepWakeTimeIntervalIndefinite)
    {
        self.fireDate = [NSDate dateWithTimeIntervalSinceNow:timeInterval];
    }

    // Spawn caffeinate
    [self spawnCaffeinateTaskForTimeInterval:timeInterval];
}

- (void)invalidate
{
    self.fireDate = nil;
    self.scheduledTimeInterval = KYASleepWakeTimeIntervalIndefinite;
    [self terminateCaffeinateTask];
}

- (BOOL)isScheduled
{
    if(self.caffeinateTask && [self.caffeinateTask isRunning])
    {
        return YES;
    }

    return NO;
}

#pragma mark - Caffeinate Task Handling

- (void)spawnCaffeinateTaskForTimeInterval:(NSTimeInterval)timeInterval
{
    Auto defaults = NSUserDefaults.standardUserDefaults;
    Auto arguments = [NSMutableArray<NSString *> new];
    if([defaults kya_shouldAllowDisplaySleep])
    {
        [arguments addObject:@"-i"];
    }
    else
    {
        [arguments addObject:@"-di"];
    }

    if(timeInterval != KYASleepWakeTimeIntervalIndefinite)
    {
        [arguments addObject:[NSString stringWithFormat:@"-t %.f", timeInterval]];
    }

    [arguments addObject:[NSString stringWithFormat:@"-w %i",
                          NSProcessInfo.processInfo.processIdentifier]];

    [self willChangeValueForKey:@"scheduled"];
    self.caffeinateTask = [NSTask launchedTaskWithLaunchPath:@"/usr/bin/caffeinate"
                                                   arguments:[arguments copy]];

    // Termination Handler
    AutoWeak weakSelf = self;
    self.caffeinateTask.terminationHandler = ^(NSTask *task) {
        [weakSelf terminateWithForce:NO];
    };
    [self didChangeValueForKey:@"scheduled"];
}

- (void)terminateCaffeinateTask
{
    self.caffeinateTask.terminationHandler = nil;
    [self.caffeinateTask terminate];

    [self terminateWithForce:YES];
}

- (void)terminateWithForce:(BOOL)forcedTermination
{
    [self willChangeValueForKey:@"scheduled"];
    self.caffeinateTask = nil;
    self.scheduledTimeInterval = KYASleepWakeTimeIntervalIndefinite;
    self.fireDate = nil;
    [self didChangeValueForKey:@"scheduled"];

    if(self.completionBlock)
    {
        AutoWeak weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.completionBlock(forcedTermination);
        });
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        Auto delegate = self.delegate;
        if([delegate respondsToSelector:@selector(sleepWakeTimerDidDeactivate:)])
        {
            [delegate sleepWakeTimerDidDeactivate:self];
        }
    });
    
    os_log(self.log, "%{public}@ did deactivate.", self);
}

@end
