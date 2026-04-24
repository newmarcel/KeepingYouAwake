//
//  KYAUserActivityPoker.m
//  KeepingYouAwake
//

#import <KYASleepWakeTimer/KYAUserActivityPoker.h>
#import <KYACommon/KYACommon.h>
#import <IOKit/pwr_mgt/IOPMLib.h>

// Managed screensaver policies are typically 300s. 60s gives a 5x safety margin
// while staying cheap.
static NSTimeInterval const KYAUserActivityPokeInterval = 60.0;

@interface KYAUserActivityPoker ()
@property (nonatomic) dispatch_queue_t queue;
@property (nonatomic, nullable) dispatch_source_t timer;
@property (nonatomic) IOPMAssertionID assertionID;
@property (nonatomic, readwrite, getter=isActive) BOOL active;
@property (nonatomic) os_log_t log;
@end

@implementation KYAUserActivityPoker

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _queue = dispatch_queue_create("net.mdierkes.KeepingYouAwake.UserActivityPoker", DISPATCH_QUEUE_SERIAL);
        _assertionID = kIOPMNullAssertionID;
        _log = KYALogCreateWithCategory("UserActivityPoker");
    }
    return self;
}

- (void)dealloc
{
    [self stop];
}

- (void)start
{
    if(self.active) { return; }

    AutoWeak weakSelf = self;
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.queue);
    dispatch_source_set_timer(timer,
                              DISPATCH_TIME_NOW,
                              (uint64_t)(KYAUserActivityPokeInterval * NSEC_PER_SEC),
                              (uint64_t)(5 * NSEC_PER_SEC));
    dispatch_source_set_event_handler(timer, ^{
        [weakSelf poke];
    });
    self.timer = timer;
    self.active = YES;
    dispatch_resume(timer);

    os_log(self.log, "User activity poker started (interval %{public}.0fs).", KYAUserActivityPokeInterval);
}

- (void)stop
{
    if(!self.active) { return; }

    if(self.timer)
    {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }

    if(self.assertionID != kIOPMNullAssertionID)
    {
        IOPMAssertionRelease(self.assertionID);
        self.assertionID = kIOPMNullAssertionID;
    }

    self.active = NO;

    os_log(self.log, "User activity poker stopped.");
}

- (void)poke
{
    IOPMAssertionID assertionID = self.assertionID;
    IOReturn result = IOPMAssertionDeclareUserActivity(
        CFSTR("KeepingYouAwake user activity"),
        kIOPMUserActiveLocal,
        &assertionID);
    if(result == kIOReturnSuccess)
    {
        self.assertionID = assertionID;
    }
    else
    {
        os_log_error(self.log, "IOPMAssertionDeclareUserActivity failed: 0x%08x", result);
    }
}

@end
