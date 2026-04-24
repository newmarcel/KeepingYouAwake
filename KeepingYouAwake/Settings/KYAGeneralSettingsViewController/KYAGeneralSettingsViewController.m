//
//  KYAGeneralSettingsViewController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 18.12.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import "KYAGeneralSettingsViewController.h"
#import "KYADurationSettingsViewController.h"
#import "KYABatterySettingsViewController.h"
#import "KYAAdvancedSettingsViewController.h"
#import <KYACommon/KYACommon.h>

static const CGFloat kKYAGeneralTabWidth = 480.0;
static const CGFloat kKYAGeneralTabHeight = 600.0;

@interface KYAGeneralSettingsViewController ()
@property (nonatomic) NSButton *startAtLoginCheckBoxButton;
@property (nonatomic) NSButton *activateOnLaunchCheckBoxButton;
@property (nonatomic) NSButton *notificationSettingsButton;
@property (nonatomic) KYADurationSettingsViewController *durationChild;
@property (nonatomic) KYABatterySettingsViewController *batteryChild;
@property (nonatomic) KYAAdvancedSettingsViewController *advancedChild;
@end

@implementation KYAGeneralSettingsViewController

+ (NSImage *)tabViewItemImage
{
    if(@available(macOS 11.0, *))
    {
        return [NSImage imageWithSystemSymbolName:@"gearshape"
                         accessibilityDescription:nil];
    }
    else
    {
        return [NSImage imageNamed:NSImageNamePreferencesGeneral];
    }
}

+ (NSString *)preferredTitle
{
    return KYA_SETTINGS_L10N_GENERAL;
}

- (BOOL)resizesView
{
    return NO;
}

#pragma mark - Life Cycle

- (instancetype)init
{
    // Skip XIB loading from the base class; build programmatically in loadView.
    self = [super initWithNibName:nil bundle:nil];
    if(self)
    {
        self.title = [[self class] preferredTitle];
    }
    return self;
}

- (void)loadView
{
    NSView *container = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, kKYAGeneralTabWidth, kKYAGeneralTabHeight)];

    Auto stack = [NSStackView new];
    stack.orientation = NSUserInterfaceLayoutOrientationVertical;
    stack.alignment = NSLayoutAttributeLeading;
    stack.spacing = 14;
    stack.edgeInsets = NSEdgeInsetsMake(16, 20, 16, 20);
    stack.translatesAutoresizingMaskIntoConstraints = NO;

    // --- Startup & Behavior -------------------------------------------
    [stack addArrangedSubview:[self sectionHeader:NSLocalizedString(@"Startup & Behavior", @"")]];

    Auto startAtLogin = [NSButton checkboxWithTitle:NSLocalizedString(@"Start at Login", @"")
                                             target:nil
                                             action:NULL];
    startAtLogin.translatesAutoresizingMaskIntoConstraints = NO;
    self.startAtLoginCheckBoxButton = startAtLogin;
    [stack addArrangedSubview:startAtLogin];
    [stack addArrangedSubview:[self helperLabel:NSLocalizedString(@"Automatically opens the app when you start your Mac.", @"")]];

    Auto activateOnLaunch = [NSButton checkboxWithTitle:NSLocalizedString(@"Activate on Launch", @"")
                                                 target:nil
                                                 action:NULL];
    activateOnLaunch.translatesAutoresizingMaskIntoConstraints = NO;
    [activateOnLaunch bind:@"value"
                  toObject:NSUserDefaultsController.sharedUserDefaultsController
               withKeyPath:@"values.info.marcel-dierkes.KeepingYouAwake.ActivateOnLaunch"
                   options:nil];
    self.activateOnLaunchCheckBoxButton = activateOnLaunch;
    [stack addArrangedSubview:activateOnLaunch];
    [stack addArrangedSubview:[self helperLabel:NSLocalizedString(@"Immediately starts preventing sleep when launched.", @"")]];

    if(@available(macOS 11.0, *))
    {
        Auto notifButton = [NSButton buttonWithTitle:NSLocalizedString(@"Notification Settings…", @"")
                                              target:self
                                              action:@selector(openNotificationSettings:)];
        notifButton.bezelStyle = NSBezelStyleRounded;
        notifButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.notificationSettingsButton = notifButton;
        [stack addArrangedSubview:notifButton];
    }

    [stack addArrangedSubview:[self sectionDivider]];

    // --- Activation Durations -----------------------------------------
    [stack addArrangedSubview:[self sectionHeader:NSLocalizedString(@"Activation Durations", @"")]];

    KYADurationSettingsViewController *duration = [KYADurationSettingsViewController new];
    [self addChildViewController:duration];
    self.durationChild = duration;
    NSView *durationView = [self wrappedChildView:duration.view height:325.0];
    [stack addArrangedSubview:durationView];

    [stack addArrangedSubview:[self sectionDivider]];

    // --- Battery ------------------------------------------------------
    [stack addArrangedSubview:[self sectionHeader:NSLocalizedString(@"Battery", @"")]];

    KYABatterySettingsViewController *battery = [KYABatterySettingsViewController new];
    [self addChildViewController:battery];
    self.batteryChild = battery;
    NSView *batteryView = [self wrappedChildView:battery.view height:268.0];
    [stack addArrangedSubview:batteryView];

    [stack addArrangedSubview:[self sectionDivider]];

    // --- Advanced -----------------------------------------------------
    [stack addArrangedSubview:[self sectionHeader:NSLocalizedString(@"Advanced", @"")]];

    KYAAdvancedSettingsViewController *advanced = [KYAAdvancedSettingsViewController new];
    [self addChildViewController:advanced];
    self.advancedChild = advanced;
    NSView *advancedView = [self wrappedChildView:advanced.view height:317.0];
    [stack addArrangedSubview:advancedView];

    // --- Scroll container ---------------------------------------------
    NSView *documentView = [[NSView alloc] initWithFrame:NSZeroRect];
    documentView.translatesAutoresizingMaskIntoConstraints = NO;
    [documentView addSubview:stack];
    [NSLayoutConstraint activateConstraints:@[
        [stack.topAnchor constraintEqualToAnchor:documentView.topAnchor],
        [stack.leadingAnchor constraintEqualToAnchor:documentView.leadingAnchor],
        [stack.trailingAnchor constraintEqualToAnchor:documentView.trailingAnchor],
        [stack.bottomAnchor constraintEqualToAnchor:documentView.bottomAnchor],
    ]];

    Auto scrollView = [NSScrollView new];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.hasVerticalScroller = YES;
    scrollView.hasHorizontalScroller = NO;
    scrollView.borderType = NSNoBorder;
    scrollView.drawsBackground = NO;
    scrollView.autohidesScrollers = YES;
    scrollView.documentView = documentView;

    [container addSubview:scrollView];
    [NSLayoutConstraint activateConstraints:@[
        [container.widthAnchor constraintEqualToConstant:kKYAGeneralTabWidth],

        [scrollView.topAnchor constraintEqualToAnchor:container.topAnchor],
        [scrollView.leadingAnchor constraintEqualToAnchor:container.leadingAnchor],
        [scrollView.trailingAnchor constraintEqualToAnchor:container.trailingAnchor],
        [scrollView.bottomAnchor constraintEqualToAnchor:container.bottomAnchor],

        [documentView.widthAnchor constraintEqualToAnchor:scrollView.widthAnchor],
    ]];

    self.view = container;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.startAtLoginCheckBoxButton bind:@"value"
                                 toObject:NSApplication.sharedApplication
                              withKeyPath:@"kya_launchAtLoginEnabled"
                                  options:@{
                                      NSRaisesForNotApplicableKeysBindingOption: @YES,
                                      NSConditionallySetsEnabledBindingOption: @YES
                                  }
     ];
}

