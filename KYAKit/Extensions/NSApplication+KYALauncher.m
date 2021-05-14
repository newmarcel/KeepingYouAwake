//
//  NSApplication+KYALauncher.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 25.12.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import "NSApplication+KYALauncher.h"
#import <ServiceManagement/ServiceManagement.h>
#import "KYADefines.h"

static NSString * const KYALauncherBundleIdentifier = @"info.marcel-dierkes.KeepingYouAwake.Launcher";
static NSString * const KYALauncherStateUserDefaultsKey = @"info.marcel-dierkes.KeepingYouAwake.LaunchAtLogin";

@implementation NSApplication (KYALauncher)

- (BOOL)kya_isLaunchAtLoginEnabled
{
    Auto defaults = NSUserDefaults.standardUserDefaults;
    BOOL isEnabled = [defaults boolForKey:KYALauncherStateUserDefaultsKey];
    Boolean success = SMLoginItemSetEnabled((__bridge CFStringRef)KYALauncherBundleIdentifier, (Boolean)isEnabled);
    if(success == false)
    {
        KYALog(@"Failed to set login item to %@", @(isEnabled));
    }
    return isEnabled;
}

- (BOOL)kya_launchAtLoginEnabled
{
    return [self kya_isLaunchAtLoginEnabled];
}

- (void)setKya_launchAtLoginEnabled:(BOOL)launchAtLoginEnabled
{
    [self willChangeValueForKey:@"kya_launchAtLoginEnabled"];
    Boolean success = SMLoginItemSetEnabled((__bridge CFStringRef)KYALauncherBundleIdentifier, (Boolean)launchAtLoginEnabled);
    if(success == true)
    {
        Auto defaults = NSUserDefaults.standardUserDefaults;
        [defaults setBool:launchAtLoginEnabled forKey:KYALauncherStateUserDefaultsKey];
    }
    else
    {
        KYALog(@"Failed to set login item to %@", @(launchAtLoginEnabled));
    }
    [self didChangeValueForKey:@"kya_launchAtLoginEnabled"];
}

@end
