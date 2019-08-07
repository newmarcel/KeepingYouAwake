//
//  KYAActivationDuration.mm
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 19.12.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import "KYAActivationDuration.h"
#import "KYADefines.h"
#import "KYALocalizedStrings.h"
#include <chrono>

NSTimeInterval const KYAActivationDurationIndefinite = 0.0f;

@interface KYAActivationDuration ()
@property (nonatomic, readwrite) NSTimeInterval seconds;
@property (nonatomic, readwrite) NSCalendarUnit displayUnit;
@end

@implementation KYAActivationDuration

- (instancetype)initWithSeconds:(NSTimeInterval)seconds
{
    return [self initWithSeconds:seconds displayUnit:NSCalendarUnitSecond];
}

- (instancetype)initWithDuration:(std::chrono::duration<NSTimeInterval>)duration displayUnit:(NSCalendarUnit)displayUnit
{
    return [self initWithSeconds:duration.count() displayUnit:displayUnit];
}

- (instancetype)initWithSeconds:(NSTimeInterval)seconds displayUnit:(NSCalendarUnit)displayUnit
{
    self = [super init];
    if(self)
    {
        self.seconds = seconds;
        self.displayUnit = displayUnit;
    }
    return self;
}

- (NSString *)localizedTitle
{
    NSTimeInterval interval = self.seconds;
    
    if(interval == 0)
    {
        return KYA_L10N_INDEFINITELY;
    }
    
    auto formatter = [self sharedDateComponentsFormatter];
    formatter.allowedUnits = self.displayUnit;
    
    return [formatter stringFromTimeInterval:interval];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ (%@)", super.description, self.localizedTitle];
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding
{
    return YES;
}

#pragma mark - NSCoding

#define kCodingKeySeconds @"KYASeconds"
#define kCodingKeyUnit @"KYAUnit"

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    NSTimeInterval seconds = [decoder decodeDoubleForKey:kCodingKeySeconds];
    NSCalendarUnit unit = (NSCalendarUnit)[decoder decodeIntegerForKey:kCodingKeyUnit];
    
    return [self initWithSeconds:seconds displayUnit:unit];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeDouble:self.seconds forKey:kCodingKeySeconds];
    [encoder encodeInteger:(NSInteger)self.displayUnit forKey:kCodingKeyUnit];
}

#pragma mark - Hashable & Equatable

- (NSUInteger)hash
{
    return (NSUInteger)((uint64_t)self.seconds ^ (uint64_t)self.displayUnit);
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
    
    return self.seconds == other.seconds
        && self.displayUnit == other.displayUnit;
}

#pragma mark - Localized Formatter

- (NSDateComponentsFormatter *)sharedDateComponentsFormatter
{
    static dispatch_once_t once;
    static NSDateComponentsFormatter *sharedFormatter;
    dispatch_once(&once, ^{
        sharedFormatter = [NSDateComponentsFormatter new];
        sharedFormatter.unitsStyle = NSDateComponentsFormatterUnitsStyleFull;
    });
    return sharedFormatter;
}

@end

#pragma mark - Convenience Helper Functions

KYAActivationDuration *KYADurationForSeconds(NSInteger seconds)
{
    return [[KYAActivationDuration alloc] initWithSeconds:seconds];
}

KYAActivationDuration *KYADurationForMinutes(NSInteger minutes)
{
    return [[KYAActivationDuration alloc] initWithDuration:std::chrono::minutes { minutes }
                                               displayUnit:NSCalendarUnitMinute];
}

KYAActivationDuration *KYADurationForHours(NSInteger hours)
{
    return [[KYAActivationDuration alloc] initWithDuration:std::chrono::hours { hours }
                                               displayUnit:NSCalendarUnitHour];
}
