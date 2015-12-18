//
//  KYAPreference.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 18.12.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYAPreference : NSObject
@property (copy, nonatomic, readonly) NSString *title;
@property (copy, nonatomic, readonly) NSString *defaultsKey;
@property (nonatomic, readwrite) BOOL value;

- (instancetype)initWithTitle:(NSString *)title defaultsKey:(NSString *)defaultsKey;

@end

NS_ASSUME_NONNULL_END
