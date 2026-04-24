//
//  KYAIconSettingsViewController.m
//  KYAStatusItemUI
//

#import <KYAStatusItemUI/KYAIconSettingsViewController.h>
#import <KYAStatusItemUI/KYAMenuBarIconStyle.h>
#import <KYAStatusItemUI/KYAStatusItemImageProvider.h>
#import <KYAApplicationSupport/NSUserDefaults+KYAKeys.h>
#import <KYACommon/KYACommon.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

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
    NSView *_selectionBackdrop;
}

- (void)loadView
{
    NSView *view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 40, 40)];
    view.wantsLayer = YES;

    _selectionBackdrop = [[NSView alloc] initWithFrame:view.bounds];
    _selectionBackdrop.wantsLayer = YES;
    _selectionBackdrop.layer.cornerRadius = 6.0;
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

    [NSLayoutConstraint activateConstraints:@[
        [_selectionBackdrop.topAnchor constraintEqualToAnchor:view.topAnchor],
        [_selectionBackdrop.leadingAnchor constraintEqualToAnchor:view.leadingAnchor],
        [_selectionBackdrop.trailingAnchor constraintEqualToAnchor:view.trailingAnchor],
        [_selectionBackdrop.bottomAnchor constraintEqualToAnchor:view.bottomAnchor],

        [_iconView.centerXAnchor constraintEqualToAnchor:_selectionBackdrop.centerXAnchor],
        [_iconView.centerYAnchor constraintEqualToAnchor:_selectionBackdrop.centerYAnchor],
        [_iconView.widthAnchor constraintEqualToConstant:22],
        [_iconView.heightAnchor constraintEqualToConstant:22],
    ]];

    self.view = view;
}

