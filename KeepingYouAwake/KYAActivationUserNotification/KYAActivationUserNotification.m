//
//  KYAActivationUserNotification.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 27.02.21.
//  Copyright © 2021 Marcel Dierkes. All rights reserved.
//

#import "KYAActivationUserNotification.h"
#import <KYACommon/KYACommon.h>
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
                Auto time = fireDate.kya_localizedRemainingTimeWithoutPhrase;
                Auto text = KYA_L10N_PREVENTING_SLEEP_FOR_TIME_TITLE(time);
                [self setLocalizedTitleWithKey:text arguments:nil];
                [self setLocalizedBodyTextWithKey:KYA_L10N_PREVENTING_SLEEP_FOR_TIME_BODY_TEXT
                                        arguments:nil];
            }
            else
            {
                [self setLocalizedTitleWithKey:KYA_L10N_PREVENTING_SLEEP_INDEFINITELY_TITLE
                                     arguments:nil];
                [self setLocalizedBodyTextWithKey:KYA_L10N_PREVENTING_SLEEP_INDEFINITELY_BODY_TEXT
                                        arguments:nil];
            }
        }
        else
        {
            [self setLocalizedTitleWithKey:KYA_L10N_ALLOWING_SLEEP_TITLE arguments:nil];
            [self setLocalizedBodyTextWithKey:KYA_L10N_ALLOWING_SLEEP_BODY_TEXT arguments:nil];
        }
    }
    return self;
}

@end
