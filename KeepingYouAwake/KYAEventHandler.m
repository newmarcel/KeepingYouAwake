//
//  KYAEventHandler.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 31.03.15.
//  Copyright (c) 2015 Marcel Dierkes. All rights reserved.
//

#import "KYAEventHandler.h"
#import "KYAEvent.h"

@interface KYAEventHandler ()
@property (strong, nonatomic) dispatch_queue_t eventQueue;
@property (strong, nonatomic) NSMapTable *eventTable;
@end


@implementation KYAEventHandler

#pragma mark - Singleton

+ (instancetype)mainHandler
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
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
    if(!URL)
    {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.eventQueue, ^{
        KYAEvent *event = [weakSelf eventForURL:URL];
        
        KYAEventHandlerActionBlock actionBlock = [self.eventTable objectForKey:event.name];
        if(actionBlock)
        {
#if DEBUG
            NSLog(@"Handling event:\n%@\nfor URL: %@", event, URL);
#endif
            actionBlock(event);
        }
    });
}

- (nullable KYAEvent *)eventForURL:(nonnull NSURL *)URL
{
    NSURLComponents *URLComponents = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:YES];

    NSString *path = URL.lastPathComponent;
    
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    for(NSURLQueryItem *queryItem in URLComponents.queryItems) {
        arguments[queryItem.name] = queryItem.value;
    }
    
    return [[KYAEvent alloc] initWithName:path arguments:arguments];
}

#pragma mark - URL Components

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
