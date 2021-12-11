//
//  KYAAppUpdater.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 26.09.21.
//  Copyright © 2021 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KYAKit/KYAKit.h>

NS_ASSUME_NONNULL_BEGIN

#ifndef KYA_APP_UPDATER_ENABLED
  #define KYA_APP_UPDATER_ENABLED 0
#endif

#if KYA_APP_UPDATER_ENABLED

@class SPUUpdater;

/// Checks for app updates and is a wrapper around
/// the Sparkle framework.
@interface KYAAppUpdater : NSObject
/// The shared updater instance, prefer this over individual instances
@property (class, nonatomic, readonly) KYAAppUpdater *defaultAppUpdater;

/// Convenience access to the underlying Sparkle updater.
@property (nonatomic, readonly, nullable) SPUUpdater *updater;

/// Start checking for app updates.
/// @param sender A sender
- (void)checkForUpdates:(id)sender;

@end

#endif

NS_ASSUME_NONNULL_END
