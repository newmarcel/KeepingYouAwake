//
//  KYADefines.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 21.10.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#pragma once

#import <Foundation/Foundation.h>
#import <os/log.h>

// Auto Type
#define Auto const __auto_type
#define AutoVar __auto_type
#define AutoWeak __weak __auto_type const

// Logging
NS_INLINE os_log_t KYALogCreateWithCategory(const char *category)
{
    return os_log_create("info.marcel-dierkes.KeepingYouAwake", category);
}
