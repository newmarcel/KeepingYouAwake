//
//  KYAActivationDuration.mm
//  KYAActivationDurations
//
//  Created by Marcel Dierkes on 19.12.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import <KYAActivationDurations/KYAActivationDuration.h>
#import <KYACommon/KYACommon.h>
#import "KYAActivationDurationsLog.h"
#include <chrono>

NSTimeInterval const KYAActivationDurationIndefinite = 0.0f;

static NSInteger const KYAClockTimeSecondsNone = -1;
static NSInteger const KYASecondsPerDay = 24 * 60 * 60;

@interface KYAActivationDuration ()
@property (nonatomic, readwrite) NSTimeInterval seconds;
@property (nonatomic, readwrite) NSInteger clockTimeSeconds;
@end

@implementation KYAActivationDuration
@synthesize seconds = _seconds;

+ (NSArray<KYAActivationDuration *> *)defaultActivationDurations
{
    using namespace std::chrono_literals;
    return @[
             [[KYAActivationDuration alloc] initWithDuration:5min],
             [[KYAActivationDuration alloc] initWithDuration:10min],
             [[KYAActivationDuration alloc] initWithDuration:15min],
             [[KYAActivationDuration alloc] initWithDuration:30min],
             [[KYAActivationDuration alloc] initWithDuration:1h],
             [[KYAActivationDuration alloc] initWithDuration:2h],
             [[KYAActivationDuration alloc] initWithDuration:5h]
             ];
}

+ (KYAActivationDuration *)indefiniteActivationDuration
{
    return [[KYAActivationDuration alloc] initWithSeconds:KYAActivationDurationIndefinite];
}

- (instancetype)initWithSeconds:(NSTimeInterval)seconds
{
    self = [super init];
    if(self)
    {
        self.seconds = seconds;
        self.clockTimeSeconds = KYAClockTimeSecondsNone;
    }
    return self;
}

- (instancetype)initWithClockTimeSeconds:(NSInteger)clockTimeSeconds
{
    if(clockTimeSeconds < 0 || clockTimeSeconds >= KYASecondsPerDay)
    {
        os_log_fault(KYAActivationDurationsLog(), "Attempted to add a clock time outside of a day.");
        return nil;
    }

    self = [self initWithSeconds:KYAActivationDurationIndefinite];
    if(self)
    {
        self.clockTimeSeconds = clockTimeSeconds;
    }
    return self;
}

- (instancetype)initWithClockTimeHour:(NSInteger)hour minute:(NSInteger)minute
{
    if(hour < 0 || hour > 23 || minute < 0 || minute > 59)
    {
        os_log_fault(KYAActivationDurationsLog(), "Attempted to add an invalid clock time.");
        return nil;
    }
    return [self initWithClockTimeSeconds:(hour * 60 * 60) + (minute * 60)];
}

#pragma mark - Clock Time

- (BOOL)isClockTime
{
    return self.clockTimeSeconds != KYAClockTimeSecondsNone;
}

- (NSDate *)nextClockTimeDate
{
    if(![self isClockTime]) { return nil; }

    auto calendar = NSCalendar.currentCalendar;
    NSInteger hour = self.clockTimeSeconds / (60 * 60);
    NSInteger minute = (self.clockTimeSeconds / 60) % 60;
    NSInteger second = self.clockTimeSeconds % 60;
    return [calendar nextDateAfterDate:[NSDate date]
                          matchingHour:hour
                                minute:minute
                                second:second
                               options:NSCalendarMatchNextTime];
}

- (NSTimeInterval)seconds
{
    if(![self isClockTime]) { return _seconds; }

    auto fireDate = self.nextClockTimeDate;
    if(fireDate == nil) { return KYAActivationDurationIndefinite; }

    // Never collapse to 0, which would mean "indefinitely"
    return MAX(1.0, ceil(fireDate.timeIntervalSinceNow));
}

- (instancetype)initWithHours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds
{
    using namespace std::chrono_literals;
    
    auto hoursValue = std::chrono::hours { hours };
    
    auto minutesValue = std::chrono::minutes { minutes };
    if(minutesValue > 1h)
    {
        os_log_fault(KYAActivationDurationsLog(), "Attempted to add a duration with a minutes component value greater than an hour.");
        return nil;
    }
    
    auto secondsValue = std::chrono::seconds { seconds };
    if(secondsValue > 1min)
    {
        os_log_fault(KYAActivationDurationsLog(), "Attempted to add a duration with a seconds component value greater than a minute.");
        return nil;
    }
    
    std::chrono::seconds totalValue = hoursValue + minutesValue + secondsValue;
    if(totalValue == 0s)
    {
        os_log_fault(KYAActivationDurationsLog(), "Attempted to add a 0 duration.");
        return nil;
    }
    
    return [self initWithDuration:totalValue];
}

- (instancetype)initWithDuration:(std::chrono::duration<NSTimeInterval>)duration
{
    return [self initWithSeconds:duration.count()];
}

- (NSString *)description
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    NSString *title;
    if([self respondsToSelector:@selector(localizedTitle)])
    {
        title = [self performSelector:@selector(localizedTitle)];
    }
    else
    {
        title = @(self.seconds).stringValue;
    }
    return [NSString stringWithFormat:@"%@ (%@)", super.description, title];
#pragma clang diagnostic pop
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding
{
    return YES;
}

#pragma mark - NSCoding

#define kCodingKeySeconds @"KYASeconds"
#define kCodingKeyClockTimeSeconds @"KYAClockTimeSeconds"

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    if([decoder containsValueForKey:kCodingKeyClockTimeSeconds])
    {
        NSInteger clockTimeSeconds = [decoder decodeIntegerForKey:kCodingKeyClockTimeSeconds];
        if(clockTimeSeconds != KYAClockTimeSecondsNone)
        {
            return [self initWithClockTimeSeconds:clockTimeSeconds];
        }
    }
    NSTimeInterval seconds = [decoder decodeDoubleForKey:kCodingKeySeconds];
    return [self initWithSeconds:seconds];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeDouble:_seconds forKey:kCodingKeySeconds];
    [encoder encodeInteger:self.clockTimeSeconds forKey:kCodingKeyClockTimeSeconds];
}

#pragma mark - Hashable & Equatable

- (NSUInteger)hash
{
    if([self isClockTime])
    {
        return (NSUInteger)(KYASecondsPerDay + self.clockTimeSeconds);
    }
    return (NSUInteger)self.seconds;
}

- (BOOL)isEqual:(id)object
{
    if(object == nil) { return NO; }
    if(object == self) { return YES; }
    if([object isKindOfClass:[self class]])
    {
        return [self isEqualToActivationDuration:(decltype(self))object];
    }
    
    return NO;
}

- (BOOL)isEqualToActivationDuration:(KYAActivationDuration *)other
{
    NSParameterAssert(other);

    if([self isClockTime] || [other isClockTime])
    {
        return self.clockTimeSeconds == other.clockTimeSeconds;
    }
    return self.seconds == other.seconds;
}

@end
