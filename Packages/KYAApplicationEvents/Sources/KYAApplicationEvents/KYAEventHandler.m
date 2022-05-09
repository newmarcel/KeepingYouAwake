//
//  KYAEventHandler.m
//  KYAApplicationEvents
//
//  Created by Marcel Dierkes on 31.03.15.
//  Copyright (c) 2015 Marcel Dierkes. All rights reserved.
//

#import <KYAApplicationEvents/KYAEventHandler.h>
#import "KYADefines.h"

@interface KYAEventHandler ()
@property (nonatomic) dispatch_queue_t eventQueue;
@property (nonatomic) NSMapTable *eventTable;
@end

@implementation KYAEventHandler

#pragma mark - Singleton

+ (instancetype)defaultHandler
{
    static dispatch_once_t once;
    static KYAEventHandler *handler;
    dispatch_once(&once, ^{
        handler = [self new];
    });
    return handler;
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.eventQueue = dispatch_queue_create("info.marcel-dierkes.KeepingYouAwake.EventQueue", DISPATCH_QUEUE_SERIAL);
        self.eventTable = [NSMapTable strongToStrongObjectsMapTable];
    }
    return self;
}

- (void)dealloc
{
    self.eventQueue = nil;
    self.eventTable = nil;
}


#pragma mark - Event Handling

- (void)handleEventForURL:(NSURL *)URL
{
    if(URL == nil) { return; }
    
    AutoWeak weakSelf = self;
    dispatch_async(self.eventQueue, ^{
        Auto event = [weakSelf eventForURL:URL];
        
        KYAEventHandlerActionBlock actionBlock = [self.eventTable objectForKey:event.name];
        if(actionBlock)
        {
            KYALog(@"Handling event:\n%@\nfor URL: %@", event, URL);
            // Perform the action block on main queue, but in sync with the event queue
            dispatch_sync(dispatch_get_main_queue(), ^{
                actionBlock(event);
            });
        }
    });
}

- (nullable KYAEvent *)eventForURL:(nonnull NSURL *)URL
{
    Auto URLComponents = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:YES];
    Auto path = URL.lastPathComponent;
    
    // Destructure NSURLQueryItems into basic dictionary values
    Auto arguments = [NSMutableDictionary dictionary];
    for(NSURLQueryItem *queryItem in URLComponents.queryItems)
    {
        AutoVar value = queryItem.value;
        if(!value)
        {
            // fall back to an empty string if the value is nil
            value = @"";
        }
        arguments[queryItem.name] = value;
    }
    
    return [[KYAEvent alloc] initWithName:path arguments:arguments];
}

#pragma mark - Event Registration

- (void)registerActionNamed:(NSString *)actionName block:(KYAEventHandlerActionBlock)block
{
    [self.eventTable setObject:block forKey:actionName];
}

- (void)removeActionNamed:(NSString *)actionName
{
    [self.eventTable removeObjectForKey:actionName];
}

@end
