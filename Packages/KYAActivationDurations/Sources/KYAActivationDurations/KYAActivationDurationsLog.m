//
//  KYAActivationDurationsLog.m
//  KYAActivationDurations
//
//  Created by Marcel Dierkes on 14.05.23.
//

#import "KYAActivationDurationsLog.h"
#import <KYACommon/KYACommon.h>

os_log_t KYAActivationDurationsLog()
{
    static os_log_t log;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        log = KYALogCreateWithCategory("ActivationDurations");
    });
    return log;
}
