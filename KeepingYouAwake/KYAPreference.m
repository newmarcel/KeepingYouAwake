//
//  KYAPreference.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 18.12.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import "KYAPreference.h"

@interface KYAPreference ()
@property (copy, nonatomic, readwrite) NSString *title;
@property (copy, nonatomic, readwrite) NSString *defaultsKey;
@end

@implementation KYAPreference

- (instancetype)initWithTitle:(NSString *)title defaultsKey:(NSString *)defaultsKey
{
    self = [super init];
    if(self)
    {
        self.title = title;
        self.defaultsKey = defaultsKey;
    }
    return self;
}

#pragma mark - Value

- (BOOL)value
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:self.defaultsKey];
}

- (void)setValue:(BOOL)value
{
    [self willChangeValueForKey:@"value"];
    if(value == YES) {
        [[NSUserDefaults standardUserDefaults] setBool:value forKey:self.defaultsKey];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.defaultsKey];
    }
    [self didChangeValueForKey:@"value"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
