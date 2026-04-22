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

#pragma mark - Grid Item

@interface KYAIconGridItem : NSCollectionViewItem
@property (nonatomic, nullable) KYAMenuBarIconStyle *style;
@end

@implementation KYAIconGridItem {
    NSImageView *_iconView;
    NSTextField *_labelView;
    NSView *_selectionBackdrop;
}

- (void)loadView
{
    NSView *view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 64, 72)];
    view.wantsLayer = YES;

    _selectionBackdrop = [[NSView alloc] initWithFrame:view.bounds];
    _selectionBackdrop.wantsLayer = YES;
    _selectionBackdrop.layer.cornerRadius = 8.0;
    _selectionBackdrop.layer.backgroundColor = NSColor.clearColor.CGColor;
    _selectionBackdrop.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:_selectionBackdrop];

    _iconView = [[NSImageView alloc] initWithFrame:NSZeroRect];
    _iconView.imageScaling = NSImageScaleProportionallyUpOrDown;
    _iconView.translatesAutoresizingMaskIntoConstraints = NO;
    if(@available(macOS 11.0, *))
    {
        _iconView.contentTintColor = NSColor.labelColor;
    }
    [view addSubview:_iconView];

    _labelView = [NSTextField labelWithString:@""];
    _labelView.alignment = NSTextAlignmentCenter;
    _labelView.font = [NSFont systemFontOfSize:9.0];
    _labelView.textColor = NSColor.secondaryLabelColor;
    _labelView.lineBreakMode = NSLineBreakByTruncatingTail;
    _labelView.maximumNumberOfLines = 1;
    _labelView.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:_labelView];

    [NSLayoutConstraint activateConstraints:@[
        [_selectionBackdrop.topAnchor constraintEqualToAnchor:view.topAnchor],
        [_selectionBackdrop.leadingAnchor constraintEqualToAnchor:view.leadingAnchor],
        [_selectionBackdrop.trailingAnchor constraintEqualToAnchor:view.trailingAnchor],
        [_selectionBackdrop.bottomAnchor constraintEqualToAnchor:_labelView.topAnchor constant:-2],

        [_iconView.centerXAnchor constraintEqualToAnchor:_selectionBackdrop.centerXAnchor],
        [_iconView.centerYAnchor constraintEqualToAnchor:_selectionBackdrop.centerYAnchor],
        [_iconView.widthAnchor constraintEqualToConstant:26],
        [_iconView.heightAnchor constraintEqualToConstant:26],

        [_labelView.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:2],
        [_labelView.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-2],
        [_labelView.bottomAnchor constraintEqualToAnchor:view.bottomAnchor constant:-2],
    ]];

    self.view = view;
}

- (void)setStyle:(KYAMenuBarIconStyle *)style
{
    _style = style;
    _labelView.stringValue = style.displayName ?: @"";

    NSImage *image = nil;
    if(style.symbolName != nil)
    {
        if(@available(macOS 11.0, *))
        {
            image = [NSImage imageWithSystemSymbolName:style.symbolName
                              accessibilityDescription:style.displayName];
        }
    }
    else
    {
        image = [NSImage imageNamed:@"ActiveIcon"];
    }
    _iconView.image = image;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    _selectionBackdrop.layer.backgroundColor = selected
        ? [[NSColor controlAccentColor] colorWithAlphaComponent:0.25].CGColor
        : NSColor.clearColor.CGColor;
    _selectionBackdrop.layer.borderColor = selected
        ? NSColor.controlAccentColor.CGColor
        : NSColor.clearColor.CGColor;
    _selectionBackdrop.layer.borderWidth = selected ? 1.5 : 0.0;
}

@end

#pragma mark - Controller

@interface KYAIconSettingsViewController () <NSCollectionViewDataSource, NSCollectionViewDelegate, NSSearchFieldDelegate>
@property (nonatomic) NSSegmentedControl *slotSegment;
@property (nonatomic) NSSearchField *searchField;
@property (nonatomic) NSPopUpButton *categoryPopUp;
@property (nonatomic) NSCollectionView *collectionView;
@property (nonatomic) NSTextField *activePreviewLabel;
@property (nonatomic) NSImageView *activePreviewIcon;
@property (nonatomic) NSTextField *inactivePreviewLabel;
@property (nonatomic) NSImageView *inactivePreviewIcon;

