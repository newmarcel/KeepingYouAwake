//
//  KYASettingsContentViewController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 20.09.21.
//  Copyright © 2021 Marcel Dierkes. All rights reserved.
//

#import "KYASettingsContentViewController.h"
#import <KYACommon/KYACommon.h>

@interface KYASettingsContentViewController ()
@end

@implementation KYASettingsContentViewController

+ (NSTabViewItem *)preferredTabViewItem
{
    NSViewController *controller = [[self alloc] init];
    
    Auto item = [NSTabViewItem tabViewItemWithViewController:controller];
    item.image = self.tabViewItemImage;
    return item;
}

+ (NSImage *)tabViewItemImage
{
    return nil;
}

+ (NSString *)preferredTitle
{
    return nil;
}

- (BOOL)resizesView
{
    return YES;
}

#pragma mark - Life Cycle

- (instancetype)init
{
    Auto nibName = NSStringFromClass([self class]);
    self = [super initWithNibName:nibName bundle:nil];
    if(self)
    {
        self.title = [[self class] preferredTitle];
    }
    return self;
}

- (void)viewWillAppear
{
    [super viewWillAppear];

    // Use a unified size across every tab so the preferences window stays
    // a constant size rather than jumping around as the user switches tabs.
    // Sized for the largest tab (Menu Bar) with headroom.
    self.preferredContentSize = NSMakeSize(480.0, 600.0);
}

@end
