//
//  KYAIconSettingsViewController.m
//  KYAStatusItemUI
//

#import <KYAStatusItemUI/KYAIconSettingsViewController.h>
#import <KYAStatusItemUI/KYAMenuBarIconStyle.h>
#import <KYAStatusItemUI/KYAStatusItemImageProvider.h>
#import <KYAApplicationSupport/NSUserDefaults+KYAKeys.h>
#import <KYACommon/KYACommon.h>

typedef NS_ENUM(NSInteger, KYAIconSlot) {
    KYAIconSlotActive = 0,
    KYAIconSlotInactive = 1,
};

static const CGFloat kKYAAppearanceTabWidth = 480.0;

#pragma mark - Controller

@interface KYAIconSettingsViewController ()
@property (nonatomic) NSPopUpButton *activeIconPopUp;
@property (nonatomic) NSPopUpButton *inactiveIconPopUp;
@property (nonatomic) NSColorWell *activeColorWell;
@property (nonatomic) NSColorWell *inactiveColorWell;
@property (nonatomic) NSButton *activeColorResetButton;
@property (nonatomic) NSButton *inactiveColorResetButton;

@property (nonatomic) NSButton *showRemainingTimeCheckbox;
@property (nonatomic) NSPopUpButton *formatPopUp;
@end

@implementation KYAIconSettingsViewController

+ (NSTabViewItem *)preferredTabViewItem
{
    KYAIconSettingsViewController *controller = [self new];
    controller.title = NSLocalizedString(@"Appearance", @"Appearance settings tab title");

    Auto item = [NSTabViewItem tabViewItemWithViewController:controller];
    if(@available(macOS 11.0, *))
    {
        item.image = [NSImage imageWithSystemSymbolName:@"menubar.dock.rectangle"
                               accessibilityDescription:nil];
    }
    else
    {
        item.image = [NSImage imageNamed:NSImageNameColorPanel];
    }
    return item;
}

- (BOOL)resizesView
{
    return YES;
}