@property (nonatomic) NSButton *showRemainingTimeCheckbox;
@property (nonatomic) NSPopUpButton *formatPopUp;

@property (nonatomic) NSArray<KYAMenuBarIconStyle *> *filteredStyles;
@end

@implementation KYAIconSettingsViewController

+ (NSTabViewItem *)preferredTabViewItem
{
    KYAIconSettingsViewController *controller = [self new];
    controller.title = NSLocalizedString(@"Menu Bar", @"Menu Bar settings tab title");

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
    NSView *container = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 560, 540)];

    // --- Slot segmented control (Active / Inactive) -------------------
    Auto slotSegment = [NSSegmentedControl segmentedControlWithLabels:@[
        NSLocalizedString(@"Active Icon", @""),
        NSLocalizedString(@"Inactive Icon", @""),
    ] trackingMode:NSSegmentSwitchTrackingSelectOne target:self action:@selector(slotChanged:)];
    slotSegment.segmentStyle = NSSegmentStyleTexturedSquare;
    slotSegment.translatesAutoresizingMaskIntoConstraints = NO;
    [slotSegment setSelected:YES forSegment:KYAIconSlotActive];
    self.slotSegment = slotSegment;

    // --- Search + category row ----------------------------------------
    Auto searchField = [NSSearchField new];
    searchField.placeholderString = NSLocalizedString(@"Search symbols", @"");
    searchField.delegate = self;
    searchField.translatesAutoresizingMaskIntoConstraints = NO;
    self.searchField = searchField;

    Auto categoryPopUp = [NSPopUpButton new];
    categoryPopUp.translatesAutoresizingMaskIntoConstraints = NO;
    categoryPopUp.bezelStyle = NSBezelStyleRounded;
    [categoryPopUp addItemWithTitle:NSLocalizedString(@"All Categories", @"")];
    for(KYAMenuBarIconCategory category in [KYAMenuBarIconStyle orderedCategories])
    {
        NSString *title = [KYAMenuBarIconStyle displayNameForCategory:category];
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:title action:nil keyEquivalent:@""];
        item.representedObject = category;
        [categoryPopUp.menu addItem:item];
    }
    categoryPopUp.target = self;
    categoryPopUp.action = @selector(categoryChanged:);
    self.categoryPopUp = categoryPopUp;

    // --- Collection view ----------------------------------------------
    Auto layout = [NSCollectionViewFlowLayout new];
    layout.itemSize = NSMakeSize(64, 72);
    layout.minimumInteritemSpacing = 8;
    layout.minimumLineSpacing = 8;
    layout.sectionInset = NSEdgeInsetsMake(8, 8, 8, 8);

    Auto collectionView = [[NSCollectionView alloc] initWithFrame:NSZeroRect];
    collectionView.collectionViewLayout = layout;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.selectable = YES;
    collectionView.allowsEmptySelection = NO;
    collectionView.allowsMultipleSelection = NO;
    collectionView.backgroundColors = @[NSColor.clearColor];
    [collectionView registerClass:[KYAIconGridItem class]
            forItemWithIdentifier:@"KYAIconGridItem"];

    Auto scrollView = [NSScrollView new];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.hasVerticalScroller = YES;
    scrollView.borderType = NSBezelBorder;
    scrollView.documentView = collectionView;
    self.collectionView = collectionView;

    // --- Previews ------------------------------------------------------
    Auto activePreviewIcon = [NSImageView new];
    activePreviewIcon.translatesAutoresizingMaskIntoConstraints = NO;
    activePreviewIcon.imageScaling = NSImageScaleProportionallyUpOrDown;
    self.activePreviewIcon = activePreviewIcon;

    Auto activePreviewLabel = [NSTextField labelWithString:@""];
    activePreviewLabel.font = [NSFont systemFontOfSize:NSFont.smallSystemFontSize];
    activePreviewLabel.textColor = NSColor.secondaryLabelColor;
    activePreviewLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.activePreviewLabel = activePreviewLabel;

    Auto activeHeader = [NSTextField labelWithString:NSLocalizedString(@"Active:", @"")];
    activeHeader.font = [NSFont boldSystemFontOfSize:NSFont.smallSystemFontSize];
    activeHeader.translatesAutoresizingMaskIntoConstraints = NO;

    Auto inactivePreviewIcon = [NSImageView new];
    inactivePreviewIcon.translatesAutoresizingMaskIntoConstraints = NO;
    inactivePreviewIcon.imageScaling = NSImageScaleProportionallyUpOrDown;
    self.inactivePreviewIcon = inactivePreviewIcon;

    Auto inactivePreviewLabel = [NSTextField labelWithString:@""];
    inactivePreviewLabel.font = [NSFont systemFontOfSize:NSFont.smallSystemFontSize];
    inactivePreviewLabel.textColor = NSColor.secondaryLabelColor;
    inactivePreviewLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.inactivePreviewLabel = inactivePreviewLabel;

    Auto inactiveHeader = [NSTextField labelWithString:NSLocalizedString(@"Inactive:", @"")];
    inactiveHeader.font = [NSFont boldSystemFontOfSize:NSFont.smallSystemFontSize];
    inactiveHeader.translatesAutoresizingMaskIntoConstraints = NO;

    Auto previewRow = [NSStackView stackViewWithViews:@[
        activeHeader, activePreviewIcon, activePreviewLabel,
        [NSView new],
        inactiveHeader, inactivePreviewIcon, inactivePreviewLabel,
    ]];
    previewRow.orientation = NSUserInterfaceLayoutOrientationHorizontal;
    previewRow.alignment = NSLayoutAttributeCenterY;
    previewRow.spacing = 6;
    previewRow.translatesAutoresizingMaskIntoConstraints = NO;

    Auto divider = [NSBox new];
    divider.boxType = NSBoxSeparator;
    divider.translatesAutoresizingMaskIntoConstraints = NO;

    // --- Remaining time section ---------------------------------------
    Auto timeHeader = [NSTextField labelWithString:NSLocalizedString(@"Remaining Time", @"")];
    timeHeader.font = [NSFont boldSystemFontOfSize:NSFont.systemFontSize];
    timeHeader.translatesAutoresizingMaskIntoConstraints = NO;

    Auto showRemaining = [NSButton checkboxWithTitle:NSLocalizedString(@"Show remaining time next to menu bar icon", @"")
                                              target:self
                                              action:@selector(showRemainingTimeChanged:)];
    showRemaining.translatesAutoresizingMaskIntoConstraints = NO;
    self.showRemainingTimeCheckbox = showRemaining;

    Auto formatLabel = [NSTextField labelWithString:NSLocalizedString(@"Format:", @"")];
    formatLabel.translatesAutoresizingMaskIntoConstraints = NO;

    Auto formatPopUp = [NSPopUpButton new];
    formatPopUp.translatesAutoresizingMaskIntoConstraints = NO;
    formatPopUp.bezelStyle = NSBezelStyleRounded;
    [self addFormatItem:formatPopUp
                  title:NSLocalizedString(@"Compact (2h 30m)", @"")
                  value:KYARemainingTimeFormatCompact];
    [self addFormatItem:formatPopUp
                  title:NSLocalizedString(@"Digital (2:30:00)", @"")
                  value:KYARemainingTimeFormatDigital];
    [self addFormatItem:formatPopUp
                  title:NSLocalizedString(@"Minutes (150m)", @"")
                  value:KYARemainingTimeFormatMinutes];
    formatPopUp.target = self;
    formatPopUp.action = @selector(formatChanged:);
    self.formatPopUp = formatPopUp;

    Auto formatRow = [NSStackView stackViewWithViews:@[formatLabel, formatPopUp]];
    formatRow.orientation = NSUserInterfaceLayoutOrientationHorizontal;
    formatRow.spacing = 8;
    formatRow.translatesAutoresizingMaskIntoConstraints = NO;

    Auto filterRow = [NSStackView stackViewWithViews:@[searchField, categoryPopUp]];
    filterRow.orientation = NSUserInterfaceLayoutOrientationHorizontal;
    filterRow.spacing = 8;
    filterRow.distribution = NSStackViewDistributionFill;
    filterRow.translatesAutoresizingMaskIntoConstraints = NO;

    // Layout root stack
    Auto stack = [NSStackView new];
    stack.orientation = NSUserInterfaceLayoutOrientationVertical;
    stack.alignment = NSLayoutAttributeLeading;
    stack.spacing = 10;
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    [stack addArrangedSubview:slotSegment];
    [stack addArrangedSubview:filterRow];
    [stack addArrangedSubview:scrollView];
    [stack addArrangedSubview:previewRow];
    [stack addArrangedSubview:divider];
    [stack addArrangedSubview:timeHeader];
    [stack addArrangedSubview:showRemaining];
    [stack addArrangedSubview:formatRow];

    [container addSubview:stack];
    [NSLayoutConstraint activateConstraints:@[
        [stack.topAnchor constraintEqualToAnchor:container.topAnchor constant:20],
        [stack.leadingAnchor constraintEqualToAnchor:container.leadingAnchor constant:20],
        [stack.trailingAnchor constraintEqualToAnchor:container.trailingAnchor constant:-20],
        [stack.bottomAnchor constraintEqualToAnchor:container.bottomAnchor constant:-20],

        [slotSegment.leadingAnchor constraintEqualToAnchor:stack.leadingAnchor],
        [slotSegment.trailingAnchor constraintEqualToAnchor:stack.trailingAnchor],

        [filterRow.leadingAnchor constraintEqualToAnchor:stack.leadingAnchor],
        [filterRow.trailingAnchor constraintEqualToAnchor:stack.trailingAnchor],
        [categoryPopUp.widthAnchor constraintGreaterThanOrEqualToConstant:160],

        [scrollView.leadingAnchor constraintEqualToAnchor:stack.leadingAnchor],
        [scrollView.trailingAnchor constraintEqualToAnchor:stack.trailingAnchor],
        [scrollView.heightAnchor constraintEqualToConstant:260],

        [previewRow.leadingAnchor constraintEqualToAnchor:stack.leadingAnchor],
        [previewRow.trailingAnchor constraintEqualToAnchor:stack.trailingAnchor],
        [activePreviewIcon.widthAnchor constraintEqualToConstant:16],
        [activePreviewIcon.heightAnchor constraintEqualToConstant:16],
        [inactivePreviewIcon.widthAnchor constraintEqualToConstant:16],
        [inactivePreviewIcon.heightAnchor constraintEqualToConstant:16],

        [divider.leadingAnchor constraintEqualToAnchor:stack.leadingAnchor],
        [divider.trailingAnchor constraintEqualToAnchor:stack.trailingAnchor],
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

    [self reloadFilteredStyles];
    [self refreshPreviewLabels];
    [self selectCurrentStyleInGrid];
}

- (void)viewWillAppear
{
    [super viewWillAppear];
    self.preferredContentSize = self.view.fittingSize;
}

#pragma mark - Helpers

- (void)addFormatItem:(NSPopUpButton *)popUp title:(NSString *)title value:(KYARemainingTimeFormat)value
{
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:title action:nil keyEquivalent:@""];
    item.representedObject = value;
    [popUp.menu addItem:item];
}

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

