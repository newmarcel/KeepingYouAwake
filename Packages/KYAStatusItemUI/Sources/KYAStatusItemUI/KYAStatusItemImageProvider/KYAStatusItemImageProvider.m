//
//  KYAStatusItemImageProvider.m
//  KYAStatusItemUI
//
//  Created by Marcel Dierkes on 17.08.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import "KYAStatusItemImageProvider+Private.h"
#import "../KYADefines.h"
#import "NSURL+KYAStatusItemImage.h"
#import "NSImage+KYAStatusItemImage.h"

@implementation KYAStatusItemImageProvider

+ (KYAStatusItemImageProvider *)currentProvider
{
    static KYAStatusItemImageProvider *provider;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        provider = self.customProvider ?: self.standardProvider;
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
    static KYAStatusItemImageProvider *provider;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if(KYACustomIconImageFilesExist() == NO)
        {
            provider = nil;
            return;
        }
        
        provider = [[self alloc] initWithActiveIconName:NSImage.kya_customActiveIconImage
                                       inactiveIconName:NSImage.kya_customInactiveIconImage];
    });
    
    return provider;
}

#pragma mark -

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

@end
