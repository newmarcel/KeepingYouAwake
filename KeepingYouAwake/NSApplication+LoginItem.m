//
//  NSApplication+LoginItem.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 24.10.14.
//  Copyright (c) 2014 Marcel Dierkes. All rights reserved.
//
//  Adapted from this article: http://bdunagan.com/2010/09/25/cocoa-tip-enabling-launch-on-startup/
//

#import "NSApplication+LoginItem.h"

@implementation NSApplication (LoginItem)
@dynamic kya_startAtLogin;

- (void)setKya_startAtLogin:(BOOL)startAtLogin
{
    if(startAtLogin)
    {
        [self kya_addToLoginItems];
    }
    else
    {
        [self kya_removeFromLoginItems];
    }
}

- (BOOL)kya_isStartingAtLogin
{
    return [self kya_hasLoginItem];
}

#pragma mark - Internal Methods

- (BOOL)kya_hasLoginItem
{
    BOOL result = NO;
    LSSharedFileListItemRef loginItem = [self kya_retainedLoginItem];
    if(loginItem)
    {
        result = YES;
    }
    
    return result;
}

- (void)kya_removeFromLoginItems
{
    LSSharedFileListItemRef loginItem = [self kya_retainedLoginItem];
    if(loginItem)
    {
        LSSharedFileListRef loginItemsFileList = LSSharedFileListCreate(kCFAllocatorDefault,
                                                                        kLSSharedFileListSessionLoginItems,
                                                                        NULL);
        LSSharedFileListItemRemove(loginItemsFileList,loginItem);
        CFRelease(loginItemsFileList);
        
        CFRelease(loginItem);
    }
}

- (void)kya_addToLoginItems
{
    NSURL *bundleURL = [[NSBundle mainBundle] bundleURL];
    
    LSSharedFileListRef loginItemsFileList = LSSharedFileListCreate(kCFAllocatorDefault,
                                                                    kLSSharedFileListSessionLoginItems,
                                                                    NULL);
    if(loginItemsFileList)
    {
        LSSharedFileListItemRef fileListItem = LSSharedFileListInsertItemURL(loginItemsFileList,
                                                                             kLSSharedFileListItemLast,
                                                                             NULL,
                                                                             NULL,
                                                                             (__bridge CFURLRef)bundleURL,
                                                                             NULL,
                                                                             NULL);
        if(fileListItem)
        {
            CFRelease(fileListItem);
        }
        
        CFRelease(loginItemsFileList);
    }
}

- (LSSharedFileListItemRef)kya_retainedLoginItem
{
    NSURL *bundleURL = [[NSBundle mainBundle] bundleURL];
    
    LSSharedFileListRef loginItemsFileList = LSSharedFileListCreate(kCFAllocatorDefault,
                                                                    kLSSharedFileListSessionLoginItems,
                                                                    NULL);
    LSSharedFileListItemRef loginItem = NULL;
    
    if(loginItemsFileList)
    {
        UInt32 snapshotSeed;
        NSArray *loginItems = (__bridge_transfer NSArray *)(LSSharedFileListCopySnapshot(loginItemsFileList, &snapshotSeed));
        
        for(NSInteger i = 0; i < loginItems.count; i++)
        {
            LSSharedFileListItemRef fileListItem = (__bridge LSSharedFileListItemRef)loginItems[i];
            
            NSURL *itemURL = (__bridge_transfer NSURL *)LSSharedFileListItemCopyResolvedURL(fileListItem, 0, NULL);
            if([bundleURL isEqual:itemURL])
            {
                loginItem = fileListItem;
            }
        }
        
        CFRelease(loginItemsFileList);
    }
    
    return loginItem;
}

@end
