//
//  KYABatteryMonitor.m
//  KYADeviceInfo
//
//  Created by Marcel Dierkes on 21.12.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import "KYABatteryMonitor+Private.h"
#import "../KYADefines.h"
#import <IOKit/ps/IOPowerSources.h>

const CGFloat KYABatteryCapacityUnavailable = -1.0;

static void KYABatteryMonitorChangeHandler(void *context);

@implementation KYABatteryMonitor

- (void)dealloc
{
    [self unregisterFromCapacityChanges];
}

- (BOOL)hasBattery
{
    Auto powerSourceInfos = [self powerSourceInfos];
    if(powerSourceInfos == nil)
    {
        return NO;
    }
    
    Auto key = [NSString stringWithUTF8String:kIOPSTypeKey];
    Auto internalBatteryTypeKey = [NSString stringWithUTF8String:kIOPSInternalBatteryType];
    NSString *batteryType = powerSourceInfos[key];
    return [batteryType isEqualToString:internalBatteryTypeKey];
}

- (CGFloat)currentCapacity
{
    Auto powerSourceInfos = [self powerSourceInfos];
    if(powerSourceInfos == nil)
    {
        return KYABatteryCapacityUnavailable;
    }
    
    Auto key = [NSString stringWithUTF8String:kIOPSCurrentCapacityKey];
    NSNumber *capacity = powerSourceInfos[key];
    if(capacity == nil)
    {
        return KYABatteryCapacityUnavailable;
    }
    
    return capacity.floatValue;
}

- (KYADeviceBatteryState)state
{
    Auto powerSourceInfos = [self powerSourceInfos];
    if(powerSourceInfos == nil)
    {
        return KYADeviceBatteryStateUnknown;
    }
    
    Auto key = [NSString stringWithUTF8String:kIOPSPowerSourceStateKey];
    NSString *powerSourceState = powerSourceInfos[key];
    if([powerSourceState isEqualToString:[NSString stringWithUTF8String:kIOPSBatteryPowerValue]])
    {
        return KYADeviceBatteryStateUnplugged;
    }
    else if([powerSourceState isEqualToString:[NSString stringWithUTF8String:kIOPSACPowerValue]])
    {
        Auto key = [NSString stringWithUTF8String:kIOPSIsChargingKey];
        Auto charging = (NSNumber *)powerSourceInfos[key];
        if([charging isEqualToNumber:@YES])
        {
            return KYADeviceBatteryStateCharging;
        }
        else
        {
            Auto key = [NSString stringWithUTF8String:kIOPSIsChargedKey];
            Auto charged = (NSNumber *)powerSourceInfos[key];
            if([charged isEqualToNumber:@YES])
            {
                return KYADeviceBatteryStateFull;
            }
        }
    }
    
    return KYADeviceBatteryStateUnknown;
}

- (nullable NSDictionary *)powerSourceInfos
{
    Auto blob = IOPSCopyPowerSourcesInfo();
    Auto sourcesList = IOPSCopyPowerSourcesList(blob);
    CFRelease(blob);
    
    if(CFArrayGetCount(sourcesList) == 0) {
        CFRelease(sourcesList);
        return nil;
    }
    
    Auto powerSource = IOPSGetPowerSourceDescription(blob, CFArrayGetValueAtIndex(sourcesList, 0));
    CFRetain(powerSource);
    CFRelease(sourcesList);
    
    CFAutorelease(powerSource);
    return (__bridge NSDictionary *)powerSource;
}

#pragma mark - Capacity Change Handler

- (BOOL)isRegistered
{
    return self.runLoopSource != nil;
}

- (void)registerForCapacityChangesIfNeeded
{
    if(self.runLoopSource != nil) { return; }
    
    Auto runLoopSource = IOPSNotificationCreateRunLoopSource(KYABatteryMonitorChangeHandler, (__bridge void *)self);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopDefaultMode);
    
    self.runLoopSource = runLoopSource;
    CFRelease(runLoopSource);
}

- (void)unregisterFromCapacityChanges
{
    if(self.runLoopSource == nil) { return; }
    
    CFRunLoopRemoveSource(CFRunLoopGetCurrent(), self.runLoopSource, kCFRunLoopDefaultMode);
    self.runLoopSource = nil;
}

@end

#pragma mark - KYABatteryMonitorChangeHandler

static void KYABatteryMonitorChangeHandler(void *context)
{
    Auto batteryMonitor = (__bridge KYABatteryMonitor *)context;
    if(batteryMonitor.capacityChangeHandler)
    {
        batteryMonitor.capacityChangeHandler(batteryMonitor.currentCapacity);
    }
}
