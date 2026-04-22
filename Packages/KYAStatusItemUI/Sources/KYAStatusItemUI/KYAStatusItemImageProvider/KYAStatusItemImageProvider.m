//
//  KYAStatusItemImageProvider.m
//  KYAStatusItemUI
//
//  Created by Marcel Dierkes on 17.08.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import "KYAStatusItemImageProvider+Private.h"
#import <KYACommon/KYACommon.h>
#import <KYAApplicationSupport/NSUserDefaults+KYAKeys.h>
#import <KYAStatusItemUI/KYAMenuBarIconStyle.h>
#import "NSURL+KYAStatusItemImage.h"
#import "NSImage+KYAStatusItemImage.h"

NSNotificationName const KYAStatusItemImageProviderDidChangeNotification = @"KYAStatusItemImageProviderDidChangeNotification";

@implementation KYAStatusItemImageProvider

+ (KYAStatusItemImageProvider *)currentProvider
{
    static KYAStatusItemImageProvider *provider;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        provider = [self new];
    });

    return provider;
}

+ (KYAStatusItemImageProvider *)standardProvider
{
    static KYAStatusItemImageProvider *provider;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        provider = [[self alloc] initWithActiveIconName:NSImage.kya_defaultActiveIconImage
                                       inactiveIconName:NSImage.kya_defaultInactiveIconImage];
    });

    return provider;
}

+ (KYAStatusItemImageProvider *)customProvider
{
    if(KYACustomIconImageFilesExist() == NO)
    {
        return nil;
    }

    return [[self alloc] initWithActiveIconName:NSImage.kya_customActiveIconImage
                               inactiveIconName:NSImage.kya_customInactiveIconImage];
}

#pragma mark -

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [self reloadFromDefaults];
    }
    return self;
}

- (instancetype)initWithActiveIconName:(NSImage *)activeIcon inactiveIconName:(NSImage *)inactiveIcon
{
    NSParameterAssert(activeIcon);
    NSParameterAssert(inactiveIcon);

    self = [super init];
    if(self)
    {
        self.activeIconImage = activeIcon;
        self.inactiveIconImage = inactiveIcon;
    }
    return self;
}

- (void)reloadFromDefaults
{
    Auto defaults = NSUserDefaults.standardUserDefaults;

    NSImage *activeImage = [self customImageForFilename:defaults.kya_menuBarActiveCustomIconFile];
    if(activeImage == nil)
    {
        activeImage = [self imageForStyle:[KYAMenuBarIconStyle activeStyleForIdentifier:defaults.kya_menuBarActiveIconStyle]
                                 isActive:YES];
    }
    self.activeIconImage = activeImage;

    NSImage *inactiveImage = [self customImageForFilename:defaults.kya_menuBarInactiveCustomIconFile];
    if(inactiveImage == nil)
    {
        inactiveImage = [self imageForStyle:[KYAMenuBarIconStyle inactiveStyleForIdentifier:defaults.kya_menuBarInactiveIconStyle]
                                   isActive:NO];
    }
    self.inactiveIconImage = inactiveImage;

    [NSNotificationCenter.defaultCenter postNotificationName:KYAStatusItemImageProviderDidChangeNotification
                                                      object:self];
}

- (nullable NSImage *)customImageForFilename:(nullable NSString *)filename
{
    if(filename.length == 0) { return nil; }
    Auto url = [NSURL.kya_documentsDirectoryURL URLByAppendingPathComponent:filename];
    if(![NSFileManager.defaultManager fileExistsAtPath:url.path]) { return nil; }

    NSImage *image = [[NSImage alloc] initWithContentsOfURL:url];
    if(image == nil) { return nil; }

    // Scale down to roughly menu-bar size while preserving aspect ratio.
    NSSize size = image.size;
    const CGFloat target = 18.0;
    if(size.width > 0 && size.height > 0)
    {
        CGFloat longSide = MAX(size.width, size.height);
        if(longSide > target)
        {
            CGFloat scale = target / longSide;
            image.size = NSMakeSize(size.width * scale, size.height * scale);
        }
    }
    image.template = YES;
    return image;
}

- (NSImage *)imageForStyle:(KYAMenuBarIconStyle *)style isActive:(BOOL)isActive
{
    // A "default" style (or unknown) falls back to the asset pipeline,
    // which also honours user-dropped custom icons in Documents/.
    if(style.symbolName == nil)
    {
        return [self defaultImageForActive:isActive];
    }

    if(@available(macOS 11.0, *))
    {
        NSImage *image = [NSImage imageWithSystemSymbolName:style.symbolName
                                   accessibilityDescription:style.displayName];
        image.template = YES;
        return image;
    }

    return [self defaultImageForActive:isActive];
}

- (NSImage *)defaultImageForActive:(BOOL)isActive
{
    if(KYACustomIconImageFilesExist())
    {
        return isActive ? NSImage.kya_customActiveIconImage : NSImage.kya_customInactiveIconImage;
    }
    return isActive ? NSImage.kya_defaultActiveIconImage : NSImage.kya_defaultInactiveIconImage;
}

@end
