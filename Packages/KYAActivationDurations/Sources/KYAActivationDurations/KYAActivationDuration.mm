//
//  KYAActivationDuration.mm
//  KYAActivationDurations
//
//  Created by Marcel Dierkes on 19.12.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import <KYAActivationDurations/KYAActivationDuration.h>
#import "KYADefines.h"
#include <chrono>

NSTimeInterval const KYAActivationDurationIndefinite = 0.0f;

static KYAActivationDurationLocalizationHandler localizationHandler;

@interface KYAActivationDuration ()
@property (nonatomic, readwrite) NSTimeInterval seconds;
@end

@implementation KYAActivationDuration

+ (void)setLocalizationHandler:(KYAActivationDurationLocalizationHandler)localizationHandler
{
    localizationHandler = [localizationHandler copy];
}

+ (KYAActivationDurationLocalizationHandler)localizationHandler
{
    return localizationHandler;
}

+ (NSArray<KYAActivationDuration *> *)defaultActivationDurations
{
    using namespace std::chrono_literals;
    return @[
             [[KYAActivationDuration alloc]initWithDuration:5min],
             [[KYAActivationDuration alloc]initWithDuration:10min],
             [[KYAActivationDuration alloc]initWithDuration:15min],
             [[KYAActivationDuration alloc]initWithDuration:30min],
             [[KYAActivationDuration alloc]initWithDuration:1h],
             [[KYAActivationDuration alloc]initWithDuration:2h],
             [[KYAActivationDuration alloc]initWithDuration:5h]
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
    }
    return self;
}

- (instancetype)initWithHours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds
{
    using namespace std::chrono_literals;
    
    auto hoursValue = std::chrono::hours { hours };
    
    auto minutesValue = std::chrono::minutes { minutes };
    if(minutesValue > 1h)
    {
        KYALog(@"Attempted to add a duration with a minutes component value greater than an hour.");
        return nil;
    }
    
    auto secondsValue = std::chrono::seconds { seconds };
    if(secondsValue > 1min)
    {
        KYALog(@"Attempted to add a duration with a seconds component value greater than a minute.");
        return nil;
    }
    
    std::chrono::seconds totalValue = hoursValue + minutesValue + secondsValue;
    if(totalValue == 0s)
    {
        KYALog(@"Attempted to add a 0 duration.");
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

@end