- (KYAIconSlot)currentSlot
{
    return (KYAIconSlot)self.slotSegment.selectedSegment;
}

- (KYAMenuBarIconStyleID)currentSlotStyleID
{
    Auto defaults = NSUserDefaults.standardUserDefaults;
    return (self.currentSlot == KYAIconSlotActive)
        ? defaults.kya_menuBarActiveIconStyle
        : defaults.kya_menuBarInactiveIconStyle;
}

- (void)setCurrentSlotStyleID:(KYAMenuBarIconStyleID)identifier
{
    Auto defaults = NSUserDefaults.standardUserDefaults;
    if(self.currentSlot == KYAIconSlotActive)
    {
        defaults.kya_menuBarActiveIconStyle = identifier;
    }
    else
    {
        defaults.kya_menuBarInactiveIconStyle = identifier;
    }
    [KYAStatusItemImageProvider.currentProvider reloadFromDefaults];
}

- (void)reloadFilteredStyles
{
    NSString *query = self.searchField.stringValue.lowercaseString;
    KYAMenuBarIconCategory selectedCategory = self.categoryPopUp.selectedItem.representedObject;

    Auto all = [KYAMenuBarIconStyle allStyles];
    Auto result = [NSMutableArray<KYAMenuBarIconStyle *> new];
    for(KYAMenuBarIconStyle *style in all)
    {
        if(selectedCategory.length > 0 && ![style.category isEqualToString:selectedCategory])
        {
            continue;
        }
        if(query.length > 0)
        {
            NSString *haystack = [NSString stringWithFormat:@"%@ %@ %@",
                                  style.displayName, style.symbolName ?: @"", style.category];
            if([haystack.lowercaseString rangeOfString:query].location == NSNotFound)
            {
                continue;
            }
        }
        [result addObject:style];
    }
    self.filteredStyles = [result copy];
    [self.collectionView reloadData];
}

