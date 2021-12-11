//
//  KYAUpdatePreferencesViewController.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 30.12.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <KYAKit/KYAKit.h>
#import "KYAAppUpdater.h"
#import "KYAPreferencesContentViewController.h"

#if KYA_APP_UPDATER_ENABLED

NS_ASSUME_NONNULL_BEGIN

/// Shows "Update" preferences and allows checking
/// for available app updates.
@interface KYAUpdatePreferencesViewController : KYAPreferencesContentViewController
@property (nonatomic, readonly) KYAAppUpdater *appUpdater;

- (IBAction)checkForUpdates:(id)sender;

@end

NS_ASSUME_NONNULL_END

#endif
