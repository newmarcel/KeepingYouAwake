//
//  KYABatterySettingsViewController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 23.09.21.
//  Copyright © 2021 Marcel Dierkes. All rights reserved.
//

#import "KYABatterySettingsViewController.h"
#import <KYACommon/KYACommon.h>
#import "KYALocalizedStrings.h"
#import "KYABatteryCapacityThreshold.h"

@interface KYABatterySettingsViewController ()
@end

@implementation KYABatterySettingsViewController

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

#pragma mark - Battery Settings Did Change

- (void)batterySettingsDidChange:(id)sender
{
    Auto center = NSNotificationCenter.defaultCenter;
    [center postNotificationName:kKYABatteryCapacityThresholdDidChangeNotification
                          object:nil];
}

@end