- (void)loadView
{
    NSView *container = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, kKYAAppearanceTabWidth, 360)];

    // --- Icon / color rows --------------------------------------------
    Auto iconHeader = [self sectionHeader:NSLocalizedString(@"Menu Bar Icon", @"")];

    Auto inactiveLabel = [NSTextField labelWithString:NSLocalizedString(@"Inactive", @"")];
    inactiveLabel.translatesAutoresizingMaskIntoConstraints = NO;

    Auto inactivePopUp = [self newIconPopUpForSlot:KYAIconSlotInactive];
    self.inactiveIconPopUp = inactivePopUp;

    Auto inactiveColorWell = [self newColorWell];
    inactiveColorWell.action = @selector(inactiveColorChanged:);
    inactiveColorWell.target = self;
    self.inactiveColorWell = inactiveColorWell;

    Auto inactiveReset = [self newResetButtonWithAction:@selector(resetInactiveColor:)];
    self.inactiveColorResetButton = inactiveReset;

    Auto inactiveRow = [NSStackView stackViewWithViews:@[inactiveLabel, inactivePopUp, inactiveColorWell, inactiveReset]];
    inactiveRow.orientation = NSUserInterfaceLayoutOrientationHorizontal;
    inactiveRow.spacing = 10;
    inactiveRow.alignment = NSLayoutAttributeCenterY;
    inactiveRow.translatesAutoresizingMaskIntoConstraints = NO;

    Auto activeLabel = [NSTextField labelWithString:NSLocalizedString(@"Active", @"")];
    activeLabel.translatesAutoresizingMaskIntoConstraints = NO;

    Auto activePopUp = [self newIconPopUpForSlot:KYAIconSlotActive];
    self.activeIconPopUp = activePopUp;

    Auto activeColorWell = [self newColorWell];
    activeColorWell.action = @selector(activeColorChanged:);
    activeColorWell.target = self;
    self.activeColorWell = activeColorWell;

    Auto activeReset = [self newResetButtonWithAction:@selector(resetActiveColor:)];
    self.activeColorResetButton = activeReset;

    Auto activeRow = [NSStackView stackViewWithViews:@[activeLabel, activePopUp, activeColorWell, activeReset]];
    activeRow.orientation = NSUserInterfaceLayoutOrientationHorizontal;
    activeRow.spacing = 10;
    activeRow.alignment = NSLayoutAttributeCenterY;
    activeRow.translatesAutoresizingMaskIntoConstraints = NO;

    // Keep the two labels the same width so popups line up vertically.
    CGFloat labelWidth = 70.0;

    // --- Remaining time section ---------------------------------------
    Auto divider = [NSBox new];
    divider.boxType = NSBoxSeparator;
    divider.translatesAutoresizingMaskIntoConstraints = NO;

    Auto timeHeader = [self sectionHeader:NSLocalizedString(@"Remaining Time", @"")];

    Auto showRemaining = [NSButton checkboxWithTitle:NSLocalizedString(@"Show remaining time next to menu bar icon", @"")
                                              target:self
                                              action:@selector(showRemainingTimeChanged:)];
    showRemaining.translatesAutoresizingMaskIntoConstraints = NO;
    self.showRemainingTimeCheckbox = showRemaining;

    Auto showRemainingHelp = [NSTextField labelWithString:NSLocalizedString(@"Shows time remaining for timed sessions, or elapsed time for indefinite sessions.", @"")];
    showRemainingHelp.font = [NSFont systemFontOfSize:NSFont.smallSystemFontSize];
    showRemainingHelp.textColor = NSColor.secondaryLabelColor;
    showRemainingHelp.translatesAutoresizingMaskIntoConstraints = NO;
    showRemainingHelp.lineBreakMode = NSLineBreakByWordWrapping;
    showRemainingHelp.maximumNumberOfLines = 2;

    Auto formatLabel = [NSTextField labelWithString:NSLocalizedString(@"Date Format:", @"")];
    formatLabel.translatesAutoresizingMaskIntoConstraints = NO;

    Auto formatPopUp = [NSPopUpButton new];
    formatPopUp.translatesAutoresizingMaskIntoConstraints = NO;
    formatPopUp.bezelStyle = NSBezelStyleRounded;
    [self populateFormatPopUp:formatPopUp];
    formatPopUp.target = self;
    formatPopUp.action = @selector(formatChanged:);
    self.formatPopUp = formatPopUp;

    Auto formatRow = [NSStackView stackViewWithViews:@[formatLabel, formatPopUp]];
    formatRow.orientation = NSUserInterfaceLayoutOrientationHorizontal;
    formatRow.spacing = 8;
    formatRow.alignment = NSLayoutAttributeCenterY;
    formatRow.translatesAutoresizingMaskIntoConstraints = NO;

    // --- Root stack ---------------------------------------------------
    Auto stack = [NSStackView new];
    stack.orientation = NSUserInterfaceLayoutOrientationVertical;
    stack.alignment = NSLayoutAttributeLeading;
    stack.spacing = 12;
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    [stack addArrangedSubview:iconHeader];
    [stack addArrangedSubview:inactiveRow];
    [stack addArrangedSubview:activeRow];
    [stack addArrangedSubview:divider];
    [stack addArrangedSubview:timeHeader];
    [stack addArrangedSubview:showRemaining];
    [stack addArrangedSubview:showRemainingHelp];
    [stack addArrangedSubview:formatRow];

    [container addSubview:stack];
    [NSLayoutConstraint activateConstraints:@[
        [container.widthAnchor constraintEqualToConstant:kKYAAppearanceTabWidth],

        [stack.topAnchor constraintEqualToAnchor:container.topAnchor constant:20],
        [stack.leadingAnchor constraintEqualToAnchor:container.leadingAnchor constant:20],
        [stack.trailingAnchor constraintEqualToAnchor:container.trailingAnchor constant:-20],
        [stack.bottomAnchor constraintLessThanOrEqualToAnchor:container.bottomAnchor constant:-20],

        [divider.leadingAnchor constraintEqualToAnchor:stack.leadingAnchor],
        [divider.trailingAnchor constraintEqualToAnchor:stack.trailingAnchor],

        [showRemainingHelp.leadingAnchor constraintEqualToAnchor:stack.leadingAnchor],
        [showRemainingHelp.trailingAnchor constraintEqualToAnchor:stack.trailingAnchor],

        [inactiveLabel.widthAnchor constraintEqualToConstant:labelWidth],
        [activeLabel.widthAnchor constraintEqualToConstant:labelWidth],

        [inactivePopUp.widthAnchor constraintGreaterThanOrEqualToConstant:200],
        [activePopUp.widthAnchor constraintGreaterThanOrEqualToConstant:200],

        [inactiveColorWell.widthAnchor constraintEqualToConstant:44],
        [inactiveColorWell.heightAnchor constraintEqualToConstant:24],
        [activeColorWell.widthAnchor constraintEqualToConstant:44],
        [activeColorWell.heightAnchor constraintEqualToConstant:24],
    ]];

    self.view = container;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    Auto defaults = NSUserDefaults.standardUserDefaults;
    self.showRemainingTimeCheckbox.state = defaults.kya_isShowRemainingTimeInMenuBarEnabled
        ? NSControlStateValueOn
        : NSControlStateValueOff;
    [self selectFormat:defaults.kya_remainingTimeFormat];
    [self refreshIconSelection];
    [self refreshColorWells];
}

