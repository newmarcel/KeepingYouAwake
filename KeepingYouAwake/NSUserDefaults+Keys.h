//
//  NSUserDefaults+Keys.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 25.10.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSUserDefaults (Keys)

/**
 *  Returns YES if the sleep wake timer should be activated on app launch.
 */
@property (nonatomic, getter = kya_isActivatedOnLaunch) BOOL kya_activateOnLaunch;

/**
 *  Returns YES if user notifications should be displayed.
 */
@property (nonatomic, getter = kya_areNotificationsEnabled) BOOL kya_notificationsEnabled;

/**
 *  Returns the default time interval for the sleep wake timer.
 */
@property (nonatomic) NSTimeInterval kya_defaultTimeInterval;

/**
 *  Returns YES if the app should prevent sleep when connected to AC power with the lid closed.
 */
@property (nonatomic, getter = kya_isPreventingSleepOnACPower) BOOL kya_preventSleepOnACPower;

@end

NS_ASSUME_NONNULL_END
