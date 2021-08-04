//
//  KYADefines.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 21.10.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#ifndef KYA_DEFINES_H
#define KYA_DEFINES_H

#define Auto const __auto_type
#define AutoVar __auto_type
#define AutoWeak __weak __auto_type const

#if DEBUG
#define KYALog(_args...) NSLog(_args)
#else
#define KYALog(_args...)
#endif

#endif /* KYA_DEFINES_H */
