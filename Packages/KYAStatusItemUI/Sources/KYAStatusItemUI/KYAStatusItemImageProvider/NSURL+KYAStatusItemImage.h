//
//  NSURL+KYAStatusItemImage.h
//  KYAStatusItemUI
//
//  Created by Marcel Dierkes on 30.04.22.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

BOOL KYACustomIconImageFileExists(NSImageName, BOOL isRetinaIcon);

@interface NSURL (KYAStatusItemImage)
@property (class, nonatomic, readonly) NSURL *kya_documentsDirectoryURL;

+ (NSURL *)kya_iconImageFileURLWithName:(NSImageName)imageName
                           isRetinaIcon:(BOOL)isRetinaIcon;

@end

NS_ASSUME_NONNULL_END
