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

#define KYA_USES_SIMPLE_USER_DEFAULTS_VALUES 1

NSNotificationName const KYAActivationDurationsDidChangeNotification = @"KYAActivationDurationsDidChangeNotification";

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
    
    // Reset the default duration if it got removed
    if(![self.storedActivationDurations containsObject:self.defaultActivationDuration])
    {
        [self setDefaultActivationDuration:KYAActivationDuration.indefiniteActivationDuration
                          notifyListensers:NO];
    }
    
    [self didChange];
}

- (void)restoreDefaultDurations
{
    self.storedActivationDurations = [KYAActivationDuration.defaultActivationDurations mutableCopy];
}

- (NSArray<KYAActivationDuration *> *)activationDurations
{
    KYA_AUTO durations = [NSMutableArray arrayWithArray:self.storedActivationDurations];
    [durations insertObject:KYAActivationDuration.indefiniteActivationDuration atIndex:0];
    
    KYA_AUTO sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"seconds" ascending:YES];
    return [durations sortedArrayUsingDescriptors:@[sortDescriptor]];
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
    
    // Reset the default duration if it got removed
    if(![self.storedActivationDurations containsObject:self.defaultActivationDuration])
    {
        [self setDefaultActivationDuration:KYAActivationDuration.indefiniteActivationDuration
                          notifyListensers:NO];
    }
    
    [self didChange];
    
    return YES;
}

- (BOOL)removeActivationDurationAtIndex:(NSUInteger)index
{
    KYA_AUTO durations = self.activationDurations;
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

- (void)setActivationDurationAsDefaultAtIndex:(NSUInteger)index
{
    KYA_AUTO durations = self.activationDurations;
    KYA_AUTO duration = durations[index];
    if(duration == nil)
    {
        return;
    }
    
    [self setDefaultActivationDuration:duration notifyListensers:NO];
    [self didChange];
}

- (void)didChange
{
    [self saveToUserDefaults];
    
    KYA_AUTO notification = KYAActivationDurationsDidChangeNotification;
    [NSNotificationCenter.defaultCenter postNotificationName:notification object:nil];
}

#pragma mark - Default Activation Duration

- (void)setDefaultActivationDuration:(KYAActivationDuration *)duration
{
    [self setDefaultActivationDuration:duration notifyListensers:YES];
}

- (void)setDefaultActivationDuration:(KYAActivationDuration *)duration notifyListensers:(BOOL)notify
{
    NSParameterAssert(duration);
    
    NSAssert([self.activationDurations containsObject:duration], @"The passed duration must be contained in self.activationDurations.");
    
    self.userDefaults.kya_defaultTimeInterval = duration.seconds;
    [self.userDefaults synchronize];
    
    if(notify)
    {
        KYA_AUTO notification = KYAActivationDurationsDidChangeNotification;
        [NSNotificationCenter.defaultCenter postNotificationName:notification object:nil];
    }
}

- (KYAActivationDuration *)defaultActivationDuration
{
    NSTimeInterval seconds = self.userDefaults.kya_defaultTimeInterval;
    if(seconds == KYAActivationDurationIndefinite)
    {
        return KYAActivationDuration.indefiniteActivationDuration;
    }
    
    KYA_AUTO defaultPredicate = [NSPredicate predicateWithFormat:@"seconds == %@",
                                 @(seconds)
                                 ];
    KYA_AUTO results = [self.storedActivationDurations filteredArrayUsingPredicate:defaultPredicate];
    
    return results.firstObject;
}

#pragma mark - User Defaults Handling

- (void)loadFromUserDefaults
{
    // Load without triggering didChange
#if KYA_USES_SIMPLE_USER_DEFAULTS_VALUES
    NSArray<NSNumber *> *seconds = [self.userDefaults objectForKey:KYADefaultsKeyDurations];
    NSMutableArray<KYAActivationDuration *> *loadedDurations = [NSMutableArray new];
    if(seconds != nil && [seconds isKindOfClass:[NSArray class]])
    {
        for(NSNumber *value in seconds)
        {
            NSTimeInterval interval = (NSTimeInterval)value.integerValue;
            KYA_AUTO duration = [[KYAActivationDuration alloc] initWithSeconds:interval];
            [loadedDurations addObject:duration];
        }
    }
#else
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
#endif
    
    if(loadedDurations == nil || loadedDurations.count == 0)
    {
        [self restoreDefaultDurations];
        [self saveToUserDefaults];
    }
    else
    {
#if KYA_USES_SIMPLE_USER_DEFAULTS_VALUES
        self.storedActivationDurations = loadedDurations;
#else
        self.storedActivationDurations = [NSMutableArray arrayWithArray:loadedDurations];
#endif
        KYALog(@"Loaded durations from user defaults: %@", loadedDurations);
    }
}

- (void)saveToUserDefaults
{
    NSAssert(self.storedActivationDurations != nil, @"The stored durations should never be nil.");
    
#if KYA_USES_SIMPLE_USER_DEFAULTS_VALUES
    NSArray<KYAActivationDuration *> *durations = [self.storedActivationDurations copy];
    KYA_AUTO seconds = [NSMutableArray new];
    for(KYAActivationDuration *duration in durations)
    {
        [seconds addObject:@(duration.seconds)];
    }
    [self.userDefaults setObject:seconds forKey:KYADefaultsKeyDurations];
#else
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
#endif
    
    [self.userDefaults synchronize];
    
    KYALog(@"Saved durations to user defaults: %@", self.storedActivationDurations);
}

@end
