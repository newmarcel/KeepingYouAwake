//
//  KYALowPowerModeMonitor.m
//  KYADeviceInfo
//
//  Created by Marcel Dierkes on 20.09.21.
//  Copyright © 2021 Marcel Dierkes. All rights reserved.
//

#import "KYALowPowerModeMonitor+Private.h"
#import "../KYADefines.h"

@implementation KYALowPowerModeMonitor

+ (BOOL)supportsLowPowerMode
{
    if(@available(macOS 12.0, *))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)dealloc
{
    [self unregisterFromLowPowerModeChanges];
}

- (BOOL)supportsLowPowerMode
{
    return [[self class] supportsLowPowerMode];
}

- (BOOL)isLowPowerModeEnabled
{
    if(@available(macOS 12.0, *))
    {
        return [NSProcessInfo.processInfo isLowPowerModeEnabled];
    }
    else
    {
        return NO;
    }
}

#pragma mark - Low Power Mode Changes

- (void)registerForLowPowerModeChanges
{
    if(@available(macOS 12.0, *))
    {
        if([self isRegistered]) return;
        
        Auto center = NSNotificationCenter.defaultCenter;
        [center addObserver:self
                   selector:@selector(handlePowerModeDidChange:)
                       name:NSProcessInfoPowerStateDidChangeNotification
                     object:nil];
        
        self.registered = YES;
    }
}

- (void)unregisterFromLowPowerModeChanges
{
    if(@available(macOS 12.0, *))
    {
        if([self isRegistered] == NO) { return; }
        
        Auto center = NSNotificationCenter.defaultCenter;
        [center removeObserver:self
                          name:NSProcessInfoPowerStateDidChangeNotification
                        object:nil];
        self.registered = NO;
    }
}

- (void)handlePowerModeDidChange:(NSNotification *)notification API_AVAILABLE(macos(12.0))
{
    Auto handler = self.lowPowerModeChangeHandler;
    BOOL powerMode = [NSProcessInfo.processInfo isLowPowerModeEnabled];
    dispatch_async(dispatch_get_main_queue(), ^{
       if(handler != nil)
       {
           handler(powerMode);
       }
    });
}

@end
