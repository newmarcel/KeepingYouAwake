//
//  KYAActivationDurationsController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 28.07.19.
//  Copyright © 2019 Marcel Dierkes. All rights reserved.
//

#import "KYAActivationDurationsController.h"
#import "KYADefines.h"

NSNotificationName const KYAActivationDurationsControllerActivationDurationsDidChangeNotification = @"KYAActivationDurationsControllerActivationDurationsDidChangeNotification";

@interface KYAActivationDurationsController ()
@property (nonatomic, readwrite) NSUserDefaults *userDefaults;
@property (nonatomic, readwrite) NSArray<KYAActivationDuration *> *activationDurations;
@end

@implementation KYAActivationDurationsController

+ (instancetype)sharedController
{
    static dispatch_once_t once;
    static KYAActivationDurationsController *shared;
    dispatch_once(&once, ^{
        KYA_AUTO defaults = NSUserDefaults.standardUserDefaults;
        shared = [[self alloc] initWithUserDefaults:defaults];
    });
    return shared;
}

- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults
{
    NSParameterAssert(userDefaults);
    
    self = [super init];
    if(self)
    {
        self.userDefaults = userDefaults;
    }
    return self;
}

- (void)resetActivationDurations
{
    self.activationDurations = @[
                                 KYADurationForMinutes(5), KYADurationForMinutes(10),
                                 KYADurationForMinutes(15), KYADurationForMinutes(30),
                                 KYADurationForHours(1), KYADurationForHours(2), KYADurationForHours(5)
                                 ];
    KYA_AUTO notificationName = KYAActivationDurationsControllerActivationDurationsDidChangeNotification;
    [NSNotificationCenter.defaultCenter postNotificationName:notificationName object:nil];
}

- (NSArray<KYAActivationDuration *> *)activationDurationsIncludingInfinite
{
    KYA_AUTO durations = [NSMutableArray arrayWithArray:self.activationDurations];
    [durations insertObject:KYADurationForSeconds((NSInteger)KYAActivationDurationIndefinite) atIndex:0];
    return [NSArray arrayWithArray:durations];
}

@end
