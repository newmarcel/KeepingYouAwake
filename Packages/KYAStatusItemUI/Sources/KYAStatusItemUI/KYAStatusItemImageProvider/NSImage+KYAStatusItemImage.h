//
//  NSImage+KYAStatusItemImage.h
//  KYAStatusItemUI
//
//  Created by Marcel Dierkes on 30.04.22.
//

#import <Cocoa/Cocoa.h>
#import <KYACommon/KYAExport.h>

NS_ASSUME_NONNULL_BEGIN

KYA_EXPORT const NSImageName KYAStatusItemActiveImageName;
KYA_EXPORT const NSImageName KYAStatusItemInactiveImageName;

BOOL KYACustomIconImageFilesExist(void);

@interface NSImage (KYAStatusItemImage)
@property (class, copy, nonatomic, readonly) NSImage *kya_defaultActiveIconImage;
@property (class, copy, nonatomic, readonly) NSImage *kya_defaultInactiveIconImage;

@property (class, copy, nonatomic, readonly) NSImage *kya_customActiveIconImage;
@property (class, copy, nonatomic, readonly) NSImage *kya_customInactiveIconImage;
@end

NS_ASSUME_NONNULL_END
