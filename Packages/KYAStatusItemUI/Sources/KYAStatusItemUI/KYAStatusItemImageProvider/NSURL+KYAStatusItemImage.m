//
//  NSURL+KYAStatusItemImage.m
//  KYAStatusItemUI
//
//  Created by Marcel Dierkes on 30.04.22.
//

#import "NSURL+KYAStatusItemImage.h"
#import <KYACommon/KYACommon.h>

@implementation NSURL (KYAStatusItemImage)

+ (NSURL *)kya_documentsDirectoryURL
{
    return [NSFileManager.defaultManager URLsForDirectory:NSDocumentDirectory
                                                inDomains:NSUserDomainMask].lastObject;
}

+ (NSURL *)kya_iconImageFileURLWithName:(NSImageName)imageName isRetinaIcon:(BOOL)isRetinaIcon
{
    NSParameterAssert(imageName);
    Auto suffix = isRetinaIcon ? @"@2x" : @"";
    Auto composedName = [NSString stringWithFormat:@"%@%@.png", imageName, suffix];
    return [NSURL.kya_documentsDirectoryURL URLByAppendingPathComponent:composedName];
}

@end

BOOL KYACustomIconImageFileExists(NSImageName imageName, BOOL isRetinaIcon)
{
    NSCParameterAssert(imageName);
    
    Auto fileManager = NSFileManager.defaultManager;
    Auto fileURL = [NSURL kya_iconImageFileURLWithName:imageName isRetinaIcon:isRetinaIcon];
    return [fileManager fileExistsAtPath:fileURL.path];
}
