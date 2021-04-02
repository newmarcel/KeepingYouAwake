//
//  KYAActivationUserNotification.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 27.02.21.
//  Copyright © 2021 Marcel Dierkes. All rights reserved.
//

#import "KYAActivationUserNotification.h"
#import "KYADefines.h"
#import "KYALocalizedStrings.h"

NSString * const KYAActivationUserNotificationIdentifier = @"KYAActivationIdentifier";

@interface KYAActivationUserNotification ()
@property (nonatomic, nullable, readwrite) NSDate *fireDate;
@property (nonatomic, getter=isActivating, readwrite) BOOL activating;
@end

@implementation KYAActivationUserNotification

- (instancetype)initWithFireDate:(NSDate *)fireDate activating:(BOOL)activating
{
    self = [super init];
    if(self)
    {
        self.identifier = KYAActivationUserNotificationIdentifier;
        
        self.fireDate = fireDate;
        self.activating = activating;
        
        if(activating == YES)
        {
            if(fireDate != nil)
            {
                Auto remainingTimeString = fireDate.kya_localizedRemainingTimeWithoutPhrase;
                Auto text = KYA_L10N_PREVENTING_SLEEP_FOR_REMAINING_TIME(remainingTimeString);
                [self setLocalizedTitleWithKey:text arguments:nil];
            }
            else
            {
                Auto text = KYA_L10N_PREVENTING_YOUR_MAC_FROM_GOING_TO_SLEEP;
                [self setLocalizedTitleWithKey:text arguments:nil];
            }
        }
        else
        {
            Auto text = KYA_L10N_ALLOWING_YOUR_MAC_TO_GO_TO_SLEEP;
            [self setLocalizedTitleWithKey:text arguments:nil];
        }
    }
    return self;
}

@end
