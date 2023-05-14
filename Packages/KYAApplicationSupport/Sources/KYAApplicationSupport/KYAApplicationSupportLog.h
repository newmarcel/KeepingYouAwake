//
//  KYAApplicationSupportLog.h
//  KYAApplicationSupport
//
//  Created by Marcel Dierkes on 14.05.23.
//

#import <Foundation/Foundation.h>
#import <os/log.h>

NS_ASSUME_NONNULL_BEGIN

/// Returns the default log for the ApplicationSupport category.
FOUNDATION_EXPORT os_log_t KYAApplicationSupportLog(void);

NS_ASSUME_NONNULL_END
