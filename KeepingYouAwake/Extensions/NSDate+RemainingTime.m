//
//  NSDate+RemainingTime.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 08.08.19.
//  Copyright © 2019 Marcel Dierkes. All rights reserved.
//

#import "NSDate+RemainingTime.h"
#import "KYADefines.h"

@implementation NSDate (RemainingTime)

- (NSDateComponentsFormatter *)dateComponentsFormatter
{
    static NSDateComponentsFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDateComponentsFormatter new];
        dateFormatter.allowedUnits = NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour;
        dateFormatter.unitsStyle = NSDateComponentsFormatterUnitsStyleShort;
        dateFormatter.includesTimeRemainingPhrase = YES;
    });
    
    return dateFormatter;
}

- (NSString *)kya_localizedRemainingTime
{
    return [[self dateComponentsFormatter] stringFromDate:[NSDate date] toDate:self];
}

- (NSString *)kya_localizedRemainingTimeWithoutPhrase
{
    KYA_AUTO formatter = [self dateComponentsFormatter];
    formatter.includesTimeRemainingPhrase = NO;
    KYA_AUTO remainingTimeString = [formatter stringFromDate:[NSDate date] toDate:self];
    formatter.includesTimeRemainingPhrase = YES;
    
    return remainingTimeString;
}

@end
