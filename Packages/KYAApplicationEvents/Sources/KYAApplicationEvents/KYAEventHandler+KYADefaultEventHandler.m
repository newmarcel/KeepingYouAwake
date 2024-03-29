//
//  KYAEventHandler+KYADefaultEventHandler.m
//  KYAApplicationEvents
//
//  Created by Marcel Dierkes on 09.05.22.
//

#import <KYAApplicationEvents/KYAEventHandler+KYADefaultEventHandler.h>
#import <ApplicationServices/ApplicationServices.h>
#import <KYACommon/KYACommon.h>

@implementation KYAEventHandler (KYADefaultEventHandler)

- (void)registerAsDefaultEventHandler
{
    Auto eventManager = NSAppleEventManager.sharedAppleEventManager;
    [eventManager setEventHandler:self
                      andSelector:@selector(handleGetURLEvent:withReplyEvent:)
                    forEventClass:kInternetEventClass
                       andEventID:kAEGetURL];
}

- (void)handleGetURLEvent:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)reply
{
    Auto parameter = [event paramDescriptorForKeyword:keyDirectObject].stringValue;
    [self handleEventForURL:[NSURL URLWithString:parameter]];
}

@end
