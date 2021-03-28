//
//  NSBundle+KYAUpdateFeed.h
//  KYAKit
//
//  Created by Marcel Dierkes on 26.02.21.
//  Copyright © 2021 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (KYAUpdateFeed)
@property (nonatomic, readonly) NSString *kya_updateFeedURLString;
@property (nonatomic, readonly) NSString *kya_preReleaseUpdateFeedURLString;
@end

NS_ASSUME_NONNULL_END
