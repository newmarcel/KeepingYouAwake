//
//  KYADefines.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 21.10.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#ifndef KYA_DEFINES_H
#define KYA_DEFINES_H

#define KYA_AUTO __auto_type

#if DEBUG
    #define KYALog(_args...) NSLog(_args)
#else
    #define KYALog(_args...)
#endif

#endif /* KYA_DEFINES_H */
