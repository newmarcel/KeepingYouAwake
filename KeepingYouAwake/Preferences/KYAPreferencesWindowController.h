//
//  KYAPreferencesWindowController.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 30.12.16.
//  Copyright © 2016 Marcel Dierkes. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface KYAPreferencesWindowController : NSWindowController

/**
 Instantiates a preferences window controller from the
 Preferences storyboard.

 @return A new instance.
 */
+ (instancetype)defaultPreferencesWindowController;

@end
