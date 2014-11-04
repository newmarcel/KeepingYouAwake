//
//  KYASleepWakeController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 17.10.14.
//  Copyright (c) 2014 Marcel Dierkes. All rights reserved.
//

#import "KYASleepWakeController.h"
#import "NSApplication+LoginItem.h"

@interface KYASleepWakeController () <NSMenuDelegate>
@property (strong, nonatomic) NSTask *caffeinateTask;

// Status Item
@property (strong, nonatomic) NSStatusItem *statusItem;

// Menu
@property (weak, nonatomic) IBOutlet NSMenu *menu;
@property (weak, nonatomic) IBOutlet NSMenuItem *startAtLoginMenuItem;
@end

NSString * const KYASleepWakeControllerUserDefaultsKeyActivateOnLaunch = @"info.marcel-dierkes.KeepingYouAwake.ActivateOnLaunch";

@implementation KYASleepWakeController

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [self configureStatusItem];
        
        // Check activate on launch state
        if([self shouldActivateOnLaunch])
        {
            [self spawnCaffeinateTask];
            [self setStatusItemActive:YES];
        }
        
        // Terminate all remaining tasks on Quit
        __weak typeof(self) weakSelf = self;
        [[NSNotificationCenter defaultCenter] addObserverForName:NSApplicationWillTerminateNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
            weakSelf.caffeinateTask.terminationHandler = nil;
            [weakSelf terminateCaffeinateTask];
        }];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Check start at login state
    if([[NSApplication sharedApplication] kya_isStartingAtLogin])
        self.startAtLoginMenuItem.state = NSOnState;
    else
        self.startAtLoginMenuItem.state = NSOffState;
}

- (void)configureStatusItem
{
    NSStatusItem *statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    NSStatusBarButton *button = statusItem.button;
    
    button.target = self;
    button.action = @selector(toggleStatus:);
    
    [button sendActionOn:NSLeftMouseUpMask|NSRightMouseUpMask];
    
    self.statusItem = statusItem;
    [self setStatusItemActive:NO];
}

#pragma mark - Menu Handling

- (void)showMenu:(id)sender
{
    [self.statusItem popUpStatusItemMenu:self.menu];
}

#pragma mark - Activate on Launch

- (BOOL)shouldActivateOnLaunch
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:KYASleepWakeControllerUserDefaultsKeyActivateOnLaunch];
}

- (IBAction)toggleActivateOnLaunch:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = KYASleepWakeControllerUserDefaultsKeyActivateOnLaunch;
    
    BOOL activateOnLaunch = [defaults boolForKey:key];
    activateOnLaunch = !activateOnLaunch;
    [defaults setBool:activateOnLaunch forKey:key];
    [defaults synchronize];
}

#pragma mark - Start at Login

- (IBAction)toggleStartAtLogin:(id)sender
{
    BOOL shouldStartAtLogin = ![[NSApplication sharedApplication] kya_isStartingAtLogin];
    [NSApplication sharedApplication].kya_startAtLogin = shouldStartAtLogin;
    
    if(shouldStartAtLogin)
        self.startAtLoginMenuItem.state = NSOnState;
    else
        self.startAtLoginMenuItem.state = NSOffState;
}

#pragma mark - Toggle Handling

- (void)toggleStatus:(id)sender
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
        button.toolTip = NSLocalizedString(@"Click to allow sleep\nRight click to show menu", nil);
    }
    else
    {
        button.image = [NSImage imageNamed:@"InactiveIcon"];
        button.appearsDisabled = YES;
        button.toolTip = NSLocalizedString(@"Click to prevent sleep\nRight click to show menu", nil);
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