- (void)viewWillAppear
{
    [super viewWillAppear];
    self.preferredContentSize = NSMakeSize(kKYAAppearanceTabWidth, 360.0);
}

#pragma mark - Factories

- (NSTextField *)sectionHeader:(NSString *)title
{
    NSTextField *label = [NSTextField labelWithString:title];
    label.font = [NSFont boldSystemFontOfSize:NSFont.systemFontSize];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    return label;
}

- (NSPopUpButton *)newIconPopUpForSlot:(KYAIconSlot)slot
{
    NSPopUpButton *popUp = [NSPopUpButton new];
    popUp.translatesAutoresizingMaskIntoConstraints = NO;
    popUp.bezelStyle = NSBezelStyleRounded;
    popUp.pullsDown = NO;
    popUp.target = self;
    popUp.action = (slot == KYAIconSlotActive) ? @selector(activeIconChanged:) : @selector(inactiveIconChanged:);
    popUp.tag = slot;

    [self populateIconMenu:popUp.menu];
    return popUp;
}

- (void)populateIconMenu:(NSMenu *)menu
{
    Auto styles = [KYAMenuBarIconStyle allStyles];
    KYAMenuBarIconCategory lastCategory = nil;

    for(KYAMenuBarIconStyle *style in styles)
    {
        if(lastCategory != nil && ![style.category isEqualToString:lastCategory])
        {
            [menu addItem:[NSMenuItem separatorItem]];
        }
        lastCategory = style.category;

        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:style.displayName action:nil keyEquivalent:@""];
        item.representedObject = style.identifier;
        item.image = [self menuIconImageForStyle:style];
        [menu addItem:item];
    }
}

- (nullable NSImage *)menuIconImageForStyle:(KYAMenuBarIconStyle *)style
{
    NSImage *image = nil;
    if(style.symbolName != nil)
    {
        if(@available(macOS 11.0, *))
        {
            image = [NSImage imageWithSystemSymbolName:style.symbolName
                              accessibilityDescription:style.displayName];
        }
    }
    if(image == nil)
    {
        image = [NSImage imageNamed:@"ActiveIcon"];
    }
    image.size = NSMakeSize(16, 16);
    return image;
}

- (NSColorWell *)newColorWell
{
    NSColorWell *well = [NSColorWell new];
    well.translatesAutoresizingMaskIntoConstraints = NO;
    well.color = NSColor.labelColor;
    return well;
}

