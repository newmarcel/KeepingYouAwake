//
//  KYAAboutPreferencesViewController.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 18.12.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <KYAApplicationSupport/KYAApplicationSupport.h>
#import "KYAPreferencesContentViewController.h"

NS_ASSUME_NONNULL_BEGIN

/// Shows an "About" screen with version and copyright information.
@interface KYAAboutPreferencesViewController : KYAPreferencesContentViewController
@property (copy, nonatomic, readonly) NSString *versionText;
@property (copy, nonatomic, readonly) NSString *copyrightText;

@end

NS_ASSUME_NONNULL_END
