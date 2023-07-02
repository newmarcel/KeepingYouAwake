//
//  KYAUpdateSettingsViewController.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 30.12.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KYAAppUpdater.h"
#import "KYASettingsContentViewController.h"

#if KYA_APP_UPDATER_ENABLED

NS_ASSUME_NONNULL_BEGIN

/// Shows "Update" settings and allows checking
/// for available app updates.
@interface KYAUpdateSettingsViewController : KYASettingsContentViewController
@property (nonatomic, readonly) KYAAppUpdater *appUpdater;

- (IBAction)checkForUpdates:(id)sender;

@end

NS_ASSUME_NONNULL_END

#endif
