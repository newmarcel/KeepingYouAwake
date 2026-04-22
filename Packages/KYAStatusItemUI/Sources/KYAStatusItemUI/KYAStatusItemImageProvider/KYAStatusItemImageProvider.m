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
    NSString *activeID = defaults.kya_menuBarActiveIconStyle;
    NSString *inactiveID = defaults.kya_menuBarInactiveIconStyle;

    self.activeIconImage = [self imageForStyle:[KYAMenuBarIconStyle activeStyleForIdentifier:activeID]
                                      isActive:YES];
    self.inactiveIconImage = [self imageForStyle:[KYAMenuBarIconStyle inactiveStyleForIdentifier:inactiveID]
                                        isActive:NO];

    [NSNotificationCenter.defaultCenter postNotificationName:KYAStatusItemImageProviderDidChangeNotification
                                                      object:self];
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