- (NSButton *)newResetButtonWithAction:(SEL)action
{
    NSButton *button = [NSButton buttonWithTitle:NSLocalizedString(@"Auto", @"Reset icon color to default")
                                          target:self
                                          action:action];
    button.bezelStyle = NSBezelStyleRounded;
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.toolTip = NSLocalizedString(@"Reset to the system default (auto-adapts to light / dark mode).", @"");
    return button;
}

- (void)populateFormatPopUp:(NSPopUpButton *)popUp
{
    [self addFormatItem:popUp
                  title:NSLocalizedString(@"Compact (2h 30m)", @"")
                  value:KYARemainingTimeFormatCompact];
    [self addFormatItem:popUp
                  title:NSLocalizedString(@"Digital HH:MM:SS (2:30:00)", @"")
                  value:KYARemainingTimeFormatDigital];
    [self addFormatItem:popUp
                  title:NSLocalizedString(@"Digital HH:MM (2:30)", @"")
                  value:KYARemainingTimeFormatHoursMinutes];
    [self addFormatItem:popUp
                  title:NSLocalizedString(@"Minutes (150m)", @"")
                  value:KYARemainingTimeFormatMinutes];
    [self addFormatItem:popUp
                  title:NSLocalizedString(@"Hours (3h)", @"")
                  value:KYARemainingTimeFormatHours];
    [self addFormatItem:popUp
                  title:NSLocalizedString(@"Seconds (9000s)", @"")
                  value:KYARemainingTimeFormatSeconds];
    [self addFormatItem:popUp
                  title:NSLocalizedString(@"Verbose (2 hours 30 minutes)", @"")
                  value:KYARemainingTimeFormatVerbose];
}

- (void)addFormatItem:(NSPopUpButton *)popUp title:(NSString *)title value:(KYARemainingTimeFormat)value
{
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:title action:nil keyEquivalent:@""];
    item.representedObject = value;
    [popUp.menu addItem:item];
}

#pragma mark - Selection sync

- (void)selectFormat:(KYARemainingTimeFormat)format
{
    for(NSMenuItem *item in self.formatPopUp.menu.itemArray)
    {
        if([item.representedObject isEqualToString:format])
        {
            [self.formatPopUp selectItem:item];
            return;
        }
    }
    [self.formatPopUp selectItemAtIndex:0];
}

- (void)refreshIconSelection
{
    Auto defaults = NSUserDefaults.standardUserDefaults;
    [self selectStyleID:defaults.kya_menuBarActiveIconStyle inPopUp:self.activeIconPopUp];
    [self selectStyleID:defaults.kya_menuBarInactiveIconStyle inPopUp:self.inactiveIconPopUp];
}

- (void)selectStyleID:(nullable KYAMenuBarIconStyleID)styleID inPopUp:(NSPopUpButton *)popUp
{
    NSString *target = styleID.length > 0 ? styleID : KYAMenuBarIconStyleIDDefault;
    for(NSMenuItem *item in popUp.menu.itemArray)
    {
        if([item.representedObject isEqualToString:target])
        {
            [popUp selectItem:item];
            return;
        }
    }
    [popUp selectItemAtIndex:0];
}

- (void)refreshColorWells
{
    Auto defaults = NSUserDefaults.standardUserDefaults;
    self.activeColorWell.color = [self colorForHexString:defaults.kya_menuBarActiveIconColor];
    self.inactiveColorWell.color = [self colorForHexString:defaults.kya_menuBarInactiveIconColor];
    self.activeColorResetButton.enabled = (defaults.kya_menuBarActiveIconColor.length > 0);
    self.inactiveColorResetButton.enabled = (defaults.kya_menuBarInactiveIconColor.length > 0);
}

- (NSColor *)colorForHexString:(nullable NSString *)hex
{
    NSColor *parsed = [[self class] colorFromHexString:hex];
    return parsed ?: NSColor.labelColor;
}

#pragma mark - Actions

- (void)activeIconChanged:(NSPopUpButton *)sender
{
    NSString *identifier = sender.selectedItem.representedObject;
    if(identifier.length == 0) { return; }
    NSUserDefaults.standardUserDefaults.kya_menuBarActiveIconStyle = identifier;
    [KYAStatusItemImageProvider.currentProvider reloadFromDefaults];
}

