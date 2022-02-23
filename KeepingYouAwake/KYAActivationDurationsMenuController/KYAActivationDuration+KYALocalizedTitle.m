//
//  KYAActivationDuration+KYALocalizedTitle.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 23.02.22.
//  Copyright © 2022 Marcel Dierkes. All rights reserved.
//

#import "KYAActivationDuration+KYALocalizedTitle.h"
#import "KYADefines.h"
#import "KYALocalizedStrings.h"

@implementation KYAActivationDuration (KYALocalizedTitle)

- (NSString *)localizedTitle
{
    NSTimeInterval interval = self.seconds;
    
    if(interval == 0)
    {
        return KYA_L10N_INDEFINITELY;
    }
    
    Auto formatter = [self sharedDateComponentsFormatter];
    return [formatter stringFromTimeInterval:interval];
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
