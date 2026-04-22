//
//  KYAMenuBarIconStyle.h
//  KYAStatusItemUI
//

#import <Cocoa/Cocoa.h>
#import <KYACommon/KYAExport.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *KYAMenuBarIconStyleID NS_TYPED_EXTENSIBLE_ENUM;

KYA_EXPORT KYAMenuBarIconStyleID const KYAMenuBarIconStyleIDDefault;

/// One selectable menu bar icon option.
/// A style with a nil `symbolName` resolves to the bundled default asset.
@interface KYAMenuBarIconStyle : NSObject
@property (nonatomic, readonly) KYAMenuBarIconStyleID identifier;
@property (nonatomic, readonly) NSString *displayName;
@property (nonatomic, readonly, nullable) NSString *symbolName;

+ (NSArray<KYAMenuBarIconStyle *> *)activeStyles;
+ (NSArray<KYAMenuBarIconStyle *> *)inactiveStyles;

+ (KYAMenuBarIconStyle *)activeStyleForIdentifier:(nullable KYAMenuBarIconStyleID)identifier;
+ (KYAMenuBarIconStyle *)inactiveStyleForIdentifier:(nullable KYAMenuBarIconStyleID)identifier;

@end

NS_ASSUME_NONNULL_END
