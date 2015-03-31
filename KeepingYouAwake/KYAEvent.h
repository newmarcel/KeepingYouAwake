//
//  KYAEvent.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 01.04.15.
//  Copyright (c) 2015 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYAEvent : NSObject <NSCopying>
@property (copy, nonatomic, readonly) NSString *name;
@property (copy, nonatomic, readonly, nullable) NSDictionary *arguments; // [NSString: NSObject]

- (nonnull instancetype)initWithName:(nonnull NSString *)name arguments:(nullable NSDictionary *)arguments;
- (BOOL)isEqualToEvent:(nullable KYAEvent *)event;

@end

NS_ASSUME_NONNULL_END