- (void)setStyle:(KYAMenuBarIconStyle *)style
{
    _style = style;
    self.view.toolTip = style.displayName ?: @"";

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
    NSColor *accent = NSColor.alternateSelectedControlColor;
    if(@available(macOS 10.14, *))
    {
        accent = NSColor.controlAccentColor;
    }
    _selectionBackdrop.layer.backgroundColor = selected
        ? [accent colorWithAlphaComponent:0.25].CGColor
        : NSColor.clearColor.CGColor;
    _selectionBackdrop.layer.borderColor = selected
        ? accent.CGColor
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

@property (nonatomic) NSButton *chooseCustomFileButton;
@property (nonatomic) NSButton *clearCustomFileButton;
@property (nonatomic) NSTextField *customFileLabel;

@property (nonatomic) NSArray<KYAMenuBarIconStyle *> *filteredStyles;
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

static const CGFloat kKYAMenuBarTabWidth = 480.0;

- (void)loadView
{
    NSView *container = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, kKYAMenuBarTabWidth, 520)];

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
    layout.itemSize = NSMakeSize(40, 40);
    layout.minimumInteritemSpacing = 6;
    layout.minimumLineSpacing = 6;
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

    Auto showRemainingHelp = [NSTextField labelWithString:NSLocalizedString(@"Shows time remaining for timed sessions, or elapsed time for indefinite sessions.", @"")];
    showRemainingHelp.font = [NSFont systemFontOfSize:NSFont.smallSystemFontSize];
    showRemainingHelp.textColor = NSColor.secondaryLabelColor;
    showRemainingHelp.translatesAutoresizingMaskIntoConstraints = NO;
    showRemainingHelp.lineBreakMode = NSLineBreakByWordWrapping;
    showRemainingHelp.maximumNumberOfLines = 2;

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

    // --- Custom file row ----------------------------------------------
    Auto chooseCustom = [NSButton buttonWithTitle:NSLocalizedString(@"Custom File…", @"")
                                           target:self
                                           action:@selector(chooseCustomFile:)];
    chooseCustom.translatesAutoresizingMaskIntoConstraints = NO;
    chooseCustom.bezelStyle = NSBezelStyleRounded;
    self.chooseCustomFileButton = chooseCustom;

    Auto clearCustom = [NSButton buttonWithTitle:NSLocalizedString(@"Reset", @"")
                                          target:self
                                          action:@selector(clearCustomFile:)];
    clearCustom.translatesAutoresizingMaskIntoConstraints = NO;
    clearCustom.bezelStyle = NSBezelStyleRounded;
    self.clearCustomFileButton = clearCustom;

    Auto customLabel = [NSTextField labelWithString:@""];
    customLabel.font = [NSFont systemFontOfSize:NSFont.smallSystemFontSize];
    customLabel.textColor = NSColor.secondaryLabelColor;
    customLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    customLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.customFileLabel = customLabel;

    Auto customRow = [NSStackView stackViewWithViews:@[chooseCustom, clearCustom, customLabel]];
    customRow.orientation = NSUserInterfaceLayoutOrientationHorizontal;
    customRow.spacing = 8;
    customRow.alignment = NSLayoutAttributeCenterY;
    customRow.translatesAutoresizingMaskIntoConstraints = NO;

    // Layout root stack
    Auto stack = [NSStackView new];
    stack.orientation = NSUserInterfaceLayoutOrientationVertical;
    stack.alignment = NSLayoutAttributeLeading;
    stack.spacing = 10;
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    [stack addArrangedSubview:slotSegment];
    [stack addArrangedSubview:filterRow];
    [stack addArrangedSubview:scrollView];
    [stack addArrangedSubview:customRow];
    [stack addArrangedSubview:previewRow];
    [stack addArrangedSubview:divider];
    [stack addArrangedSubview:timeHeader];
    [stack addArrangedSubview:showRemaining];
    [stack addArrangedSubview:showRemainingHelp];
    [stack addArrangedSubview:formatRow];

    [container addSubview:stack];
    [NSLayoutConstraint activateConstraints:@[
        [container.widthAnchor constraintEqualToConstant:kKYAMenuBarTabWidth],

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

        [customRow.leadingAnchor constraintEqualToAnchor:stack.leadingAnchor],
        [customRow.trailingAnchor constraintEqualToAnchor:stack.trailingAnchor],

        [previewRow.leadingAnchor constraintEqualToAnchor:stack.leadingAnchor],
        [previewRow.trailingAnchor constraintEqualToAnchor:stack.trailingAnchor],
        [activePreviewIcon.widthAnchor constraintEqualToConstant:16],
        [activePreviewIcon.heightAnchor constraintEqualToConstant:16],
        [inactivePreviewIcon.widthAnchor constraintEqualToConstant:16],
        [inactivePreviewIcon.heightAnchor constraintEqualToConstant:16],

        [divider.leadingAnchor constraintEqualToAnchor:stack.leadingAnchor],
        [divider.trailingAnchor constraintEqualToAnchor:stack.trailingAnchor],

        [showRemainingHelp.leadingAnchor constraintEqualToAnchor:stack.leadingAnchor],
        [showRemainingHelp.trailingAnchor constraintEqualToAnchor:stack.trailingAnchor],
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
    // Keep in sync with KYASettingsContentViewController's unified size so the
    // preferences window stays a constant size across tabs.
    self.preferredContentSize = NSMakeSize(kKYAMenuBarTabWidth, 600.0);
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
    NSString *activeCustom = defaults.kya_menuBarActiveCustomIconFile;
    NSString *inactiveCustom = defaults.kya_menuBarInactiveCustomIconFile;

    if(activeCustom.length > 0)
    {
        self.activePreviewLabel.stringValue = [NSString stringWithFormat:@"📎 %@", activeCustom];
        self.activePreviewIcon.image = [self customPreviewImageForFilename:activeCustom];
    }
    else
    {
        Auto active = [KYAMenuBarIconStyle styleForIdentifier:defaults.kya_menuBarActiveIconStyle];
        self.activePreviewLabel.stringValue = active.displayName ?: @"";
        self.activePreviewIcon.image = [self previewImageForStyle:active];
    }

    if(inactiveCustom.length > 0)
    {
        self.inactivePreviewLabel.stringValue = [NSString stringWithFormat:@"📎 %@", inactiveCustom];
        self.inactivePreviewIcon.image = [self customPreviewImageForFilename:inactiveCustom];
    }
    else
    {
        Auto inactive = [KYAMenuBarIconStyle styleForIdentifier:defaults.kya_menuBarInactiveIconStyle];
        self.inactivePreviewLabel.stringValue = inactive.displayName ?: @"";
        self.inactivePreviewIcon.image = [self previewImageForStyle:inactive];
    }

    [self refreshCustomFileRow];
}

- (void)refreshCustomFileRow
{
    NSString *filename = [self currentSlotCustomFilename];
    if(filename.length > 0)
    {
        self.customFileLabel.stringValue = filename;
        self.customFileLabel.toolTip = filename;
        self.clearCustomFileButton.enabled = YES;
    }
    else
    {
        self.customFileLabel.stringValue = NSLocalizedString(@"No custom file — using grid selection", @"");
        self.customFileLabel.toolTip = nil;
        self.clearCustomFileButton.enabled = NO;
    }
}

- (nullable NSImage *)customPreviewImageForFilename:(NSString *)filename
{
    Auto url = [[self customIconsDirectoryURL] URLByAppendingPathComponent:filename];
    NSImage *image = [[NSImage alloc] initWithContentsOfURL:url];
    image.template = YES;
    return image;
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
    [self refreshCustomFileRow];
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

- (void)chooseCustomFile:(id)sender
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.canChooseFiles = YES;
    panel.canChooseDirectories = NO;
    panel.allowsMultipleSelection = NO;
    panel.message = NSLocalizedString(@"Pick an image (SVG, PDF, or PNG recommended). It will be rendered as a template — colors are ignored.", @"");
    if(@available(macOS 11.0, *))
    {
        NSMutableArray<UTType *> *types = [NSMutableArray arrayWithObjects:UTTypeSVG, UTTypePDF, UTTypePNG, UTTypeTIFF, UTTypeImage, nil];
        panel.allowedContentTypes = types;
    }
    else
    {
        panel.allowedFileTypes = @[@"svg", @"pdf", @"png", @"tiff", @"tif"];
    }

    NSWindow *window = self.view.window;
    void (^handler)(NSModalResponse) = ^(NSModalResponse response) {
        if(response != NSModalResponseOK) { return; }
        NSURL *src = panel.URLs.firstObject;
        if(src == nil) { return; }
        [self importCustomFileAtURL:src];
    };
    if(window != nil) { [panel beginSheetModalForWindow:window completionHandler:handler]; }
    else              { handler([panel runModal]); }
}

- (void)importCustomFileAtURL:(NSURL *)sourceURL
{
    NSURL *directory = [self customIconsDirectoryURL];
    NSError *error = nil;
    if(![NSFileManager.defaultManager createDirectoryAtURL:directory
                               withIntermediateDirectories:YES
                                                attributes:nil
                                                     error:&error])
    {
        [self presentError:error];
        return;
    }

    NSString *ext = sourceURL.pathExtension.length > 0 ? sourceURL.pathExtension : @"png";
    NSString *slotName = (self.currentSlot == KYAIconSlotActive) ? @"CustomActive" : @"CustomInactive";
    NSString *filename = [NSString stringWithFormat:@"%@.%@", slotName, ext];
    NSURL *dest = [directory URLByAppendingPathComponent:filename];

    // Replace any previous file (including a different extension) for this slot.
    [self removeExistingCustomFilesForSlot:self.currentSlot inDirectory:directory];

    if(![NSFileManager.defaultManager copyItemAtURL:sourceURL toURL:dest error:&error])
    {
        [self presentError:error];
        return;
    }

    [self setCurrentSlotCustomFilename:filename];
    [KYAStatusItemImageProvider.currentProvider reloadFromDefaults];
    [self refreshPreviewLabels];
}

- (void)clearCustomFile:(id)sender
{
    NSString *filename = [self currentSlotCustomFilename];
    if(filename.length > 0)
    {
        NSURL *url = [[self customIconsDirectoryURL] URLByAppendingPathComponent:filename];
        [NSFileManager.defaultManager removeItemAtURL:url error:nil];
    }
    [self setCurrentSlotCustomFilename:nil];
    [KYAStatusItemImageProvider.currentProvider reloadFromDefaults];
    [self refreshPreviewLabels];
}

- (void)removeExistingCustomFilesForSlot:(KYAIconSlot)slot inDirectory:(NSURL *)directory
{
    NSString *prefix = (slot == KYAIconSlotActive) ? @"CustomActive." : @"CustomInactive.";
    NSArray<NSURL *> *contents = [NSFileManager.defaultManager contentsOfDirectoryAtURL:directory
                                                            includingPropertiesForKeys:nil
                                                                               options:0
                                                                                 error:nil];
    for(NSURL *url in contents)
    {
        if([url.lastPathComponent hasPrefix:prefix])
        {
            [NSFileManager.defaultManager removeItemAtURL:url error:nil];
        }
    }
}

- (NSURL *)customIconsDirectoryURL
{
    NSURL *docs = [NSFileManager.defaultManager URLsForDirectory:NSDocumentDirectory
                                                       inDomains:NSUserDomainMask].lastObject;
    return docs;
}

- (nullable NSString *)currentSlotCustomFilename
{
    Auto defaults = NSUserDefaults.standardUserDefaults;
    return (self.currentSlot == KYAIconSlotActive)
        ? defaults.kya_menuBarActiveCustomIconFile
        : defaults.kya_menuBarInactiveCustomIconFile;
}

- (void)setCurrentSlotCustomFilename:(nullable NSString *)filename
{
    Auto defaults = NSUserDefaults.standardUserDefaults;
    if(self.currentSlot == KYAIconSlotActive)
    {
        defaults.kya_menuBarActiveCustomIconFile = filename;
    }
    else
    {
        defaults.kya_menuBarInactiveCustomIconFile = filename;
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
