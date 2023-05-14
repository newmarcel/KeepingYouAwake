//
//  KYAApplicationSupportLog.m
//  KYAApplicationSupport
//
//  Created by Marcel Dierkes on 14.05.23.
//

#import "KYAApplicationSupportLog.h"
#import "KYADefines.h"

os_log_t KYAApplicationSupportLog()
{
    static os_log_t log;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        log = KYALogCreateWithCategory("ApplicationSupport");
    });
    return log;
}
