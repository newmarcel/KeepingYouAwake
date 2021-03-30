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

#pragma mark - Bindings

- (NSString *)versionText
{
    return NSBundle.mainBundle.kya_localizedVersionString;
}

- (NSString *)copyrightText
{
    return NSBundle.mainBundle.kya_localizedCopyrightString;
}

- (id)creditsFileURL
{
    return [NSBundle.mainBundle URLForResource:@"Credits" withExtension:@"rtf"];
}

- (BOOL)isEditable
{
    return NO;
}

@end
