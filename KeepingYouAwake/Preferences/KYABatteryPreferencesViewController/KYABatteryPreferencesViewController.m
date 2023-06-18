//
//  KYABatteryPreferencesViewController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 23.09.21.
//  Copyright © 2021 Marcel Dierkes. All rights reserved.
//

#import "KYABatteryPreferencesViewController.h"
#import "KYADefines.h"
#import "KYALocalizedStrings.h"
#import "KYABatteryCapacityThreshold.h"

@interface KYABatteryPreferencesViewController ()
@end

@implementation KYABatteryPreferencesViewController

+ (NSImage *)tabViewItemImage
{
    if(@available(macOS 11.0, *))
    {
        return [NSImage imageWithSystemSymbolName:@"battery.100"
                         accessibilityDescription:nil];
    }
    else
    {
        return [NSImage imageNamed:NSImageNameComputer];
    }
}

+ (NSString *)preferredTitle
{
    return KYA_SETTINGS_L10N_BATTERY;
}

- (BOOL)resizesView
{
    return YES;
}

#pragma mark - Device

- (KYADevice *)device
{
    return KYADevice.currentDevice;
}

#pragma mark - Battery Preferences Did Change

- (void)batteryPreferencesDidChange:(id)sender
{
    Auto center = NSNotificationCenter.defaultCenter;
    [center postNotificationName:kKYABatteryCapacityThresholdDidChangeNotification
                          object:nil];
}

@end
