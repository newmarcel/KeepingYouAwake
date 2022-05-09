//
//  KYAEventHandler+KYADefaultEventHandler.h
//  KYAApplicationEvents
//
//  Created by Marcel Dierkes on 09.05.22.
//

#import <Foundation/Foundation.h>
#import <KYAApplicationEvents/KYAEventHandler.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYAEventHandler (KYADefaultEventHandler)

/// Configures the event handler to be the default for the current
/// applicatiom and prepares itself for handling incoming events.
- (void)registerAsDefaultEventHandler;

@end

NS_ASSUME_NONNULL_END
