//
//  KYAAutoType.h
//  KYACommon
//
//  Created by Marcel Dierkes on 21.10.17.
//

#import <Foundation/Foundation.h>

#if !defined(__cplusplus)
#if __STDC_VERSION__ == 202311L
    #define Auto const auto
    #define AutoVar auto
    #define AutoWeak __weak const auto
#else
    #define Auto const __auto_type
    #define AutoVar __auto_type
    #define AutoWeak __weak const __auto_type
#endif
#endif
