//
//  KYAEvent.m
//  KYAApplicationEvents
//
//  Created by Marcel Dierkes on 01.04.15.
//  Copyright (c) 2015 Marcel Dierkes. All rights reserved.
//

#import <KYAApplicationEvents/KYAEvent.h>

@interface KYAEvent ()
@property (copy, nonatomic, readwrite) NSString *name;
@property (copy, nonatomic, readwrite, nullable) NSDictionary *arguments;
@end

@implementation KYAEvent

#pragma mark - Life Cycle

- (instancetype)initWithName:(NSString *)name arguments:(NSDictionary *)arguments
{
    NSParameterAssert(name);
    
    self = [super init];
    if(self)
    {
        self.name = name;
        self.arguments = arguments;
    }
    return self;
}

#pragma mark - Printable

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@: {\n\tname: %@,\n\targuments: %@\n}",
            [super description],
            self.name,
            self.arguments];
}

#pragma mark - Equatable

- (BOOL)isEqualToEvent:(KYAEvent *)event
{
    NSParameterAssert(event);
    
    return event
        && [self.name isEqualToString:event.name]
        && [self.arguments isEqualToDictionary:event.arguments];
}

- (BOOL)isEqual:(id)object
{
    if(object == nil) { return NO; }
    if(object == self) { return YES; }
    if([object isKindOfClass:[self class]])
    {
        return [self isEqualToEvent:object];
    }
    
    return NO;
}

- (NSUInteger)hash
{
    return self.name.hash ^ self.arguments.hash;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

@end
