//
//  NSApplication+KYALaunchAtLogin.m
//  KYAApplicationSupport
//
//  Created by Marcel Dierkes on 25.12.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import <KYAApplicationSupport/NSApplication+KYALaunchAtLogin.h>
#import <ServiceManagement/ServiceManagement.h>
#import "KYADefines.h"

@implementation NSApplication (KYALaunchAtLogin)

- (BOOL)kya_isLaunchAtLoginEnabled
{
    if(@available(macOS 13.0, *))
    {
        return KYALaunchAtLoginAppServiceIsEnabled();
    }
    else
    {
        return KYALaunchAtLoginLoginItemIsEnabled();
    }
}

- (BOOL)kya_launchAtLoginEnabled
{
    return [self kya_isLaunchAtLoginEnabled];
}

- (void)setKya_launchAtLoginEnabled:(BOOL)launchAtLoginEnabled
{
    [self willChangeValueForKey:@"kya_launchAtLoginEnabled"];
    
    if(@available(macOS 13.0, *))
    {
        return KYALaunchAtLoginAppServiceSetEnabled(launchAtLoginEnabled);
    }
    else
    {
        return KYALaunchAtLoginLoginItemSetEnabled(launchAtLoginEnabled);
    }
    
    [self didChangeValueForKey:@"kya_launchAtLoginEnabled"];
}

#pragma mark - Migration

- (void)kya_migrateLaunchAtLoginToAppServiceIfNeeded
{
    if(KYALaunchAtLoginUserDefaultExists() == NO) { return; }
    
    if(KYALaunchAtLoginLoginItemIsEnabled())
    {
        KYALaunchAtLoginLoginItemSetEnabled(NO);
        KYALaunchAtLoginAppServiceSetEnabled(YES);
    }
    
    KYALaunchAtLoginUserDefaultReset();
}

#pragma mark - SMAppService

NS_INLINE BOOL KYALaunchAtLoginAppServiceIsEnabled() API_AVAILABLE(macos(13.0))
{
    Auto status = SMAppService.mainAppService.status;
    if(status == SMAppServiceStatusRequiresApproval)
    {
        [SMAppService openSystemSettingsLoginItems];
    }
    
    return status == SMAppServiceStatusEnabled;
}

NS_INLINE void KYALaunchAtLoginAppServiceSetEnabled(BOOL enabled) API_AVAILABLE(macos(13.0))
{
    Auto appService = SMAppService.mainAppService;
    
    if(enabled == YES)
    {
        NSError *error;
        [appService registerAndReturnError:&error];
        
        if(error != nil)
        {
            KYALog(@"Failed to register launch at login %@", error.userInfo);
        }
    }
    else
    {
        NSError *error;
        [appService unregisterAndReturnError:&error];
        
        if(error != nil)
        {
            KYALog(@"Failed to unregister launch at login %@", error.userInfo);
        }
    }
}

#pragma mark - User Default (Legacy)

static NSString * const KYALauncherBundleIdentifier = @"info.marcel-dierkes.KeepingYouAwake.Launcher";
static NSString * const KYALauncherStateUserDefaultsKey = @"info.marcel-dierkes.KeepingYouAwake.LaunchAtLogin";

NS_INLINE BOOL KYALaunchAtLoginUserDefaultExists()
{
    Auto defaults = NSUserDefaults.standardUserDefaults;
    return [defaults objectForKey:KYALauncherStateUserDefaultsKey] != nil;
}

NS_INLINE BOOL KYALaunchAtLoginUserDefaultIsEnabled()
{
    Auto defaults = NSUserDefaults.standardUserDefaults;
    return [defaults boolForKey:KYALauncherStateUserDefaultsKey];
}

NS_INLINE BOOL KYALaunchAtLoginUserDefaultSetEnabled(BOOL enabled)
{
    Auto defaults = NSUserDefaults.standardUserDefaults;
    [defaults setBool:enabled forKey:KYALauncherStateUserDefaultsKey];
}

NS_INLINE BOOL KYALaunchAtLoginUserDefaultReset()
{
    Auto defaults = NSUserDefaults.standardUserDefaults;
    [defaults removeObjectForKey:KYALauncherStateUserDefaultsKey];
}

#pragma mark - SMLoginItemSetEnabled (Legacy)

NS_INLINE BOOL KYALaunchAtLoginLoginItemIsEnabled()
{
    BOOL enabled = KYALaunchAtLoginUserDefaultIsEnabled();
    Boolean success = SMLoginItemSetEnabled((__bridge CFStringRef)KYALauncherBundleIdentifier, (Boolean)enabled);
    if(success == false)
    {
        KYALog(@"Failed to set login item to %@", @(enabled));
    }
    return enabled;
}

NS_INLINE void KYALaunchAtLoginLoginItemSetEnabled(BOOL enabled)
{
    Boolean success = SMLoginItemSetEnabled((__bridge CFStringRef)KYALauncherBundleIdentifier, (Boolean)enabled);
    if(success == true)
    {
        KYALaunchAtLoginUserDefaultSetEnabled(enabled);
    }
    else
    {
        KYALog(@"Failed to set login item to %@", @(enabled));
    }
}

@end