- (void)inactiveIconChanged:(NSPopUpButton *)sender
{
    NSString *identifier = sender.selectedItem.representedObject;
    if(identifier.length == 0) { return; }
    NSUserDefaults.standardUserDefaults.kya_menuBarInactiveIconStyle = identifier;
    [KYAStatusItemImageProvider.currentProvider reloadFromDefaults];
}

- (void)activeColorChanged:(NSColorWell *)sender
{
    NSUserDefaults.standardUserDefaults.kya_menuBarActiveIconColor = [[self class] hexStringFromColor:sender.color];
    self.activeColorResetButton.enabled = YES;
}

- (void)inactiveColorChanged:(NSColorWell *)sender
{
    NSUserDefaults.standardUserDefaults.kya_menuBarInactiveIconColor = [[self class] hexStringFromColor:sender.color];
    self.inactiveColorResetButton.enabled = YES;
}

- (void)resetActiveColor:(id)sender
{
    NSUserDefaults.standardUserDefaults.kya_menuBarActiveIconColor = nil;
    self.activeColorWell.color = NSColor.labelColor;
    self.activeColorResetButton.enabled = NO;
}

- (void)resetInactiveColor:(id)sender
{
    NSUserDefaults.standardUserDefaults.kya_menuBarInactiveIconColor = nil;
    self.inactiveColorWell.color = NSColor.labelColor;
    self.inactiveColorResetButton.enabled = NO;
}

- (void)showRemainingTimeChanged:(NSButton *)sender
{
    NSUserDefaults.standardUserDefaults.kya_showRemainingTimeInMenuBar =
        (sender.state == NSControlStateValueOn);
}

- (void)formatChanged:(NSPopUpButton *)sender
{
    KYARemainingTimeFormat value = sender.selectedItem.representedObject;
    if(value.length > 0)
    {
        NSUserDefaults.standardUserDefaults.kya_remainingTimeFormat = value;
    }
}

#pragma mark - Hex helpers

+ (nullable NSColor *)colorFromHexString:(nullable NSString *)hex
{
    if(hex.length == 0) { return nil; }

    NSString *trimmed = hex;
    if([trimmed hasPrefix:@"#"])
    {
        trimmed = [trimmed substringFromIndex:1];
    }
    if(trimmed.length != 6 && trimmed.length != 8) { return nil; }

    unsigned int value = 0;
    NSScanner *scanner = [NSScanner scannerWithString:trimmed];
    if(![scanner scanHexInt:&value]) { return nil; }

    CGFloat r, g, b, a = 1.0;
    if(trimmed.length == 6)
    {
        r = ((value >> 16) & 0xFF) / 255.0;
        g = ((value >> 8) & 0xFF) / 255.0;
        b = (value & 0xFF) / 255.0;
    }
    else
    {
        r = ((value >> 24) & 0xFF) / 255.0;
        g = ((value >> 16) & 0xFF) / 255.0;
        b = ((value >> 8) & 0xFF) / 255.0;
        a = (value & 0xFF) / 255.0;
    }
    return [NSColor colorWithSRGBRed:r green:g blue:b alpha:a];
}

+ (NSString *)hexStringFromColor:(NSColor *)color
{
    NSColor *srgb = [color colorUsingColorSpace:NSColorSpace.sRGBColorSpace];
    if(srgb == nil) { srgb = color; }

    CGFloat r = 0, g = 0, b = 0, a = 0;
    [srgb getRed:&r green:&g blue:&b alpha:&a];

    unsigned int ri = (unsigned int)round(MAX(0, MIN(1, r)) * 255);
    unsigned int gi = (unsigned int)round(MAX(0, MIN(1, g)) * 255);
    unsigned int bi = (unsigned int)round(MAX(0, MIN(1, b)) * 255);

    return [NSString stringWithFormat:@"#%02X%02X%02X", ri, gi, bi];
}

@end
