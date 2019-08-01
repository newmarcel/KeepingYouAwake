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
@property (nonatomic) NSMutableArray<KYAActivationDuration *> *storedActivationDurations;
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
    KYA_AUTO defaults = @[
                          KYADurationForMinutes(5), KYADurationForMinutes(10),
                          KYADurationForMinutes(15), KYADurationForMinutes(30),
                          KYADurationForHours(1), KYADurationForHours(2), KYADurationForHours(5)
                          ];
    self.storedActivationDurations = [NSMutableArray arrayWithArray:defaults];
    KYA_AUTO notificationName = KYAActivationDurationsControllerActivationDurationsDidChangeNotification;
    [NSNotificationCenter.defaultCenter postNotificationName:notificationName object:nil];
}

- (NSArray<KYAActivationDuration *> *)activationDurations
{
    return [NSArray arrayWithArray:self.storedActivationDurations];
}

- (NSArray<KYAActivationDuration *> *)activationDurationsIncludingInfinite
{
    KYA_AUTO durations = [NSMutableArray arrayWithArray:self.storedActivationDurations];
    [durations insertObject:KYADurationForSeconds((NSInteger)KYAActivationDurationIndefinite) atIndex:0];
    return [NSArray arrayWithArray:durations];
}

- (BOOL)addActivationDuration:(KYAActivationDuration *)activationDuration
{
    NSParameterAssert(activationDuration);
    
    if([self.storedActivationDurations containsObject:activationDuration])
    {
        return NO;
    }
    [self.storedActivationDurations addObject:activationDuration];
    [self didChange];
    
    return YES;
}

- (BOOL)removeActivationDuration:(KYAActivationDuration *)activationDuration error:(NSError *__autoreleasing  _Nullable *)error
{
    NSParameterAssert(activationDuration);
    
    if(![self.storedActivationDurations containsObject:activationDuration])
    {
        return NO;
    }
    [self.storedActivationDurations removeObject:activationDuration];
    [self didChange];
    
    return YES;
}

- (void)didChange
{
    
}

@end
