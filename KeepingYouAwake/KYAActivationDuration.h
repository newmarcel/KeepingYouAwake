//
//  KYAActivationDuration.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 19.12.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYAActivationDuration : NSObject
@property (nonatomic, readonly) NSTimeInterval seconds;  // 0 seconds means "indefinitely" and displayUnit is ignored
@property (nonatomic, readonly) NSCalendarUnit displayUnit;

@property (nonatomic, readonly) NSString *localizedTitle;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithSeconds:(NSTimeInterval)seconds;
- (instancetype)initWithSeconds:(NSTimeInterval)seconds displayUnit:(NSCalendarUnit)displayUnit NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
