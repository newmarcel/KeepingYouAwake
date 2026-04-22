//
//  KYAMenuBarIconStyle.h
//  KYAStatusItemUI
//

#import <Cocoa/Cocoa.h>
#import <KYACommon/KYAExport.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *KYAMenuBarIconStyleID NS_TYPED_EXTENSIBLE_ENUM;
typedef NSString *KYAMenuBarIconCategory NS_TYPED_EXTENSIBLE_ENUM;

KYA_EXPORT KYAMenuBarIconStyleID const KYAMenuBarIconStyleIDDefault;

KYA_EXPORT KYAMenuBarIconCategory const KYAMenuBarIconCategoryDefault;
KYA_EXPORT KYAMenuBarIconCategory const KYAMenuBarIconCategoryEnergy;
KYA_EXPORT KYAMenuBarIconCategory const KYAMenuBarIconCategoryWeather;
KYA_EXPORT KYAMenuBarIconCategory const KYAMenuBarIconCategoryNature;
KYA_EXPORT KYAMenuBarIconCategory const KYAMenuBarIconCategoryObjects;
KYA_EXPORT KYAMenuBarIconCategory const KYAMenuBarIconCategoryTime;
KYA_EXPORT KYAMenuBarIconCategory const KYAMenuBarIconCategoryDevices;
KYA_EXPORT KYAMenuBarIconCategory const KYAMenuBarIconCategoryAbstract;
KYA_EXPORT KYAMenuBarIconCategory const KYAMenuBarIconCategoryEyes;

/// One selectable menu bar icon option.
/// A style with a nil `symbolName` resolves to the bundled default asset.
@interface KYAMenuBarIconStyle : NSObject
@property (nonatomic, readonly) KYAMenuBarIconStyleID identifier;
@property (nonatomic, readonly) NSString *displayName;
@property (nonatomic, readonly, nullable) NSString *symbolName;
@property (nonatomic, readonly) KYAMenuBarIconCategory category;

/// The full curated symbol catalog available to either active or inactive slots.
+ (NSArray<KYAMenuBarIconStyle *> *)allStyles;

/// Category display order. Includes the built-in default as its own category.
+ (NSArray<KYAMenuBarIconCategory> *)orderedCategories;

/// Localized display name for a category identifier.
+ (NSString *)displayNameForCategory:(KYAMenuBarIconCategory)category;

/// Looks up a style by identifier; falls back to the default style when unknown.
+ (KYAMenuBarIconStyle *)styleForIdentifier:(nullable KYAMenuBarIconStyleID)identifier;

/// Convenience wrappers kept for compatibility with the image provider.
/// Both fall back to the built-in default when the identifier is unknown or empty.
+ (KYAMenuBarIconStyle *)activeStyleForIdentifier:(nullable KYAMenuBarIconStyleID)identifier;
+ (KYAMenuBarIconStyle *)inactiveStyleForIdentifier:(nullable KYAMenuBarIconStyleID)identifier;

@end

NS_ASSUME_NONNULL_END
