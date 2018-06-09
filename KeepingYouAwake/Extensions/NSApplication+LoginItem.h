//
//  NSApplication+LoginItem.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 24.10.14.
//  Copyright (c) 2014 Marcel Dierkes. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 *  An NSApplication category to simply enable or disable the application
 *  as login item for the currently logged in user.
 */
@interface NSApplication (LoginItem)

/**
 *  Set to YES to add the application to the system login items.
 */
@property (assign, nonatomic, getter=kya_isStartingAtLogin) BOOL kya_startAtLogin;

@end
