//
//  KYAStatusItemController.m
//  KYAStatusItemUI
//
//  Created by Marcel Dierkes on 10.09.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import <KYAStatusItemUI/KYAStatusItemController.h>
#import <KYAStatusItemUI/KYAStatusItemImageProvider.h>
#import "KYADefines.h"
#import "KYAStatusItemUILocalizedStrings.h"

@interface KYAStatusItemController ()
@property (nonatomic, readwrite) NSStatusItem *systemStatusItem;
@end

@implementation KYAStatusItemController

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [self configureStatusItem];
    }
    return self;
}

#pragma mark - Configuration

- (void)configureStatusItem
{
    Auto statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    statusItem.highlightMode = ![NSUserDefaults standardUserDefaults].kya_menuBarIconHighlightDisabled;
    if([statusItem respondsToSelector:@selector(behavior)])
    {
        statusItem.behavior = NSStatusItemBehaviorTerminationOnRemoval;
    }
    if([statusItem respondsToSelector:@selector(isVisible)])
    {
        statusItem.visible = YES;
    }
    
    Auto button = statusItem.button;
    
    [button sendActionOn:NSEventMaskLeftMouseUp|NSEventMaskRightMouseUp];
    button.target = self;
    button.action = @selector(toggleStatus:);
    
#if DEBUG
    if(@available(macOS 10.14, *))
    {
        button.contentTintColor = NSColor.systemBlueColor;
    }
    KYALog(@"Blue status bar item color is enabled for DEBUG builds.");
#endif
    
    self.systemStatusItem = statusItem;
    self.activeAppearanceEnabled = NO;
}

- (void)toggleStatus:(id)sender
{
    Auto delegate = self.delegate;
    Auto event = NSApplication.sharedApplication.currentEvent;
    
    if((event.modifierFlags & NSEventModifierFlagControl)   // ctrl click
       || (event.modifierFlags & NSEventModifierFlagOption) // alt click
       || (event.type == NSEventTypeRightMouseUp))          // right click
    {
        [self showMenuFromDataSource];
        return;
    }
    
    if([delegate respondsToSelector:@selector(statusItemControllerShouldPerformPrimaryAction:)])
    {
        [delegate statusItemControllerShouldPerformPrimaryAction:self];
    }
}

#pragma mark - Active Appearance

- (BOOL)isActiveAppearanceEnabled
{
    Auto menubarIcon = KYAStatusItemImageProvider.currentProvider;
    return self.systemStatusItem.image == menubarIcon.activeIconImage;
}

- (void)setActiveAppearanceEnabled:(BOOL)activeAppearanceEnabled
{
    Auto button = self.systemStatusItem.button;
    Auto imageProvider = KYAStatusItemImageProvider.currentProvider;
    
    if(activeAppearanceEnabled == YES)
    {
        button.image = imageProvider.activeIconImage;
        button.toolTip = KYA_L10N_CLICK_TO_ALLOW_SLEEP;
    }
    else
    {
        button.image = imageProvider.inactiveIconImage;
        button.toolTip = KYA_L10N_CLICK_TO_PREVENT_SLEEP;
    }
}

#pragma mark - Menu

- (void)showMenuFromDataSource
{
    Auto dataSource = self.dataSource;
    if([dataSource respondsToSelector:@selector(menuForStatusItemController:)])
    {
        Auto menu = [dataSource menuForStatusItemController:self];
        if(menu != nil)
        {
            [self.systemStatusItem popUpStatusItemMenu:menu];
        }
    }
}

@end
