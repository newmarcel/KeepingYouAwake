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
#import "KYAActivationDurationsController.h"

@interface KYAActivationDurationsMenuController ()
@property (nonatomic, readwrite) NSMenu *menu;
@end

@implementation KYAActivationDurationsMenuController

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.menu = [[NSMenu alloc] initWithTitle:@"Activate for Duration"];
        self.menu.delegate = self;
    }
    return self;
}

- (void)selectActivationDuration:(nullable NSMenuItem *)sender
{
    KYALog(@"Selected %@", sender);
}

- (void)setDefaultActivationDuration:(nullable NSMenuItem *)sender
{
    KYALog(@"Set Default %@", sender);
}

#pragma mark - NSMenuDelegate

- (void)menuNeedsUpdate:(NSMenu *)menu
{
    [menu removeAllItems];
    
    KYA_AUTO controller = KYAActivationDurationsController.sharedController;
    
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
            menuItem.state = NSControlStateValueOn;
            alternateMenuItem.state = NSControlStateValueOn;
        }
    }
}

@end
