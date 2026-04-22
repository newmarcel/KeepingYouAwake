//
//  KYAMenuBarIconStyle.m
//  KYAStatusItemUI
//

#import <KYAStatusItemUI/KYAMenuBarIconStyle.h>
#import <KYACommon/KYACommon.h>

KYAMenuBarIconStyleID const KYAMenuBarIconStyleIDDefault = @"default";

KYAMenuBarIconCategory const KYAMenuBarIconCategoryDefault  = @"default";
KYAMenuBarIconCategory const KYAMenuBarIconCategoryEyes     = @"eyes";
KYAMenuBarIconCategory const KYAMenuBarIconCategoryEnergy   = @"energy";
KYAMenuBarIconCategory const KYAMenuBarIconCategoryWeather  = @"weather";
KYAMenuBarIconCategory const KYAMenuBarIconCategoryNature   = @"nature";
KYAMenuBarIconCategory const KYAMenuBarIconCategoryTime     = @"time";
KYAMenuBarIconCategory const KYAMenuBarIconCategoryDevices  = @"devices";
KYAMenuBarIconCategory const KYAMenuBarIconCategoryObjects  = @"objects";
KYAMenuBarIconCategory const KYAMenuBarIconCategoryAbstract = @"abstract";

@interface KYAMenuBarIconStyle ()
@property (nonatomic, readwrite) KYAMenuBarIconStyleID identifier;
@property (nonatomic, readwrite) NSString *displayName;
@property (nonatomic, readwrite, nullable) NSString *symbolName;
@property (nonatomic, readwrite) KYAMenuBarIconCategory category;
@end

@implementation KYAMenuBarIconStyle

- (instancetype)initWithIdentifier:(KYAMenuBarIconStyleID)identifier
                       displayName:(NSString *)displayName
                        symbolName:(nullable NSString *)symbolName
                          category:(KYAMenuBarIconCategory)category
{
    self = [super init];
    if(self)
    {
        _identifier = [identifier copy];
        _displayName = [displayName copy];
        _symbolName = [symbolName copy];
        _category = [category copy];
    }
    return self;
}

#pragma mark - Catalog

