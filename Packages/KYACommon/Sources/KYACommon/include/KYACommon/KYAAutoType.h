//
//  KYAAutoType.h
//  KYACommon
//
//  Created by Marcel Dierkes on 21.10.17.
//

#import <Foundation/Foundation.h>

#if !defined(__cplusplus)
    #define Auto const __auto_type
    #define AutoVar __auto_type
    #define AutoWeak __weak const __auto_type
#endif
