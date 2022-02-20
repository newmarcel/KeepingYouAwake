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
    return KYA_PREFS_L10N_BATTERY;
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

@end
