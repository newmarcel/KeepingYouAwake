//
//  KYAExport.h
//  KYACommon
//
//  Created by Marcel Dierkes on 29.03.24.
//

#import <Foundation/Foundation.h>

#if defined(__cplusplus)
    #define KYA_EXPORT extern "C"
#else
    #define KYA_EXPORT extern
#endif
