//
//  KYAAboutPreferencesViewController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 18.12.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import "KYAAboutPreferencesViewController.h"
#import "NSApplication+Versions.h"

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
    return [NSApplication sharedApplication].kya_localizedVersionString;
}

- (NSString *)copyrightText
{
    return [NSApplication sharedApplication].kya_localizedCopyrightString;
}

- (id)creditsFileURL
{
    return [[NSBundle mainBundle] URLForResource:@"Credits" withExtension:@"rtf"];
}

- (BOOL)isEditable
{
    return NO;
}

@end
