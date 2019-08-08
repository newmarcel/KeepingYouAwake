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
        self.menu = [[NSMenu alloc] initWithTitle:@"Activate for Duration"];
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
    
    for(KYAActivationDuration *duration in controller.activationDurationsIncludingInfinite)
    {
        KYA_AUTO menuItem = [menu addItemWithTitle:duration.localizedTitle
                                            action:@selector(selectActivationDuration:)
                                     keyEquivalent:@""];
        menuItem.target = self;
        menuItem.tag = (NSInteger)duration.seconds;
        
        // Alternate state
        KYA_AUTO alternateTitle = [NSString stringWithFormat:KYA_L10N_SET_DEFAULT_ACTIVATION_DURATION,
                                   duration.localizedTitle];
        KYA_AUTO alternateMenuItem = [menu addItemWithTitle:alternateTitle
                                                     action:@selector(setDefaultActivationDuration:)
                                              keyEquivalent:@""];
        alternateMenuItem.target = self;
        alternateMenuItem.alternate = YES;
        alternateMenuItem.keyEquivalentModifierMask = NSEventModifierFlagOption;
        alternateMenuItem.tag = (NSInteger)duration.seconds;
        
        // Is Default
        if([controller.defaultActivationDuration isEqualToActivationDuration:duration])
        {
            KYA_AUTO attributed = [NSMutableAttributedString new];
            
            KYA_AUTO attributes = @{
                                    NSFontAttributeName: [NSFont systemFontOfSize:NSFont.systemFontSize
                                                                                          weight:NSFontWeightSemibold]
                                    };
            KYA_AUTO attributedTitle = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", menuItem.title]
                                                                       attributes:attributes];
            [attributed appendAttributedString:attributedTitle];
            
            KYA_AUTO defaultAttributes = @{
                                           NSFontAttributeName: [NSFont systemFontOfSize:NSFont.systemFontSize
                                                                                                 weight:NSFontWeightRegular],
                                           NSForegroundColorAttributeName: NSColor.secondaryLabelColor
                                           };
            KYA_AUTO attributedDefault = [[NSAttributedString alloc] initWithString:@"(Default)"
                                                                         attributes:defaultAttributes];
            [attributed appendAttributedString:attributedDefault];
            
            menuItem.attributedTitle = attributed;
        }
        
        // Is Scheduled
        KYA_AUTO delegate = self.delegate;
        if([delegate respondsToSelector:@selector(currentActivationDuration)])
        {
            KYA_AUTO current = [delegate currentActivationDuration];
            if(current != nil && (current.seconds == duration.seconds))
            {
                menuItem.state = NSControlStateValueOn;
                alternateMenuItem.state = NSControlStateValueOn;
            }
        }
    }
}

@end
