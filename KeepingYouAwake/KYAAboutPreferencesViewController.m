//
//  KYAAboutPreferencesViewController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 18.12.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import "KYAAboutPreferencesViewController.h"

@interface KYAAboutPreferencesViewController ()

@end

@implementation KYAAboutPreferencesViewController

- (void)viewWillAppear
{
    [super viewWillAppear];
    
    self.preferredContentSize = self.view.fittingSize;
}

@end
