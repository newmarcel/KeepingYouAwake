//
//  KYAActivationDuration.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 19.12.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import "KYAActivationDuration.h"
#import "KYADefines.h"
#import "KYALocalizedStrings.h"

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
    
    KYA_AUTO formatter = [self sharedDateComponentsFormatter];
    formatter.allowedUnits = self.displayUnit;
    
    return [formatter stringFromTimeInterval:interval];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ (%@)", super.description, self.localizedTitle];
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

static inline NSTimeInterval KYAMinutesToSeconds(NSInteger minutes)
{
    return (NSTimeInterval)(minutes * 60.0f);
}

static inline NSTimeInterval KYAHoursToSeconds(NSInteger hours)
{
    return (NSTimeInterval)(hours * 3600.0f);
}

KYAActivationDuration *KYADurationForSeconds(NSInteger seconds)
{
    return [[KYAActivationDuration alloc] initWithSeconds:seconds];
}

KYAActivationDuration *KYADurationForMinutes(NSInteger minutes)
{
    return [[KYAActivationDuration alloc] initWithSeconds:KYAMinutesToSeconds(minutes) displayUnit:NSCalendarUnitMinute];
}

KYAActivationDuration *KYADurationForHours(NSInteger hours)
{
    return [[KYAActivationDuration alloc] initWithSeconds:KYAHoursToSeconds(hours) displayUnit:NSCalendarUnitHour];
}