- (void)selectCurrentStyleInGrid
{
    KYAMenuBarIconStyleID current = [self currentSlotStyleID];
    NSString *targetID = current.length > 0 ? current : KYAMenuBarIconStyleIDDefault;
    for(NSInteger i = 0; i < self.filteredStyles.count; i++)
    {
        if([self.filteredStyles[i].identifier isEqualToString:targetID])
        {
            NSIndexPath *path = [NSIndexPath indexPathForItem:i inSection:0];
            [self.collectionView selectItemsAtIndexPaths:[NSSet setWithObject:path]
                                          scrollPosition:NSCollectionViewScrollPositionCenteredVertically];
            return;
        }
    }
}

- (void)refreshPreviewLabels
{
    Auto defaults = NSUserDefaults.standardUserDefaults;
    Auto active = [KYAMenuBarIconStyle styleForIdentifier:defaults.kya_menuBarActiveIconStyle];
    Auto inactive = [KYAMenuBarIconStyle styleForIdentifier:defaults.kya_menuBarInactiveIconStyle];
    self.activePreviewLabel.stringValue = active.displayName ?: @"";
    self.inactivePreviewLabel.stringValue = inactive.displayName ?: @"";
    self.activePreviewIcon.image = [self previewImageForStyle:active];
    self.inactivePreviewIcon.image = [self previewImageForStyle:inactive];
}

