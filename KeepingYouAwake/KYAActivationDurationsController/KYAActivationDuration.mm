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
    self = [super init];
    if(self)
    {
        self.seconds = seconds;
    }
    return self;
}

- (instancetype)initWithDuration:(std::chrono::duration<NSTimeInterval>)duration
{
    return [self initWithSeconds:duration.count()];
}

- (NSString *)localizedTitle
{
    NSTimeInterval interval = self.seconds;
    
    if(interval == 0)
    {
        return KYA_L10N_INDEFINITELY;
    }
    
    auto formatter = [self sharedDateComponentsFormatter];
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

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    NSTimeInterval seconds = [decoder decodeDoubleForKey:kCodingKeySeconds];
    return [self initWithSeconds:seconds];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeDouble:self.seconds forKey:kCodingKeySeconds];
}

#pragma mark - Hashable & Equatable

- (NSUInteger)hash
{
    return (NSUInteger)((uint64_t)self.seconds);
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
    
    return self.seconds == other.seconds;
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
    return [[KYAActivationDuration alloc] initWithDuration:std::chrono::minutes { minutes }];
}

KYAActivationDuration *KYADurationForHours(NSInteger hours)
{
    return [[KYAActivationDuration alloc] initWithDuration:std::chrono::hours { hours }];
}
