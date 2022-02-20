//
//  NSDate+RemainingTime.h
//  KYAUserNotifications
//
//  Created by Marcel Dierkes on 08.08.19.
//  Copyright © 2019 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (RemainingTime)
@property (nonatomic, readonly) NSString *kya_localizedRemainingTime;
@property (nonatomic, readonly) NSString *kya_localizedRemainingTimeWithoutPhrase;
@end

NS_ASSUME_NONNULL_END
