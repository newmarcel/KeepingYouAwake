//
//  KYAActivationDuration+KYALocalizedTitle.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 23.02.22.
//  Copyright © 2022 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KYAKit/KYAActivationDuration.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYAActivationDuration (KYALocalizedTitle)

/// A localized title text.
@property (nonatomic, readonly) NSString *localizedTitle;

@end

NS_ASSUME_NONNULL_END
