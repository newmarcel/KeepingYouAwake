//
//  NSUserDefaults+KYADefaultTimeInterval.m
//  KYAActivationDurations
//
//  Created by Marcel Dierkes on 23.02.22.
//

#import <KYAActivationDurations/NSUserDefaults+KYADefaultTimeInterval.h>
#import <KYACommon/KYACommon.h>

NSString * const KYAUserDefaultsKeyDefaultTimeInterval = @"info.marcel-dierkes.KeepingYouAwake.TimeInterval";
NSString * const KYAUserDefaultsKeyDefaultClockTimeSeconds = @"info.marcel-dierkes.KeepingYouAwake.DefaultClockTimeSeconds";
NSInteger const KYADefaultClockTimeSecondsNone = -1;

@implementation NSUserDefaults (KYADefaultTimeInterval)
@dynamic kya_defaultTimeInterval;
@dynamic kya_defaultClockTimeSeconds;

- (NSTimeInterval)kya_defaultTimeInterval
{
    return (NSTimeInterval)[self integerForKey:KYAUserDefaultsKeyDefaultTimeInterval];
}

- (void)setKya_defaultTimeInterval:(NSTimeInterval)defaultTimeInterval
{
    [self setInteger:(NSInteger)defaultTimeInterval
              forKey:KYAUserDefaultsKeyDefaultTimeInterval];  // decimal places will be cut-off
}

- (NSInteger)kya_defaultClockTimeSeconds
{
    if([self objectForKey:KYAUserDefaultsKeyDefaultClockTimeSeconds] == nil)
    {
        return KYADefaultClockTimeSecondsNone;
    }
    return [self integerForKey:KYAUserDefaultsKeyDefaultClockTimeSeconds];
}

- (void)setKya_defaultClockTimeSeconds:(NSInteger)clockTimeSeconds
{
    if(clockTimeSeconds == KYADefaultClockTimeSecondsNone)
    {
        [self removeObjectForKey:KYAUserDefaultsKeyDefaultClockTimeSeconds];
        return;
    }
    [self setInteger:clockTimeSeconds forKey:KYAUserDefaultsKeyDefaultClockTimeSeconds];
}

@end
