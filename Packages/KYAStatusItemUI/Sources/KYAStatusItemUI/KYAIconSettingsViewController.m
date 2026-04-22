//
//  KYAIconSettingsViewController.m
//  KYAStatusItemUI
//

#import <KYAStatusItemUI/KYAIconSettingsViewController.h>
#import <KYAStatusItemUI/KYAMenuBarIconStyle.h>
#import <KYAStatusItemUI/KYAStatusItemImageProvider.h>
#import <KYAApplicationSupport/NSUserDefaults+KYAKeys.h>
#import <KYACommon/KYACommon.h>

@interface KYAIconSettingsViewController ()
@property (nonatomic) NSPopUpButton *activePopUp;
@property (nonatomic) NSPopUpButton *inactivePopUp;
@end

@implementation KYAIconSettingsViewController

+ (NSTabViewItem *)preferredTabViewItem
{
    KYAIconSettingsViewController *controller = [self new];
    controller.title = NSLocalizedString(@"Icon", @"Icon settings tab title");

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

- (void)loadView
{
    NSView *container = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 440, 240)];

    Auto activeLabel = [self makeHeaderLabel:NSLocalizedString(@"Active Icon", @"")];
    Auto activeHelp = [self makeHelpLabel:NSLocalizedString(@"Shown in the menu bar while sleep is prevented.", @"")];
    Auto activePopUp = [self makeIconPopUpForStyles:[KYAMenuBarIconStyle activeStyles]];
    activePopUp.target = self;
    activePopUp.action = @selector(activeStyleChanged:);
    self.activePopUp = activePopUp;

    Auto inactiveLabel = [self makeHeaderLabel:NSLocalizedString(@"Inactive Icon", @"")];
    Auto inactiveHelp = [self makeHelpLabel:NSLocalizedString(@"Shown when sleep is allowed.", @"")];
    Auto inactivePopUp = [self makeIconPopUpForStyles:[KYAMenuBarIconStyle inactiveStyles]];
    inactivePopUp.target = self;
    inactivePopUp.action = @selector(inactiveStyleChanged:);
    self.inactivePopUp = inactivePopUp;

    Auto stack = [NSStackView new];
    stack.orientation = NSUserInterfaceLayoutOrientationVertical;
    stack.alignment = NSLayoutAttributeLeading;
    stack.spacing = 8;
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    [stack addArrangedSubview:activeLabel];
    [stack addArrangedSubview:activePopUp];
    [stack addArrangedSubview:activeHelp];
    [stack setCustomSpacing:24 afterView:activeHelp];
    [stack addArrangedSubview:inactiveLabel];
    [stack addArrangedSubview:inactivePopUp];
    [stack addArrangedSubview:inactiveHelp];

    [container addSubview:stack];
    [NSLayoutConstraint activateConstraints:@[
        [stack.topAnchor constraintEqualToAnchor:container.topAnchor constant:24],
        [stack.leadingAnchor constraintEqualToAnchor:container.leadingAnchor constant:24],
        [stack.trailingAnchor constraintLessThanOrEqualToAnchor:container.trailingAnchor constant:-24],
        [stack.bottomAnchor constraintLessThanOrEqualToAnchor:container.bottomAnchor constant:-24],
        [activePopUp.widthAnchor constraintGreaterThanOrEqualToConstant:240],
        [inactivePopUp.widthAnchor constraintGreaterThanOrEqualToConstant:240],
    ]];

    self.view = container;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    Auto defaults = NSUserDefaults.standardUserDefaults;
    [self selectInPopUp:self.activePopUp styleID:defaults.kya_menuBarActiveIconStyle];
    [self selectInPopUp:self.inactivePopUp styleID:defaults.kya_menuBarInactiveIconStyle];
}

- (void)viewWillAppear
{
    [super viewWillAppear];
    self.preferredContentSize = self.view.fittingSize;
}

#pragma mark - UI builders

- (NSTextField *)makeHeaderLabel:(NSString *)text
{
    NSTextField *label = [NSTextField labelWithString:text];
    label.font = [NSFont boldSystemFontOfSize:NSFont.systemFontSize];
    return label;
}

- (NSTextField *)makeHelpLabel:(NSString *)text
{
    NSTextField *label = [NSTextField labelWithString:text];
    label.font = [NSFont systemFontOfSize:NSFont.smallSystemFontSize];
    label.textColor = NSColor.secondaryLabelColor;
    return label;
}

- (NSPopUpButton *)makeIconPopUpForStyles:(NSArray<KYAMenuBarIconStyle *> *)styles
{
    NSPopUpButton *popUp = [NSPopUpButton new];
    popUp.translatesAutoresizingMaskIntoConstraints = NO;
    popUp.bezelStyle = NSBezelStyleRounded;

    NSMenu *menu = [NSMenu new];
    for(KYAMenuBarIconStyle *style in styles)
    {
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:style.displayName
                                                      action:nil
                                               keyEquivalent:@""];
        item.representedObject = style.identifier;
        item.image = [self previewImageForStyle:style];
        [menu addItem:item];
    }
    popUp.menu = menu;
    return popUp;
}

- (nullable NSImage *)previewImageForStyle:(KYAMenuBarIconStyle *)style
{
    if(style.symbolName == nil) { return nil; }
    NSImage *image = nil;
    if(@available(macOS 11.0, *))
    {
        image = [NSImage imageWithSystemSymbolName:style.symbolName
                          accessibilityDescription:style.displayName];
    }
    image.size = NSMakeSize(16, 16);
    return image;
}

- (void)selectInPopUp:(NSPopUpButton *)popUp styleID:(NSString *)styleID
{
    for(NSMenuItem *item in popUp.menu.itemArray)
    {
        NSString *itemID = item.representedObject;
        BOOL match = (styleID.length == 0)
            ? [itemID isEqualToString:KYAMenuBarIconStyleIDDefault]
            : [itemID isEqualToString:styleID];
        if(match)
        {
            [popUp selectItem:item];
            return;
        }
    }
    [popUp selectItemAtIndex:0];
}

#pragma mark - Actions

- (void)activeStyleChanged:(NSPopUpButton *)sender
{
    NSString *identifier = sender.selectedItem.representedObject;
    NSUserDefaults.standardUserDefaults.kya_menuBarActiveIconStyle = identifier;
    [KYAStatusItemImageProvider.currentProvider reloadFromDefaults];
}

- (void)inactiveStyleChanged:(NSPopUpButton *)sender
{
    NSString *identifier = sender.selectedItem.representedObject;
    NSUserDefaults.standardUserDefaults.kya_menuBarInactiveIconStyle = identifier;
    [KYAStatusItemImageProvider.currentProvider reloadFromDefaults];
}

@end
