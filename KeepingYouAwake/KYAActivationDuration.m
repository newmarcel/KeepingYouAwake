//
//  KYAActivationDuration.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 19.12.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import "KYAActivationDuration.h"

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
        return NSLocalizedString(@"Indefinitely", nil);
    }
    
    NSDateComponentsFormatter *formatter = [self sharedDateComponentsFormatter];
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
