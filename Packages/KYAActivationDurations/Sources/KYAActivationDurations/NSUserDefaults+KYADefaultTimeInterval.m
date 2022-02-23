//
//  NSUserDefaults+KYADefaultTimeInterval.m
//  KYAActivationDurations
//
//  Created by Marcel Dierkes on 23.02.22.
//

#import <KYAActivationDurations/NSUserDefaults+KYADefaultTimeInterval.h>
#import "KYADefines.h"

NSString * const KYAUserDefaultsKeyDefaultTimeInterval = @"info.marcel-dierkes.KeepingYouAwake.TimeInterval";

@implementation NSUserDefaults (KYADefaultTimeInterval)
@dynamic kya_defaultTimeInterval;

- (NSTimeInterval)kya_defaultTimeInterval
{
    return (NSTimeInterval)[self integerForKey:KYAUserDefaultsKeyDefaultTimeInterval];
}

- (void)setKya_defaultTimeInterval:(NSTimeInterval)defaultTimeInterval
{
    [self setInteger:(NSInteger)defaultTimeInterval
              forKey:KYAUserDefaultsKeyDefaultTimeInterval];  // decimal places will be cut-off
}

@end
