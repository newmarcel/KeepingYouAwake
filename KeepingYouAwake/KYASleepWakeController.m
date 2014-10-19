//
//  KYASleepWakeController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 17.10.14.
//  Copyright (c) 2014 Marcel Dierkes. All rights reserved.
//

#import "KYASleepWakeController.h"

@interface KYASleepWakeController () <NSMenuDelegate>
@property (strong, nonatomic) NSMenu *menu;
@property (strong, nonatomic) NSTask *caffeinateTask;
@property (strong, nonatomic) NSStatusItem *statusItem;
@end


@implementation KYASleepWakeController

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [self configureStatusItem];
        
        // Terminate all remaining tasks on Quit
        __weak typeof(self) weakSelf = self;
        [[NSNotificationCenter defaultCenter] addObserverForName:NSApplicationWillTerminateNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
            weakSelf.caffeinateTask.terminationHandler = nil;
            [weakSelf terminateCaffeinateTask];
        }];
    }
    return self;
}

- (void)configureStatusItem
{
    NSStatusItem *statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    NSStatusBarButton *button = statusItem.button;
    
    button.toolTip = NSLocalizedString(@"Caffeinate…", nil);
    button.target = self;
    button.action = @selector(toggleStatus:);
    
    [button sendActionOn:NSLeftMouseUpMask|NSRightMouseUpMask];
    
    [self addMenuToStatusItem:statusItem];
    
    self.statusItem = statusItem;
    [self setStatusItemActive:NO];
}

- (void)addMenuToStatusItem:(NSStatusItem *)statusItem
{
    NSMenu *menu = [[NSMenu alloc] initWithTitle:@"MENU!!!!"];
    
    [menu addItemWithTitle:@"About" action:NULL keyEquivalent:@""];
    [menu addItem:[NSMenuItem separatorItem]];
    [menu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@"q"];
    
    self.menu = menu;
}

- (IBAction)showMenu:(id)sender
{
    [self.statusItem popUpStatusItemMenu:self.menu];
}

- (IBAction)toggleStatus:(id)sender
{
    NSEvent *event = [NSApp currentEvent];
    if(event.type == NSRightMouseUp)
    {
        [self showMenu:nil];
        return;
    }
    
    if(self.caffeinateTask)
    {
        [self terminateCaffeinateTask];
        [self setStatusItemActive:NO];
    }
    else
    {
        [self spawnCaffeinateTask];
        [self setStatusItemActive:YES];
    }
}

- (void)setStatusItemActive:(BOOL)active
{
    NSStatusBarButton *button = self.statusItem.button;
    if(active)
    {
        button.image = [NSImage imageNamed:@"ActiveIcon"];
        button.appearsDisabled = NO;
    }
    else
    {
        button.image = [NSImage imageNamed:@"InactiveIcon"];
        button.appearsDisabled = YES;
    }
}

#pragma mark - Caffeinate Task Handling

- (void)spawnCaffeinateTask
{
    NSArray *args = @[
                      @"-disu",
                      [NSString stringWithFormat:@"-w %i", [[NSProcessInfo processInfo] processIdentifier]],
                      ];
    self.caffeinateTask = [NSTask launchedTaskWithLaunchPath:@"/usr/bin/caffeinate" arguments:args];
    
    // Termination Handler
    __weak typeof(self) weakSelf = self;
    self.caffeinateTask.terminationHandler = ^(NSTask *task) {
        weakSelf.caffeinateTask = nil;
        [weakSelf setStatusItemActive:NO];
    };
}

- (void)terminateCaffeinateTask
{
    [self.caffeinateTask terminate];
}

@end
