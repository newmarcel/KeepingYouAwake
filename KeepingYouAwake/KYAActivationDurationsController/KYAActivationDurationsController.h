//
//  KYAActivationDurationsController.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 28.07.19.
//  Copyright © 2019 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KYAActivationDuration.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSNotificationName const KYAActivationDurationsControllerActivationDurationsDidChangeNotification;

@interface KYAActivationDurationsController : NSObject
@property (class, nonatomic, readonly) KYAActivationDurationsController *sharedController;
@property (nonatomic, readonly) NSUserDefaults *userDefaults;
@property (nonatomic, nullable) KYAActivationDuration *defaultActivationDuration;

@property (copy, nonatomic, readonly) NSArray<KYAActivationDuration *> *activationDurationsIncludingInfinite;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults NS_DESIGNATED_INITIALIZER;

//- (BOOL)setActivationDurations:(NSArray<KYAActivationDuration *> *)activationDurations
//                         error:(NSError *_Nullable *)error;

- (BOOL)addActivationDuration:(KYAActivationDuration *)activationDuration;

- (BOOL)removeActivationDuration:(KYAActivationDuration *)activationDuration
                           error:(NSError *_Nullable *)error;

- (BOOL)removeActivationDurationAtIndex:(NSUInteger)index;

- (void)setActivationDurationAsDefaultAtIndex:(NSUInteger)index;

- (void)resetActivationDurations;

@end

NS_ASSUME_NONNULL_END
