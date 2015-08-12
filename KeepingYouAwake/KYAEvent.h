//
//  KYAEvent.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 01.04.15.
//  Copyright (c) 2015 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  This class represents an event from a callback URL.
 */
@interface KYAEvent : NSObject <NSCopying>

/**
 *  The event name.
 */
@property (copy, nonatomic, readonly) NSString *name;

/**
 *  Additional arguments from the callback URL as dictionary.
 */
@property (copy, nonatomic, readonly, nullable) NSDictionary<NSString *, id> *arguments;

/**
 *  The designated initializer for an event.
 *
 *  @param name      An event name.
 *  @param arguments Additional (and optional) event arguments.
 *
 *  @return A new instance.
 */
- (instancetype)initWithName:(NSString *)name arguments:(nullable NSDictionary<NSString *, id> *)arguments;

- (BOOL)isEqualToEvent:(nullable KYAEvent *)event;

@end

NS_ASSUME_NONNULL_END
