//
//  KYAActivationDurationsMenuController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 07.08.19.
//  Copyright © 2019 Marcel Dierkes. All rights reserved.
//

#import "KYAActivationDurationsMenuController.h"
#import "KYADefines.h"
#import "KYALocalizedStrings.h"
#import "NSDate+RemainingTime.h"

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
    KYA_AUTO delegate = self.delegate;
    if([delegate respondsToSelector:@selector(activationDurationsMenuController:didSelectActivationDuration:)])
    {
        NSTimeInterval seconds = (NSTimeInterval)sender.tag;
        KYA_AUTO duration = [[KYAActivationDuration alloc] initWithSeconds:seconds];
        [delegate activationDurationsMenuController:self didSelectActivationDuration:duration];
    }
}

- (void)setDefaultActivationDuration:(nullable NSMenuItem *)sender
{
    NSTimeInterval seconds = (NSTimeInterval)sender.tag;
    
    KYA_AUTO controller = self.activationDurationsController;
    KYA_AUTO durations = controller.activationDurationsIncludingInfinite;
    
    KYA_AUTO predicate = [NSPredicate predicateWithFormat:@"seconds == %@", @(seconds)];
    KYA_AUTO results = [durations filteredArrayUsingPredicate:predicate];
    
    self.activationDurationsController.defaultActivationDuration = results.firstObject;
}

#pragma mark - NSMenuDelegate

- (void)menuNeedsUpdate:(NSMenu *)menu
{
    [menu removeAllItems];
    
    KYA_AUTO controller = self.activationDurationsController;
    
    KYA_AUTO remainingTimeMenuItem = [self menuItemForRemainingTime];
    if(remainingTimeMenuItem != nil)
    {
        [menu addItem:remainingTimeMenuItem];
        [menu addItem:NSMenuItem.separatorItem];
    }
    
    for(KYAActivationDuration *duration in controller.activationDurationsIncludingInfinite)
    {
        KYA_AUTO menuItem = [menu addItemWithTitle:duration.localizedTitle
                                            action:@selector(selectActivationDuration:)
                                     keyEquivalent:@""];
        menuItem.target = self;
        menuItem.tag = (NSInteger)duration.seconds;
        
        // Alternate state
        KYA_AUTO alternateTitle = KYA_L10N_SET_DEFAULT_ACTIVATION_DURATION(duration.localizedTitle);
        KYA_AUTO alternateMenuItem = [menu addItemWithTitle:alternateTitle
                                                     action:@selector(setDefaultActivationDuration:)
                                              keyEquivalent:@""];
        alternateMenuItem.target = self;
        alternateMenuItem.alternate = YES;
        alternateMenuItem.keyEquivalentModifierMask = NSEventModifierFlagOption;
        alternateMenuItem.tag = (NSInteger)duration.seconds;
        
        // Is Default
        BOOL isDefault = [controller.defaultActivationDuration isEqualToActivationDuration:duration];
        menuItem.attributedTitle = [self attributedStringForMenuItemTitle:menuItem.title isDefault:isDefault];
        
        // Is Scheduled
        KYA_AUTO delegate = self.delegate;
        if([delegate respondsToSelector:@selector(currentActivationDuration)])
        {
            KYA_AUTO current = [delegate currentActivationDuration];
            if(current != nil && ([current isEqualToActivationDuration:duration]))
            {
                menuItem.state = NSControlStateValueOn;
                alternateMenuItem.state = NSControlStateValueOn;
            }
        }
    }
}

- (NSAttributedString *)attributedStringForMenuItemTitle:(NSString *)title isDefault:(BOOL)isDefault
{
    KYA_AUTO attributed = [NSMutableAttributedString new];
    
    KYA_AUTO font = [NSFont monospacedDigitSystemFontOfSize:KYAMenuItemDefaultFontSize
                                                     weight:NSFontWeightRegular];
    
    KYA_AUTO attributes = @{ NSFontAttributeName: font };
    KYA_AUTO attributedTitle = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", title]
                                                               attributes:attributes];
    [attributed appendAttributedString:attributedTitle];
    
    if(isDefault)
    {
        KYA_AUTO defaultAttributes = @{
                                       NSFontAttributeName: font,
                                       NSForegroundColorAttributeName: NSColor.tertiaryLabelColor
                                       };
        KYA_AUTO attributedDefault = [[NSAttributedString alloc] initWithString:KYA_L10N_IS_DEFAULT_SUFFIX
                                                                     attributes:defaultAttributes];
        [attributed appendAttributedString:attributedDefault];
    }
    
    return [attributed copy];
}

- (nullable NSMenuItem *)menuItemForRemainingTime
{
    KYA_AUTO delegate = self.delegate;
    if(![delegate respondsToSelector:@selector(fireDateForMenuController:)]) { return nil; }
    
    KYA_AUTO fireDate = [delegate fireDateForMenuController:self];
    if(fireDate == nil) { return nil; }
    
    KYA_AUTO menuItem = [[NSMenuItem alloc] initWithTitle:fireDate.kya_localizedRemainingTime
                                                   action:nil
                                            keyEquivalent:@""];
    menuItem.tag = KYAMenuItemRemainingTimeTag;
    return menuItem;
}

- (void)updateRemainingTime:(id)sender
{
    KYA_AUTO delegate = self.delegate;
    if(![delegate respondsToSelector:@selector(fireDateForMenuController:)]) { return; }
    
    KYA_AUTO fireDate = [delegate fireDateForMenuController:self];
    if(fireDate == nil) { return; }
    
    KYA_AUTO menuItem = self.menu.itemArray.firstObject;
    if(menuItem != nil && menuItem.tag == KYAMenuItemRemainingTimeTag)
    {
        menuItem.title = fireDate.kya_localizedRemainingTime;
    }
}

@end
