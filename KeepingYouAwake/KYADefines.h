//
//  KYADefines.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 21.10.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#ifndef KYA_DEFINES_H
#define KYA_DEFINES_H

#define KYA_AUTO __auto_type const
#define KYA_AUTO_VAR __auto_type
#define KYA_WEAK __weak __auto_type

#define KYA_SDK_IS_MACOS_11 (__MAC_OS_X_VERSION_MAX_ALLOWED >= 101600)

#if DEBUG
#define KYALog(_args...) NSLog(_args)
#else
#define KYALog(_args...)
#endif

#endif /* KYA_DEFINES_H */
