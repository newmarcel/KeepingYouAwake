//
//  KYAActivationDuration.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 19.12.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 An indefinite activation duration (represents a time interval of 0.0).
 */
extern NSTimeInterval const KYAActivationDurationIndefinite;

/**
 *  The object representation of an sleep wake timer activation duration.
 */
@interface KYAActivationDuration : NSObject

/**
 *  An activation duration. 0 seconds represent KYAActivationDurationIndefinite.
 */
@property (nonatomic, readonly) NSTimeInterval seconds;

/**
 *  The calendar unit that will be used for the formatting in localizedTitle.
 */
@property (nonatomic, readonly) NSCalendarUnit displayUnit;

/**
 *  A localized title text.
 */
@property (nonatomic, readonly) NSString *localizedTitle;

- (instancetype)init NS_UNAVAILABLE;

/**
 *  A convenience initializer for the activation duration.
 *
 *  This initializer uses NSCalendarUnitSecond as displayUnit.
 *
 *  @param seconds Some seconds.
 *
 *  @return A new instance.
 */
- (instancetype)initWithSeconds:(NSTimeInterval)seconds;

/**
 *  The designated initializer for the activation duration.
 *
 *  @param seconds     Some seconds.
 *  @param displayUnit The calendar unit used for formatting localizedTitle.
 *
 *  @return A new instance.
 */
- (instancetype)initWithSeconds:(NSTimeInterval)seconds displayUnit:(NSCalendarUnit)displayUnit NS_DESIGNATED_INITIALIZER;

@end

#pragma mark - Convenience Helper Functions

/**
 *  Returns a KYAActivationDuration object for the supplied number of seconds.
 *
 *  @param seconds Some seconds.
 *
 *  @return A new KYAActivationDuration instance.
 */
KYAActivationDuration * KYADurationForSeconds(NSInteger seconds);

/**
 *  Returns a KYAActivationDuration object for the supplied number of minutes formatted as minutes.
 *
 *  @param minutes Some minutes.
 *
 *  @return A new KYAActivationDuration instance.
 */
KYAActivationDuration * KYADurationForMinutes(NSInteger minutes);

/**
 *  Returns a KYAActivationDuration object for the supplied number of hours formatted as hours.
 *
 *  @param hours Some hours.
 *
 *  @return A new KYAActivationDuration instance.
 */
KYAActivationDuration * KYADurationForHours(NSInteger hours);

NS_ASSUME_NONNULL_END
