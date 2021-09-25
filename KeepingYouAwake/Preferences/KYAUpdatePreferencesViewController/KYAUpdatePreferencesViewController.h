//
//  KYAUpdatePreferencesViewController.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 30.12.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Sparkle/Sparkle.h>
#import <KYAKit/KYAKit.h>
#import "KYAPreferencesContentViewController.h"

NS_ASSUME_NONNULL_BEGIN

/// Shows "Update" preferences and allows checking
/// for available app updates.
@interface KYAUpdatePreferencesViewController : KYAPreferencesContentViewController <SPUUpdaterDelegate>
@end

NS_ASSUME_NONNULL_END
