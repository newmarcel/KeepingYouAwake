//
//  KYAUserDefaultsSetting.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 18.12.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYAUserDefaultsSetting : NSObject
@property (copy, nonatomic, readonly) NSString *title;
@property (copy, nonatomic, readonly) NSString *key;
@property (nonatomic, readwrite) BOOL value;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithTitle:(NSString *)title key:(NSString *)defaultsKey;

/// Reset the setting to its default value.
- (void)reset;

@end

NS_ASSUME_NONNULL_END
