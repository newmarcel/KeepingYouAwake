//
//  KYAUserDefaultsSetting.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 18.12.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import "KYAUserDefaultsSetting.h"

@interface KYAUserDefaultsSetting ()
@property (copy, nonatomic, readwrite) NSString *title;
@property (copy, nonatomic, readwrite) NSString *key;
@end

@implementation KYAUserDefaultsSetting

- (instancetype)initWithTitle:(NSString *)title key:(NSString *)key
{
    NSParameterAssert(title);
    NSParameterAssert(key);
    
    self = [super init];
    if(self)
    {
        self.title = title;
        self.key = key;
    }
    return self;
}

#pragma mark - Value

- (BOOL)value
{
    return [NSUserDefaults.standardUserDefaults boolForKey:self.key];
}

- (void)setValue:(BOOL)value
{
    [self willChangeValueForKey:@"value"];
    if(value == YES) {
        [NSUserDefaults.standardUserDefaults setBool:value forKey:self.key];
    }
    else
    {
        [NSUserDefaults.standardUserDefaults removeObjectForKey:self.key];
    }
    [self didChangeValueForKey:@"value"];
    
    [NSUserDefaults.standardUserDefaults synchronize];
}

#pragma mark - Reset

- (void)reset
{
    [NSUserDefaults.standardUserDefaults removeObjectForKey:self.key];
}

@end
