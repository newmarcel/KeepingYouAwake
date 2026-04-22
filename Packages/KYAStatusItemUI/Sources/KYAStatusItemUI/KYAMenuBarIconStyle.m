//
//  KYAMenuBarIconStyle.m
//  KYAStatusItemUI
//

#import <KYAStatusItemUI/KYAMenuBarIconStyle.h>
#import <KYACommon/KYACommon.h>

KYAMenuBarIconStyleID const KYAMenuBarIconStyleIDDefault = @"default";

@interface KYAMenuBarIconStyle ()
@property (nonatomic, readwrite) KYAMenuBarIconStyleID identifier;
@property (nonatomic, readwrite) NSString *displayName;
@property (nonatomic, readwrite, nullable) NSString *symbolName;
@property (nonatomic) BOOL isActive;
@end

@implementation KYAMenuBarIconStyle

- (instancetype)initWithIdentifier:(KYAMenuBarIconStyleID)identifier
                       displayName:(NSString *)displayName
                        symbolName:(nullable NSString *)symbolName
                          isActive:(BOOL)isActive
{
    self = [super init];
    if(self)
    {
        _identifier = [identifier copy];
        _displayName = [displayName copy];
        _symbolName = [symbolName copy];
        _isActive = isActive;
    }
    return self;
}

+ (NSArray<KYAMenuBarIconStyle *> *)activeStyles
{
    static NSArray<KYAMenuBarIconStyle *> *styles;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        styles = @[
            [[self alloc] initWithIdentifier:KYAMenuBarIconStyleIDDefault
                                 displayName:@"Default (Eye)"
                                  symbolName:nil
                                    isActive:YES],
            [[self alloc] initWithIdentifier:@"bolt.fill"
                                 displayName:@"Bolt"
                                  symbolName:@"bolt.fill"
                                    isActive:YES],
            [[self alloc] initWithIdentifier:@"sun.max.fill"
                                 displayName:@"Sun"
                                  symbolName:@"sun.max.fill"
                                    isActive:YES],
            [[self alloc] initWithIdentifier:@"cup.and.saucer.fill"
                                 displayName:@"Coffee"
                                  symbolName:@"cup.and.saucer.fill"
                                    isActive:YES],
            [[self alloc] initWithIdentifier:@"flame.fill"
                                 displayName:@"Flame"
                                  symbolName:@"flame.fill"
                                    isActive:YES],
            [[self alloc] initWithIdentifier:@"eye.fill"
                                 displayName:@"Open Eye"
                                  symbolName:@"eye.fill"
                                    isActive:YES],
        ];
    });
    return styles;
}

+ (NSArray<KYAMenuBarIconStyle *> *)inactiveStyles
{
    static NSArray<KYAMenuBarIconStyle *> *styles;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        styles = @[
            [[self alloc] initWithIdentifier:KYAMenuBarIconStyleIDDefault
                                 displayName:@"Default (Eye)"
                                  symbolName:nil
                                    isActive:NO],
            [[self alloc] initWithIdentifier:@"bolt.slash"
                                 displayName:@"Bolt Slash"
                                  symbolName:@"bolt.slash"
                                    isActive:NO],
            [[self alloc] initWithIdentifier:@"moon.zzz"
                                 displayName:@"Moon"
                                  symbolName:@"moon.zzz"
                                    isActive:NO],
            [[self alloc] initWithIdentifier:@"cup.and.saucer"
                                 displayName:@"Coffee"
                                  symbolName:@"cup.and.saucer"
                                    isActive:NO],
            [[self alloc] initWithIdentifier:@"sun.min"
                                 displayName:@"Sun Min"
                                  symbolName:@"sun.min"
                                    isActive:NO],
            [[self alloc] initWithIdentifier:@"eye.slash"
                                 displayName:@"Closed Eye"
                                  symbolName:@"eye.slash"
                                    isActive:NO],
        ];
    });
    return styles;
}

+ (KYAMenuBarIconStyle *)activeStyleForIdentifier:(KYAMenuBarIconStyleID)identifier
{
    return [self styleForIdentifier:identifier inStyles:[self activeStyles]];
}

+ (KYAMenuBarIconStyle *)inactiveStyleForIdentifier:(KYAMenuBarIconStyleID)identifier
{
    return [self styleForIdentifier:identifier inStyles:[self inactiveStyles]];
}

+ (KYAMenuBarIconStyle *)styleForIdentifier:(KYAMenuBarIconStyleID)identifier
                                   inStyles:(NSArray<KYAMenuBarIconStyle *> *)styles
{
    if(identifier.length > 0)
    {
        for(KYAMenuBarIconStyle *style in styles)
        {
            if([style.identifier isEqualToString:identifier]) { return style; }
        }
    }
    return styles.firstObject;
}

@end
