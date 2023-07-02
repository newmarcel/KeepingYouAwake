//
//  KYASettingsContentViewController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 20.09.21.
//  Copyright © 2021 Marcel Dierkes. All rights reserved.
//

#import "KYASettingsContentViewController.h"
#import "KYADefines.h"

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
    
    if([self resizesView])
    {
        self.preferredContentSize = self.view.fittingSize;
    }
}

@end
