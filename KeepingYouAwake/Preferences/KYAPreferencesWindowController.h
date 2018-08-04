//
//  KYAPreferencesWindowController.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 30.12.16.
//  Copyright © 2016 Marcel Dierkes. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYAPreferencesWindowController : NSWindowController

/**
 Instantiates a new preferences window controller
 for the Preferences storyboard.

 @return A new instance.
 */
- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
