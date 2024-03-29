//
//  KYAApplicationSupportLog.h
//  KYAApplicationSupport
//
//  Created by Marcel Dierkes on 14.05.23.
//

#import <Foundation/Foundation.h>
#import <os/log.h>
#import <KYACommon/KYACommon.h>

NS_ASSUME_NONNULL_BEGIN

/// Returns the default log for the ApplicationSupport category.
KYA_EXPORT os_log_t KYAApplicationSupportLog(void);

NS_ASSUME_NONNULL_END
