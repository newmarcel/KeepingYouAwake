//
//  KYADevice.m
//  KYADeviceInfo
//
//  Created by Marcel Dierkes on 19.02.22.
//  Copyright © 2022 Marcel Dierkes. All rights reserved.
//

#import <KYADeviceInfo/KYADevice.h>
#import "../KYADefines.h"
#import "../KYABatteryMonitor/KYABatteryMonitor+Private.h"
#import "../KYALowPowerModeMonitor/KYALowPowerModeMonitor+Private.h"

const NSNotificationName KYADeviceParameterDidChangeNotification = @"KYADeviceParameterDidChangeNotification";
NSString * const KYADeviceParameterKey = @"KYADeviceParameterKey";
const KYADeviceParameter KYADeviceParameterBattery = @"KYADeviceParameterBattery";
const KYADeviceParameter KYADeviceParameterLowPowerMode = @"KYADeviceParameterLowPowerMode";

@interface KYADevice ()
@property (nonatomic, readwrite) KYABatteryMonitor *batteryMonitor;
@property (nonatomic, readwrite) KYALowPowerModeMonitor *lowPowerModeMonitor;
@property (nonatomic) os_log_t log;
@end

@implementation KYADevice

+ (instancetype)currentDevice
{
    static dispatch_once_t once;
    static KYADevice *currentDevice;
    dispatch_once(&once, ^{
        currentDevice = [[self alloc] init];
    });
    return currentDevice;
}

#pragma mark -

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.batteryMonitor = [KYABatteryMonitor new];
        self.lowPowerModeMonitor = [KYALowPowerModeMonitor new];
        self.log = KYALogCreateWithCategory("DeviceInfo");
    }
    return self;
}

#pragma mark - Battery Monitor

- (BOOL)isBatteryMonitoringEnabled
{
    return [self.batteryMonitor isRegistered];
}

- (void)setBatteryMonitoringEnabled:(BOOL)batteryMonitoringEnabled
{
    Auto batteryMonitor = self.batteryMonitor;
    
    if(batteryMonitoringEnabled == YES)
    {
        // Do not start monitoring if the device does not support this feature
        if([batteryMonitor hasBattery] == NO) { return; }
        
        AutoWeak weakSelf = self;
        batteryMonitor.capacityChangeHandler = ^(CGFloat capacity) {
            Auto strongSelf = weakSelf;
            
            if([strongSelf isBatteryMonitoringEnabled])
            {
                [strongSelf deviceParameterDidChange:KYADeviceParameterBattery];
            }
        };
        [batteryMonitor registerForCapacityChangesIfNeeded];
    }
    else
    {
        [batteryMonitor unregisterFromCapacityChanges];
        batteryMonitor.capacityChangeHandler = nil;
    }
    
    os_log(self.log, "Battery Monitoring: %{public}@", batteryMonitoringEnabled ? @"YES" : @"NO");
}

#pragma mark - Lower Power Mode

- (BOOL)isLowPowerModeMonitoringEnabled
{
    return [self.lowPowerModeMonitor isRegistered];
}

- (void)setLowPowerModeMonitoringEnabled:(BOOL)lowPowerModeMonitoringEnabled
{
    Auto lowPowerModeMonitor = self.lowPowerModeMonitor;
    
    if(lowPowerModeMonitoringEnabled)
    {
        // Do not start monitoring if the device does not support this feature
        if([lowPowerModeMonitor supportsLowPowerMode] == NO) { return; }
        
        AutoWeak weakSelf = self;
        lowPowerModeMonitor.lowPowerModeChangeHandler = ^(BOOL enabled) {
            Auto strongSelf = weakSelf;
            
            if([strongSelf isLowPowerModeMonitoringEnabled])
            {
                [strongSelf deviceParameterDidChange:KYADeviceParameterLowPowerMode];
            }
        };
        [lowPowerModeMonitor registerForLowPowerModeChanges];
    }
    else
    {
        [lowPowerModeMonitor unregisterFromLowPowerModeChanges];
        lowPowerModeMonitor.lowPowerModeChangeHandler = nil;
    }
    
    os_log(self.log, "Low Power Mode Monitoring: %{public}@", lowPowerModeMonitoringEnabled ? @"YES" : @"NO");
}

#pragma mark - Notifications

- (void)deviceParameterDidChange:(KYADeviceParameter)deviceParameter
{
    NSParameterAssert(deviceParameter);
    
    Auto center = NSNotificationCenter.defaultCenter;
    Auto userInfo = @{
        KYADeviceParameterKey: deviceParameter
    };
    
    dispatch_async(dispatch_get_main_queue(), ^{
       [center postNotificationName:KYADeviceParameterDidChangeNotification
                             object:self
                           userInfo:userInfo];
    });
    
    os_log(self.log, "Device parameter did change: %{public}@, %{public}@.", deviceParameter, userInfo);
}

@end