+ (NSArray<KYAMenuBarIconStyle *> *)allStyles
{
    static NSArray<KYAMenuBarIconStyle *> *styles;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray<KYAMenuBarIconStyle *> *all = [NSMutableArray new];

        #define ADD(_id, _name, _symbol, _cat) \
            [all addObject:[[KYAMenuBarIconStyle alloc] initWithIdentifier:(_id) \
                                                               displayName:(_name) \
                                                                symbolName:(_symbol) \
                                                                  category:(_cat)]]

        // Default (bundled asset) ------------------------------------------
        ADD(KYAMenuBarIconStyleIDDefault, @"Default (Eye)", nil, KYAMenuBarIconCategoryDefault);

        // Eyes -------------------------------------------------------------
        ADD(@"eye.fill",                  @"Eye (Filled)",      @"eye.fill",                  KYAMenuBarIconCategoryEyes);
        ADD(@"eye",                       @"Eye",               @"eye",                       KYAMenuBarIconCategoryEyes);
        ADD(@"eye.slash.fill",            @"Eye Slash",         @"eye.slash.fill",            KYAMenuBarIconCategoryEyes);
        ADD(@"eye.slash",                 @"Eye Slash Outline", @"eye.slash",                 KYAMenuBarIconCategoryEyes);
        ADD(@"eye.circle.fill",           @"Eye Circle",        @"eye.circle.fill",           KYAMenuBarIconCategoryEyes);
        ADD(@"eye.circle",                @"Eye Ring",          @"eye.circle",                KYAMenuBarIconCategoryEyes);
        ADD(@"eyes",                      @"Eyes",              @"eyes",                      KYAMenuBarIconCategoryEyes);
        ADD(@"eyeglasses",                @"Eyeglasses",        @"eyeglasses",                KYAMenuBarIconCategoryEyes);

        // Energy & Power ---------------------------------------------------
        ADD(@"bolt.fill",                 @"Bolt",              @"bolt.fill",                 KYAMenuBarIconCategoryEnergy);
        ADD(@"bolt",                      @"Bolt Outline",      @"bolt",                      KYAMenuBarIconCategoryEnergy);
        ADD(@"bolt.slash.fill",           @"Bolt Slash",        @"bolt.slash.fill",           KYAMenuBarIconCategoryEnergy);
        ADD(@"bolt.slash",                @"Bolt Slash Thin",   @"bolt.slash",                KYAMenuBarIconCategoryEnergy);
        ADD(@"bolt.circle.fill",          @"Bolt Circle",       @"bolt.circle.fill",          KYAMenuBarIconCategoryEnergy);
        ADD(@"bolt.circle",               @"Bolt Ring",         @"bolt.circle",               KYAMenuBarIconCategoryEnergy);
        ADD(@"bolt.heart.fill",           @"Bolt Heart",        @"bolt.heart.fill",           KYAMenuBarIconCategoryEnergy);
        ADD(@"bolt.batteryblock.fill",    @"Bolt + Battery",    @"bolt.batteryblock.fill",    KYAMenuBarIconCategoryEnergy);
        ADD(@"battery.100",               @"Battery Full",      @"battery.100",               KYAMenuBarIconCategoryEnergy);
        ADD(@"battery.75",                @"Battery 75",        @"battery.75",                KYAMenuBarIconCategoryEnergy);
        ADD(@"battery.50",                @"Battery 50",        @"battery.50",                KYAMenuBarIconCategoryEnergy);
        ADD(@"battery.25",                @"Battery 25",        @"battery.25",                KYAMenuBarIconCategoryEnergy);
        ADD(@"battery.0",                 @"Battery Empty",     @"battery.0",                 KYAMenuBarIconCategoryEnergy);
        ADD(@"powerplug.fill",            @"Power Plug",        @"powerplug.fill",            KYAMenuBarIconCategoryEnergy);
        ADD(@"powerplug",                 @"Power Plug Thin",   @"powerplug",                 KYAMenuBarIconCategoryEnergy);
        ADD(@"power",                     @"Power",             @"power",                     KYAMenuBarIconCategoryEnergy);
        ADD(@"power.circle.fill",         @"Power Circle",      @"power.circle.fill",         KYAMenuBarIconCategoryEnergy);
        ADD(@"poweron",                   @"Power On",          @"poweron",                   KYAMenuBarIconCategoryEnergy);
        ADD(@"poweroff",                  @"Power Off",         @"poweroff",                  KYAMenuBarIconCategoryEnergy);

        // Weather / Sun / Moon --------------------------------------------
        ADD(@"sun.max.fill",              @"Sun",               @"sun.max.fill",              KYAMenuBarIconCategoryWeather);
        ADD(@"sun.max",                   @"Sun Thin",          @"sun.max",                   KYAMenuBarIconCategoryWeather);
        ADD(@"sun.min.fill",              @"Sun Min",           @"sun.min.fill",              KYAMenuBarIconCategoryWeather);
        ADD(@"sun.min",                   @"Sun Min Thin",      @"sun.min",                   KYAMenuBarIconCategoryWeather);
        ADD(@"sunrise.fill",              @"Sunrise",           @"sunrise.fill",              KYAMenuBarIconCategoryWeather);
        ADD(@"sunset.fill",               @"Sunset",            @"sunset.fill",               KYAMenuBarIconCategoryWeather);
        ADD(@"sun.haze.fill",             @"Sun Haze",          @"sun.haze.fill",             KYAMenuBarIconCategoryWeather);
        ADD(@"moon.fill",                 @"Moon",              @"moon.fill",                 KYAMenuBarIconCategoryWeather);
        ADD(@"moon",                      @"Moon Thin",         @"moon",                      KYAMenuBarIconCategoryWeather);
        ADD(@"moon.zzz.fill",             @"Moon Zzz",          @"moon.zzz.fill",             KYAMenuBarIconCategoryWeather);
        ADD(@"moon.zzz",                  @"Moon Zzz Thin",     @"moon.zzz",                  KYAMenuBarIconCategoryWeather);
        ADD(@"moon.stars.fill",           @"Moon & Stars",      @"moon.stars.fill",           KYAMenuBarIconCategoryWeather);
        ADD(@"cloud.fill",                @"Cloud",             @"cloud.fill",                KYAMenuBarIconCategoryWeather);
        ADD(@"cloud.sun.fill",            @"Cloud + Sun",       @"cloud.sun.fill",            KYAMenuBarIconCategoryWeather);
        ADD(@"cloud.moon.fill",           @"Cloud + Moon",      @"cloud.moon.fill",           KYAMenuBarIconCategoryWeather);
        ADD(@"cloud.bolt.fill",           @"Thunder Cloud",     @"cloud.bolt.fill",           KYAMenuBarIconCategoryWeather);
        ADD(@"cloud.rain.fill",           @"Rain Cloud",        @"cloud.rain.fill",           KYAMenuBarIconCategoryWeather);
        ADD(@"snowflake",                 @"Snowflake",         @"snowflake",                 KYAMenuBarIconCategoryWeather);
        ADD(@"wind",                      @"Wind",              @"wind",                      KYAMenuBarIconCategoryWeather);
        ADD(@"tornado",                   @"Tornado",           @"tornado",                   KYAMenuBarIconCategoryWeather);
        ADD(@"sparkles",                  @"Sparkles",          @"sparkles",                  KYAMenuBarIconCategoryWeather);
        ADD(@"rainbow",                   @"Rainbow",           @"rainbow",                   KYAMenuBarIconCategoryWeather);

        // Nature -----------------------------------------------------------
        ADD(@"flame.fill",                @"Flame",             @"flame.fill",                KYAMenuBarIconCategoryNature);
        ADD(@"flame",                     @"Flame Thin",        @"flame",                     KYAMenuBarIconCategoryNature);
        ADD(@"drop.fill",                 @"Drop",              @"drop.fill",                 KYAMenuBarIconCategoryNature);
        ADD(@"drop",                      @"Drop Thin",         @"drop",                      KYAMenuBarIconCategoryNature);
        ADD(@"leaf.fill",                 @"Leaf",              @"leaf.fill",                 KYAMenuBarIconCategoryNature);
        ADD(@"leaf",                      @"Leaf Thin",         @"leaf",                      KYAMenuBarIconCategoryNature);
        ADD(@"tree.fill",                 @"Tree",              @"tree.fill",                 KYAMenuBarIconCategoryNature);
        ADD(@"tortoise.fill",             @"Tortoise",          @"tortoise.fill",             KYAMenuBarIconCategoryNature);
        ADD(@"hare.fill",                 @"Hare",              @"hare.fill",                 KYAMenuBarIconCategoryNature);
        ADD(@"ant.fill",                  @"Ant",               @"ant.fill",                  KYAMenuBarIconCategoryNature);
        ADD(@"ladybug.fill",              @"Ladybug",           @"ladybug.fill",              KYAMenuBarIconCategoryNature);
        ADD(@"fish.fill",                 @"Fish",              @"fish.fill",                 KYAMenuBarIconCategoryNature);
        ADD(@"pawprint.fill",             @"Paw Print",         @"pawprint.fill",             KYAMenuBarIconCategoryNature);

        // Time -------------------------------------------------------------
        ADD(@"clock.fill",                @"Clock",             @"clock.fill",                KYAMenuBarIconCategoryTime);
        ADD(@"clock",                     @"Clock Thin",        @"clock",                     KYAMenuBarIconCategoryTime);
        ADD(@"alarm.fill",                @"Alarm",             @"alarm.fill",                KYAMenuBarIconCategoryTime);
        ADD(@"alarm",                     @"Alarm Thin",        @"alarm",                     KYAMenuBarIconCategoryTime);
        ADD(@"stopwatch.fill",            @"Stopwatch",         @"stopwatch.fill",            KYAMenuBarIconCategoryTime);
        ADD(@"stopwatch",                 @"Stopwatch Thin",    @"stopwatch",                 KYAMenuBarIconCategoryTime);
        ADD(@"timer",                     @"Timer",             @"timer",                     KYAMenuBarIconCategoryTime);
        ADD(@"hourglass",                 @"Hourglass",         @"hourglass",                 KYAMenuBarIconCategoryTime);
        ADD(@"hourglass.tophalf.filled",  @"Hourglass Top",     @"hourglass.tophalf.filled",  KYAMenuBarIconCategoryTime);
        ADD(@"hourglass.bottomhalf.filled",@"Hourglass Bottom", @"hourglass.bottomhalf.filled",KYAMenuBarIconCategoryTime);
        ADD(@"calendar",                  @"Calendar",          @"calendar",                  KYAMenuBarIconCategoryTime);

        // Devices ----------------------------------------------------------
        ADD(@"display",                   @"Display",           @"display",                   KYAMenuBarIconCategoryDevices);
        ADD(@"display.2",                 @"Two Displays",      @"display.2",                 KYAMenuBarIconCategoryDevices);
        ADD(@"laptopcomputer",            @"Laptop",            @"laptopcomputer",            KYAMenuBarIconCategoryDevices);
        ADD(@"desktopcomputer",           @"Desktop",           @"desktopcomputer",           KYAMenuBarIconCategoryDevices);
        ADD(@"keyboard",                  @"Keyboard",          @"keyboard",                  KYAMenuBarIconCategoryDevices);
        ADD(@"cpu",                       @"CPU",               @"cpu",                       KYAMenuBarIconCategoryDevices);
        ADD(@"memorychip",                @"Memory Chip",       @"memorychip",                KYAMenuBarIconCategoryDevices);
        ADD(@"fanblades.fill",            @"Fan",               @"fanblades.fill",            KYAMenuBarIconCategoryDevices);
        ADD(@"headphones",                @"Headphones",        @"headphones",                KYAMenuBarIconCategoryDevices);
        ADD(@"antenna.radiowaves.left.and.right", @"Antenna",   @"antenna.radiowaves.left.and.right", KYAMenuBarIconCategoryDevices);
        ADD(@"wifi",                      @"Wi-Fi",             @"wifi",                      KYAMenuBarIconCategoryDevices);
        ADD(@"wifi.slash",                @"Wi-Fi Slash",       @"wifi.slash",                KYAMenuBarIconCategoryDevices);

        // Objects ----------------------------------------------------------
        ADD(@"cup.and.saucer.fill",       @"Coffee",            @"cup.and.saucer.fill",       KYAMenuBarIconCategoryObjects);
        ADD(@"cup.and.saucer",            @"Coffee Thin",       @"cup.and.saucer",            KYAMenuBarIconCategoryObjects);
        ADD(@"mug.fill",                  @"Mug",               @"mug.fill",                  KYAMenuBarIconCategoryObjects);
        ADD(@"takeoutbag.and.cup.and.straw.fill", @"Takeout",   @"takeoutbag.and.cup.and.straw.fill", KYAMenuBarIconCategoryObjects);
        ADD(@"lightbulb.fill",            @"Lightbulb",         @"lightbulb.fill",             KYAMenuBarIconCategoryObjects);
        ADD(@"lightbulb",                 @"Lightbulb Thin",    @"lightbulb",                  KYAMenuBarIconCategoryObjects);
        ADD(@"lightbulb.slash.fill",      @"Lightbulb Slash",   @"lightbulb.slash.fill",       KYAMenuBarIconCategoryObjects);
        ADD(@"gamecontroller.fill",       @"Controller",        @"gamecontroller.fill",        KYAMenuBarIconCategoryObjects);
        ADD(@"guitars.fill",              @"Guitars",           @"guitars.fill",               KYAMenuBarIconCategoryObjects);
        ADD(@"pills.fill",                @"Pills",             @"pills.fill",                 KYAMenuBarIconCategoryObjects);
        ADD(@"cross.vial.fill",           @"Vial",              @"cross.vial.fill",            KYAMenuBarIconCategoryObjects);
        ADD(@"wand.and.stars",            @"Wand",              @"wand.and.stars",             KYAMenuBarIconCategoryObjects);
        ADD(@"gift.fill",                 @"Gift",              @"gift.fill",                  KYAMenuBarIconCategoryObjects);
        ADD(@"flag.fill",                 @"Flag",              @"flag.fill",                  KYAMenuBarIconCategoryObjects);
        ADD(@"bell.fill",                 @"Bell",              @"bell.fill",                  KYAMenuBarIconCategoryObjects);
        ADD(@"bell.slash.fill",           @"Bell Slash",        @"bell.slash.fill",            KYAMenuBarIconCategoryObjects);
        ADD(@"lock.fill",                 @"Lock",              @"lock.fill",                  KYAMenuBarIconCategoryObjects);
        ADD(@"lock.open.fill",            @"Lock Open",         @"lock.open.fill",             KYAMenuBarIconCategoryObjects);
        ADD(@"key.fill",                  @"Key",               @"key.fill",                   KYAMenuBarIconCategoryObjects);
        ADD(@"trash.fill",                @"Trash",             @"trash.fill",                 KYAMenuBarIconCategoryObjects);
        ADD(@"paperplane.fill",           @"Paper Plane",       @"paperplane.fill",            KYAMenuBarIconCategoryObjects);

        // Abstract ---------------------------------------------------------
        ADD(@"star.fill",                 @"Star",              @"star.fill",                  KYAMenuBarIconCategoryAbstract);
        ADD(@"star",                      @"Star Thin",         @"star",                       KYAMenuBarIconCategoryAbstract);
        ADD(@"star.circle.fill",          @"Star Circle",       @"star.circle.fill",           KYAMenuBarIconCategoryAbstract);
        ADD(@"heart.fill",                @"Heart",             @"heart.fill",                 KYAMenuBarIconCategoryAbstract);
        ADD(@"heart",                     @"Heart Thin",        @"heart",                      KYAMenuBarIconCategoryAbstract);
        ADD(@"heart.slash.fill",          @"Heart Slash",       @"heart.slash.fill",           KYAMenuBarIconCategoryAbstract);
        ADD(@"circle.fill",               @"Dot",               @"circle.fill",                KYAMenuBarIconCategoryAbstract);
        ADD(@"circle",                    @"Ring",              @"circle",                     KYAMenuBarIconCategoryAbstract);
        ADD(@"circle.dotted",             @"Dotted Ring",       @"circle.dotted",              KYAMenuBarIconCategoryAbstract);
        ADD(@"diamond.fill",              @"Diamond",           @"diamond.fill",               KYAMenuBarIconCategoryAbstract);
        ADD(@"hexagon.fill",              @"Hexagon",           @"hexagon.fill",               KYAMenuBarIconCategoryAbstract);
        ADD(@"triangle.fill",             @"Triangle",          @"triangle.fill",              KYAMenuBarIconCategoryAbstract);
        ADD(@"square.fill",               @"Square",            @"square.fill",                KYAMenuBarIconCategoryAbstract);
        ADD(@"octagon.fill",              @"Octagon",           @"octagon.fill",               KYAMenuBarIconCategoryAbstract);
        ADD(@"seal.fill",                 @"Seal",              @"seal.fill",                  KYAMenuBarIconCategoryAbstract);
        ADD(@"shield.fill",               @"Shield",            @"shield.fill",                KYAMenuBarIconCategoryAbstract);
        ADD(@"target",                    @"Target",            @"target",                     KYAMenuBarIconCategoryAbstract);
        ADD(@"scope",                     @"Scope",             @"scope",                      KYAMenuBarIconCategoryAbstract);
        ADD(@"infinity",                  @"Infinity",          @"infinity",                   KYAMenuBarIconCategoryAbstract);
        ADD(@"atom",                      @"Atom",              @"atom",                       KYAMenuBarIconCategoryAbstract);
        ADD(@"globe",                     @"Globe",             @"globe",                      KYAMenuBarIconCategoryAbstract);
        ADD(@"location.fill",             @"Location",          @"location.fill",              KYAMenuBarIconCategoryAbstract);
        ADD(@"mappin.circle.fill",        @"Map Pin",           @"mappin.circle.fill",         KYAMenuBarIconCategoryAbstract);
        ADD(@"checkmark.seal.fill",       @"Check Seal",        @"checkmark.seal.fill",        KYAMenuBarIconCategoryAbstract);
        ADD(@"xmark.seal.fill",           @"X Seal",            @"xmark.seal.fill",            KYAMenuBarIconCategoryAbstract);
        ADD(@"exclamationmark.triangle.fill", @"Warning",       @"exclamationmark.triangle.fill", KYAMenuBarIconCategoryAbstract);
        ADD(@"questionmark.circle.fill",  @"Question",          @"questionmark.circle.fill",   KYAMenuBarIconCategoryAbstract);

        #undef ADD
        styles = [all copy];
    });
    return styles;
}

