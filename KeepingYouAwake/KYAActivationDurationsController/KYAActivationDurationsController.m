//
//  KYAActivationDurationsController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 28.07.19.
//  Copyright © 2019 Marcel Dierkes. All rights reserved.
//

#import "KYAActivationDurationsController.h"
#import "KYADefines.h"
#include "NSUserDefaults+Keys.h"

NSNotificationName const KYAActivationDurationsControllerActivationDurationsDidChangeNotification = @"KYAActivationDurationsControllerActivationDurationsDidChangeNotification";

static NSString * const KYADefaultsKeyDurations = @"info.marcel-dierkes.KeepingYouAwake.Durations";

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
        
        [self loadFromUserDefaults];
    }
    return self;
}

- (void)resetActivationDurations
{
    [self restoreDefaultDurations];
    [self didChange];
}

- (void)restoreDefaultDurations
{
    KYA_AUTO defaults = @[
                          KYADurationForMinutes(5), KYADurationForMinutes(10),
                          KYADurationForMinutes(15), KYADurationForMinutes(30),
                          KYADurationForHours(1), KYADurationForHours(2), KYADurationForHours(5)
                          ];
    self.storedActivationDurations = [NSMutableArray arrayWithArray:defaults];
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

- (BOOL)removeActivationDurationAtIndex:(NSUInteger)index
{
    KYA_AUTO durations = self.activationDurationsIncludingInfinite;
    KYA_AUTO duration = durations[index];
    if(duration == nil)
    {
        return NO;
    }
    if(duration.seconds == KYAActivationDurationIndefinite)
    {
        return NO;
    }
    return [self removeActivationDuration:duration error:nil];
}

- (void)didChange
{
    [self saveToUserDefaults];
    
    KYA_AUTO notification = KYAActivationDurationsControllerActivationDurationsDidChangeNotification;
    [NSNotificationCenter.defaultCenter postNotificationName:notification object:nil];
}

#pragma mark - Default Activation Duration

- (void)setDefaultActivationDuration:(KYAActivationDuration *)duration
{
    NSParameterAssert(duration);
    
    NSAssert([self.activationDurations containsObject:duration], @"The passed duration must be contained in self.activationDurations.");
    
    self.userDefaults.kya_defaultTimeInterval = duration.seconds;
}

- (KYAActivationDuration *)defaultActivationDuration
{
    NSTimeInterval seconds = self.userDefaults.kya_defaultTimeInterval;
    
    KYA_AUTO defaultPredicate = [NSPredicate predicateWithFormat:@"seconds == %@",
                                 @(seconds)
                                 ];
    KYA_AUTO results = [self.activationDurations filteredArrayUsingPredicate:defaultPredicate];
    
    return results.firstObject;
}

#pragma mark - User Defaults Handling

- (void)loadFromUserDefaults
{
    // Load without triggering didChange
    KYA_AUTO data = [self.userDefaults dataForKey:KYADefaultsKeyDurations];
    NSArray *loadedDurations;
    if(data != nil)
    {
        if(@available(macOS 10.13, *))
        {
            NSError *error;
            KYA_AUTO classes = [NSSet setWithObjects:[NSArray class], [KYAActivationDuration class], nil];
            loadedDurations = [NSKeyedUnarchiver unarchivedObjectOfClasses:classes
                                                                  fromData:data
                                                                     error:&error];
            if(error != nil)
            {
                KYALog(@"Failed to unarchive durations %@", error.userInfo);
            }
        }
        else
        {
            loadedDurations = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
    
    if(loadedDurations == nil || loadedDurations.count == 0)
    {
        [self restoreDefaultDurations];
        [self saveToUserDefaults];
    }
    else
    {
        self.storedActivationDurations = [NSMutableArray arrayWithArray:loadedDurations];
        
        KYALog(@"Loaded durations from user defaults: %@", loadedDurations);
    }
}

- (void)saveToUserDefaults
{
    NSAssert(self.storedActivationDurations != nil, @"The stored durations should never be nil.");
    
    NSData *data;
    if(@available(macOS 10.13, *))
    {
        NSError *error;
        data = [NSKeyedArchiver archivedDataWithRootObject:self.storedActivationDurations
                                     requiringSecureCoding:YES
                                                     error:&error];
        if(error != nil)
        {
            KYALog(@"Failed to archive durations %@", error.userInfo);
            return;
        }
    }
    else
    {
        data = [NSKeyedArchiver archivedDataWithRootObject:self.storedActivationDurations];
    }
    [self.userDefaults setObject:data forKey:KYADefaultsKeyDurations];
    
    KYALog(@"Saved durations to user defaults: %@", self.storedActivationDurations);
}

@end