- (nullable NSImage *)previewImageForStyle:(KYAMenuBarIconStyle *)style
{
    if(style.symbolName == nil)
    {
        return [NSImage imageNamed:@"ActiveIcon"];
    }
    if(@available(macOS 11.0, *))
    {
        return [NSImage imageWithSystemSymbolName:style.symbolName
                         accessibilityDescription:style.displayName];
    }
    return nil;
}

#pragma mark - Actions

- (void)slotChanged:(id)sender
{
    [self selectCurrentStyleInGrid];
}

- (void)categoryChanged:(id)sender
{
    [self reloadFilteredStyles];
    [self selectCurrentStyleInGrid];
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

#pragma mark - NSSearchFieldDelegate

- (void)controlTextDidChange:(NSNotification *)obj
{
    if(obj.object == self.searchField)
    {
        [self reloadFilteredStyles];
        [self selectCurrentStyleInGrid];
    }
}

#pragma mark - NSCollectionViewDataSource

- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (NSInteger)self.filteredStyles.count;
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath
{
    KYAIconGridItem *item = [collectionView makeItemWithIdentifier:@"KYAIconGridItem"
                                                      forIndexPath:indexPath];
    KYAMenuBarIconStyle *style = self.filteredStyles[(NSUInteger)indexPath.item];
    item.style = style;
    return item;
}

#pragma mark - NSCollectionViewDelegate

- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths
{
    NSIndexPath *path = indexPaths.anyObject;
    if(path == nil) { return; }
    KYAMenuBarIconStyle *style = self.filteredStyles[(NSUInteger)path.item];
    [self setCurrentSlotStyleID:style.identifier];
    [self refreshPreviewLabels];
}

@end