- (void)dealloc
{
    [self.startAtLoginCheckBoxButton unbind:@"value"];
    [self.activateOnLaunchCheckBoxButton unbind:@"value"];
}

#pragma mark - Helpers

- (NSTextField *)sectionHeader:(NSString *)title
{
    NSTextField *label = [NSTextField labelWithString:title];
    label.font = [NSFont boldSystemFontOfSize:NSFont.systemFontSize];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    return label;
}

- (NSTextField *)helperLabel:(NSString *)text
{
    NSTextField *label = [NSTextField labelWithString:text];
    label.font = [NSFont systemFontOfSize:NSFont.smallSystemFontSize];
    label.textColor = NSColor.secondaryLabelColor;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.maximumNumberOfLines = 2;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    return label;
}

- (NSBox *)sectionDivider
{
    NSBox *divider = [NSBox new];
    divider.boxType = NSBoxSeparator;
    divider.translatesAutoresizingMaskIntoConstraints = NO;
    return divider;
}

- (NSView *)wrappedChildView:(NSView *)childView height:(CGFloat)height
{
    // Child XIB views come with an intrinsic frame; wrap them so the
    // surrounding stack view can give them a consistent width/height without
    // fighting the XIB's own constraints.
    childView.translatesAutoresizingMaskIntoConstraints = NO;

    NSView *wrapper = [[NSView alloc] initWithFrame:NSZeroRect];
    wrapper.translatesAutoresizingMaskIntoConstraints = NO;
    [wrapper addSubview:childView];

    [NSLayoutConstraint activateConstraints:@[
        [childView.topAnchor constraintEqualToAnchor:wrapper.topAnchor],
        [childView.leadingAnchor constraintEqualToAnchor:wrapper.leadingAnchor],
        [childView.trailingAnchor constraintEqualToAnchor:wrapper.trailingAnchor],
        [childView.bottomAnchor constraintEqualToAnchor:wrapper.bottomAnchor],
        [wrapper.heightAnchor constraintEqualToConstant:height],
    ]];
    return wrapper;
}

#pragma mark - Actions

- (void)openNotificationSettings:(id)sender
{
    Auto workspace = NSWorkspace.sharedWorkspace;
    [workspace kya_openNotificationSettingsWithCompletionHandler:nil];
}

@end
