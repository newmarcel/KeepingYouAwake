//
//  KYASleepWakeTimer.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 07.11.14.
//  Copyright (c) 2014 - 2015 Marcel Dierkes. All rights reserved.
//

#import "KYASleepWakeTimer.h"
#import "NSUserDefaults+Keys.h"

NSTimeInterval const KYASleepWakeTimeIntervalIndefinite = 0;

@interface KYASleepWakeTimer ()
@property (copy, nonatomic, readwrite) NSDate *fireDate;
@property (assign, nonatomic, readwrite) NSTimeInterval scheduledTimeInterval;

@property (strong, nonatomic) NSTask *caffeinateTask;
@end


@implementation KYASleepWakeTimer

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        // Terminate all remaining tasks on app quit
        __weak typeof(self) weakSelf = self;
        [[NSNotificationCenter defaultCenter] addObserverForName:NSApplicationWillTerminateNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
            [weakSelf invalidate];
        }];
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
    NSMutableArray *arguments = [NSMutableArray new];
    
    if([[NSUserDefaults standardUserDefaults] kya_shouldAllowDisplaySleep])
    {
        [arguments addObject:@"-s"];
    }
    else
    {
        [arguments addObject:@"-di"];
    }
    
    if(timeInterval != KYASleepWakeTimeIntervalIndefinite)
    {
        [arguments addObject:[NSString stringWithFormat:@"-t %.f", timeInterval]];
    }
    
    [arguments addObject:[NSString stringWithFormat:@"-w %i", [[NSProcessInfo processInfo] processIdentifier]]];
    
    [self willChangeValueForKey:@"scheduled"];
    self.caffeinateTask = [NSTask launchedTaskWithLaunchPath:@"/usr/bin/caffeinate" arguments:[arguments copy]];
    
    // Termination Handler
    __weak typeof(self) weakSelf = self;
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
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.completionBlock(forcedTermination);
        });
    }
}

@end
