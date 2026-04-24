//
//  KYAUserActivityPoker.h
//  KeepingYouAwake
//

#import <Foundation/Foundation.h>
#import <KYACommon/KYAExport.h>

NS_ASSUME_NONNULL_BEGIN

/// Periodically declares local user activity to the power management system
/// so that idle-driven screen locks (e.g. an MDM-enforced screensaver with a
/// fixed idleTime) do not fire while the app is active.
///
/// Complementary to the caffeinate task spawned by KYASleepWakeTimer:
/// caffeinate holds IOPM assertions that block display/system idle sleep;
/// the poker resets HIDIdleTime, which is what loginwindow reads.
KYA_EXPORT
@interface KYAUserActivityPoker : NSObject

/// Starts the timer. No-op if already active.
- (void)start;

/// Stops the timer and releases the underlying assertion.
- (void)stop;

/// YES while the timer is running.
@property (nonatomic, readonly, getter=isActive) BOOL active;

@end

NS_ASSUME_NONNULL_END
