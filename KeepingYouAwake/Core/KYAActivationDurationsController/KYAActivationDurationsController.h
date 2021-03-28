//
//  KYAActivationDurationsController.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 28.07.19.
//  Copyright © 2019 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KYAKit/KYAKit.h>
#import "KYAActivationDuration.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSNotificationName const KYAActivationDurationsDidChangeNotification;

@interface KYAActivationDurationsController : NSObject
@property (class, nonatomic, readonly) KYAActivationDurationsController *sharedController;
@property (nonatomic, readonly) NSUserDefaults *userDefaults;
@property (nonatomic, nullable) KYAActivationDuration *defaultActivationDuration;

/**
 Returns all available and sorted activation durations.
 This also includes the indefinite activation duration.
 */
@property (copy, nonatomic, readonly) NSArray<KYAActivationDuration *> *activationDurations;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults NS_DESIGNATED_INITIALIZER;

#pragma mark - Add & Remove

- (BOOL)addActivationDuration:(KYAActivationDuration *)activationDuration;

- (BOOL)removeActivationDuration:(KYAActivationDuration *)activationDuration
                           error:(NSError *_Nullable *)error;

#pragma mark - Index Access

- (BOOL)removeActivationDurationAtIndex:(NSUInteger)index;

- (void)setActivationDurationAsDefaultAtIndex:(NSUInteger)index;

#pragma mark - Reset

- (void)resetActivationDurations;

@end

NS_ASSUME_NONNULL_END
