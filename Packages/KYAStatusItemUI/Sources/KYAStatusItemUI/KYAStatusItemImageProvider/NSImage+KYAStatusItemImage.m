//
//  NSImage+KYAStatusItemImage.m
//  KYAStatusItemUI
//
//  Created by Marcel Dierkes on 30.04.22.
//

#import "NSImage+KYAStatusItemImage.h"
#import "../KYADefines.h"
#import "NSURL+KYAStatusItemImage.h"

const NSImageName KYAStatusItemActiveImageName = @"ActiveIcon";
const NSImageName KYAStatusItemInactiveImageName = @"InactiveIcon";

@implementation NSImage (KYAStatusItemImage)

#pragma mark - Default Icon Images

+ (NSImage *)kya_defaultActiveIconImage
{
    return [NSImage imageNamed:KYAStatusItemActiveImageName];
}

+ (NSImage *)kya_defaultInactiveIconImage
{
    return [NSImage imageNamed:KYAStatusItemInactiveImageName];
}

#pragma mark - Custom Icon Images

+ (NSImage *)kya_customActiveIconImage
{
    return [self customIconNamed:KYAStatusItemActiveImageName];
}

+ (NSImage *)kya_customInactiveIconImage
{
    return [self customIconNamed:KYAStatusItemInactiveImageName];
}

#pragma mark -

+ (NSImage *)customIconNamed:(NSImageName)imageName
{
    NSParameterAssert(imageName);
    
    Auto fileURL = [NSURL kya_iconImageFileURLWithName:imageName isRetinaIcon:NO];
    Auto image = [[NSImage alloc] initWithContentsOfURL:fileURL];
    image.template = YES;
    
    Auto retinaFileURL = [NSURL kya_iconImageFileURLWithName:imageName isRetinaIcon:YES];
    Auto retinaRep = [NSImageRep imageRepWithContentsOfURL:retinaFileURL];
    if(retinaRep != nil)
    {
        [image addRepresentation:retinaRep];
    }
    
    return image;
}

@end

BOOL KYACustomIconImageFilesExist()
{
    return KYACustomIconImageFileExists(KYAStatusItemActiveImageName, NO)
    && KYACustomIconImageFileExists(KYAStatusItemActiveImageName, YES)
    && KYACustomIconImageFileExists(KYAStatusItemInactiveImageName, NO)
    && KYACustomIconImageFileExists(KYAStatusItemInactiveImageName, YES);
}
