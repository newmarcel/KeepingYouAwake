//
//  NSBundle+KYAVersion.h
//  KYAKit
//
//  Created by Marcel Dierkes on 30.03.21.
//  Copyright © 2021 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (KYAVersion)
@property (copy, nonatomic, readonly) NSString *kya_shortVersionString;
@property (copy, nonatomic, readonly) NSString *kya_buildVersionString;
@property (copy, nonatomic, readonly) NSString *kya_localizedVersionString;

@property (copy, nonatomic, readonly) NSString *kya_localizedCopyrightString;

@end

NS_ASSUME_NONNULL_END
