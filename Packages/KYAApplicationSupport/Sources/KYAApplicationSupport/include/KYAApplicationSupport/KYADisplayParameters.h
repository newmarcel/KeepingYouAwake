//
//  KYADisplayParameters.h
//  KYAApplicationSupport
//
//  Created by Marcel Dierkes on 16.12.24.
//  Copyright © 2024 Marcel Dierkes. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

/// Returns the number of connected external displays.
/// This function also takes into account when screen mirroring is used.
NSUInteger KYADisplayParametersGetNumberOfExternalDisplays(void);

NS_ASSUME_NONNULL_END
