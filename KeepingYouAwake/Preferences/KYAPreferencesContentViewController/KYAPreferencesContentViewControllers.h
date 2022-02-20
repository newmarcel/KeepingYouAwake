//
//  KYAPreferencesContentViewControllers.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 20.09.21.
//  Copyright © 2021 Marcel Dierkes. All rights reserved.
//

#import "KYAPreferencesContentViewController.h"

#import "KYAGeneralPreferencesViewController.h"
#import "KYADurationPreferencesViewController.h"
#import "KYABatteryPreferencesViewController.h"
#import "KYAAdvancedPreferencesViewController.h"
#import "KYAAboutPreferencesViewController.h"

#if KYA_APP_UPDATER_ENABLED
    #import "KYAUpdatePreferencesViewController.h"
#endif
