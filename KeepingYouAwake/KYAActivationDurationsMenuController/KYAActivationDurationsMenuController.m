//
//  KYAActivationDurationsMenuController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 07.08.19.
//  Copyright © 2019 Marcel Dierkes. All rights reserved.
//

#import "KYAActivationDurationsMenuController.h"
#import <KYACommon/KYACommon.h>
#import "KYALocalizedStrings.h"
#import "KYAActivationDuration+KYALocalizedTitle.h"

static const NSInteger KYAMenuItemRemainingTimeTag = 666;
static const CGFloat KYAMenuItemDefaultFontSize = 14.0f;

@interface KYAActivationDurationsMenuController ()
@property (nonatomic, readwrite) NSMenu *menu;
@end

@implementation KYAActivationDurationsMenuController

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.activationDurationsController = KYAActivationDurationsController.sharedController;
        self.menu = [[NSMenu alloc] initWithTitle:KYA_L10N_ACTIVATE_FOR_DURATION];
        self.menu.delegate = self;
    }
    return self;
}

- (void)selectActivationDuration:(nullable NSMenuItem *)sender
{
    Auto delegate = self.delegate;
    if([delegate respondsToSelector:@selector(activationDurationsMenuController:didSelectActivationDuration:)])
    {
        KYAActivationDuration *duration = sender.representedObject;
        if(duration == nil)
        {
            NSTimeInterval seconds = (NSTimeInterval)sender.tag;
            duration = [[KYAActivationDuration alloc] initWithSeconds:seconds];
        }
        [delegate activationDurationsMenuController:self didSelectActivationDuration:duration];
    }
}

- (void)requestUntilDate:(nullable NSMenuItem *)sender
{
    Auto delegate = self.delegate;
    if([delegate respondsToSelector:@selector(activationDurationsMenuControllerDidRequestUntilDate:)])
    {
        [delegate activationDurationsMenuControllerDidRequestUntilDate:self];
    }
}

- (void)setDefaultActivationDuration:(nullable NSMenuItem *)sender
{
    KYAActivationDuration *duration = sender.representedObject;
    if(duration == nil)
    {
        NSTimeInterval seconds = (NSTimeInterval)sender.tag;
        Auto durations = self.activationDurationsController.activationDurations;
        Auto predicate = [NSPredicate predicateWithFormat:@"clockTimeSeconds == -1 AND seconds == %@", @(seconds)];
        duration = [durations filteredArrayUsingPredicate:predicate].firstObject;
    }
    if(duration == nil) { return; }
    
    self.activationDurationsController.defaultActivationDuration = duration;
}

#pragma mark -

- (NSAttributedString *)attributedStringForMenuItemTitle:(NSString *)title isDefault:(BOOL)isDefault
{
    Auto attributed = [NSMutableAttributedString new];
    
    Auto font = [NSFont monospacedDigitSystemFontOfSize:KYAMenuItemDefaultFontSize
                                                 weight:NSFontWeightRegular];
    
    Auto attributes = @{ NSFontAttributeName: font };
    Auto attributedTitle = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", title]
                                                           attributes:attributes];
    [attributed appendAttributedString:attributedTitle];
    
    if(isDefault)
    {
        Auto defaultAttributes = @{
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: [self defaultAttributeTextColor]
        };
        Auto attributedDefault = [[NSAttributedString alloc] initWithString:KYA_L10N_IS_DEFAULT_SUFFIX
                                                                 attributes:defaultAttributes];
        [attributed appendAttributedString:attributedDefault];
    }
    
    return [attributed copy];
}

- (NSColor *)defaultAttributeTextColor
{
    return NSColor.secondaryLabelColor;
}

- (nullable NSMenuItem *)menuItemForRemainingTime
{
    Auto delegate = self.delegate;
    if(![delegate respondsToSelector:@selector(fireDateForMenuController:)]) { return nil; }
    
    Auto fireDate = [delegate fireDateForMenuController:self];
    if(fireDate == nil) { return nil; }
    
    Auto menuItem = [[NSMenuItem alloc] initWithTitle:fireDate.kya_localizedRemainingTime
                                               action:nil
                                        keyEquivalent:@""];
    menuItem.tag = KYAMenuItemRemainingTimeTag;
    return menuItem;
}

// TODO: Use this for live updates of the menu item
- (void)updateRemainingTime:(id)sender
{
    Auto delegate = self.delegate;
    if(![delegate respondsToSelector:@selector(fireDateForMenuController:)]) { return; }
    
    Auto fireDate = [delegate fireDateForMenuController:self];
    if(fireDate == nil) { return; }
    
    Auto menuItem = self.menu.itemArray.firstObject;
    if(menuItem != nil && menuItem.tag == KYAMenuItemRemainingTimeTag)
    {
        menuItem.title = fireDate.kya_localizedRemainingTime;
    }
}

#pragma mark - NSMenuDelegate

- (void)menuNeedsUpdate:(NSMenu *)menu
{
    [menu removeAllItems];
    
    Auto controller = self.activationDurationsController;
    
    Auto remainingTimeMenuItem = [self menuItemForRemainingTime];
    if(remainingTimeMenuItem != nil)
    {
        [menu addItem:remainingTimeMenuItem];
        [menu addItem:NSMenuItem.separatorItem];
    }
    
    BOOL didAddClockTimeSeparator = NO;
    for(KYAActivationDuration *duration in controller.activationDurations)
    {
        if(duration.isClockTime && !didAddClockTimeSeparator)
        {
            [menu addItem:NSMenuItem.separatorItem];
            didAddClockTimeSeparator = YES;
        }
        
        Auto menuItem = [menu addItemWithTitle:duration.localizedTitle
                                        action:@selector(selectActivationDuration:)
                                 keyEquivalent:@""];
        menuItem.target = self;
        menuItem.tag = (NSInteger)duration.seconds;
        menuItem.representedObject = duration;
        
        // Alternate state
        Auto alternateTitle = KYA_L10N_SET_DEFAULT_ACTIVATION_DURATION(duration.localizedTitle);
        Auto alternateMenuItem = [menu addItemWithTitle:alternateTitle
                                                 action:@selector(setDefaultActivationDuration:)
                                          keyEquivalent:@""];
        alternateMenuItem.target = self;
        alternateMenuItem.alternate = YES;
        alternateMenuItem.keyEquivalentModifierMask = NSEventModifierFlagOption;
        alternateMenuItem.tag = (NSInteger)duration.seconds;
        alternateMenuItem.representedObject = duration;
        
        // Is Default
        BOOL isDefault = [controller.defaultActivationDuration isEqualToActivationDuration:duration];
        menuItem.attributedTitle = [self attributedStringForMenuItemTitle:menuItem.title isDefault:isDefault];
        
        // Is Scheduled
        Auto delegate = self.delegate;
        if([delegate respondsToSelector:@selector(currentActivationDuration)])
        {
            Auto current = [delegate currentActivationDuration];
            if(current != nil && ([current isEqualToActivationDuration:duration]))
            {
                menuItem.state = NSControlStateValueOn;
                alternateMenuItem.state = NSControlStateValueOn;
            }
        }
    }
    
    if(!didAddClockTimeSeparator)
    {
        [menu addItem:NSMenuItem.separatorItem];
    }
    Auto untilItem = [menu addItemWithTitle:KYA_L10N_UNTIL_ELLIPSIS
                                     action:@selector(requestUntilDate:)
                              keyEquivalent:@""];
    untilItem.target = self;
}

@end
