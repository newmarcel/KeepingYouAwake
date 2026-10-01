//
//  KYAActivationDuration+KYALocalizedTitle.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 23.02.22.
//  Copyright © 2022 Marcel Dierkes. All rights reserved.
//

#import "KYAActivationDuration+KYALocalizedTitle.h"
#import <KYACommon/KYACommon.h>
#import "KYALocalizedStrings.h"

@implementation KYAActivationDuration (KYALocalizedTitle)

- (NSString *)localizedTitle
{
    if([self isClockTime])
    {
        Auto fireDate = self.nextClockTimeDate;
        Auto formatter = [self sharedTimeFormatter];
        return KYA_L10N_UNTIL_CLOCK_TIME([formatter stringFromDate:fireDate]);
    }
    
    NSTimeInterval interval = self.seconds;
    
    if(interval == 0)
    {
        return KYA_L10N_INDEFINITELY;
    }
    
    Auto formatter = [self sharedDateComponentsFormatter];
    return [formatter stringFromTimeInterval:interval];
}

#pragma mark - Localized Formatter

- (NSDateFormatter *)sharedTimeFormatter
{
    static dispatch_once_t once;
    static NSDateFormatter *sharedFormatter;
    dispatch_once(&once, ^{
        sharedFormatter = [NSDateFormatter new];
        sharedFormatter.dateStyle = NSDateFormatterNoStyle;
        sharedFormatter.timeStyle = NSDateFormatterShortStyle;
    });
    return sharedFormatter;
}

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