+ (NSArray<KYAMenuBarIconCategory> *)orderedCategories
{
    return @[
        KYAMenuBarIconCategoryDefault,
        KYAMenuBarIconCategoryEyes,
        KYAMenuBarIconCategoryEnergy,
        KYAMenuBarIconCategoryWeather,
        KYAMenuBarIconCategoryTime,
        KYAMenuBarIconCategoryNature,
        KYAMenuBarIconCategoryDevices,
        KYAMenuBarIconCategoryObjects,
        KYAMenuBarIconCategoryAbstract,
    ];
}

+ (NSString *)displayNameForCategory:(KYAMenuBarIconCategory)category
{
    if([category isEqualToString:KYAMenuBarIconCategoryDefault])  { return NSLocalizedString(@"Default", @""); }
    if([category isEqualToString:KYAMenuBarIconCategoryEyes])     { return NSLocalizedString(@"Eyes", @""); }
    if([category isEqualToString:KYAMenuBarIconCategoryEnergy])   { return NSLocalizedString(@"Energy", @""); }
    if([category isEqualToString:KYAMenuBarIconCategoryWeather])  { return NSLocalizedString(@"Weather", @""); }
    if([category isEqualToString:KYAMenuBarIconCategoryTime])     { return NSLocalizedString(@"Time", @""); }
    if([category isEqualToString:KYAMenuBarIconCategoryNature])   { return NSLocalizedString(@"Nature", @""); }
    if([category isEqualToString:KYAMenuBarIconCategoryDevices])  { return NSLocalizedString(@"Devices", @""); }
    if([category isEqualToString:KYAMenuBarIconCategoryObjects])  { return NSLocalizedString(@"Objects", @""); }
    if([category isEqualToString:KYAMenuBarIconCategoryAbstract]) { return NSLocalizedString(@"Abstract", @""); }
    return category;
}

+ (KYAMenuBarIconStyle *)styleForIdentifier:(KYAMenuBarIconStyleID)identifier
{
    if(identifier.length > 0)
    {
        for(KYAMenuBarIconStyle *style in [self allStyles])
        {
            if([style.identifier isEqualToString:identifier]) { return style; }
        }
    }
    return [self allStyles].firstObject; // Default
}

+ (KYAMenuBarIconStyle *)activeStyleForIdentifier:(KYAMenuBarIconStyleID)identifier
{
    return [self styleForIdentifier:identifier];
}

+ (KYAMenuBarIconStyle *)inactiveStyleForIdentifier:(KYAMenuBarIconStyleID)identifier
{
    return [self styleForIdentifier:identifier];
}

@end
