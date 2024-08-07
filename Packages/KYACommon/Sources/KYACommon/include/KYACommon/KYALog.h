//
//  KYALog.h
//  KYACommon
//
//  Created by Marcel Dierkes on 29.03.24.
//

#import <Foundation/Foundation.h>
#import <os/log.h>

NS_INLINE os_log_t KYALogCreateWithCategory(const char *category)
{
    return os_log_create("info.marcel-dierkes.KeepingYouAwake", category);
}
