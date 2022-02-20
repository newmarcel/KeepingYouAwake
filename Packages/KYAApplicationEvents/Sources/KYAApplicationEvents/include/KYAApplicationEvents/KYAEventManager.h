//
//  KYAEventManager.h
//  KYAApplicationEvents
//
//  Created by Marcel Dierkes on 20.02.22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYAEventManager : NSObject

/// Registers the default `KYAEventHandler` with the current application
/// and prepares the app for handling incoming events.
+ (void)configureEventHandler;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
