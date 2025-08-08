//
//  KYADisplayParameters.m
//  KYAApplicationSupport
//
//  Created by Marcel Dierkes on 16.12.24.
//  Copyright © 2024 Marcel Dierkes. All rights reserved.
//

#import <KYAApplicationSupport/KYADisplayParameters.h>
#import <KYACommon/KYACommon.h>
#import <CoreGraphics/CoreGraphics.h>

static const NSUInteger KYADisplayCountMax = 64u;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu-folding-constant"

NSUInteger KYADisplayParametersGetNumberOfExternalDisplays()
{
    CGDirectDisplayID displaysIDs[KYADisplayCountMax];
    uint32_t numberOfDisplays = 0;
    CGError result = CGGetActiveDisplayList(KYADisplayCountMax, displaysIDs, &numberOfDisplays);
    if(result != kCGErrorSuccess)
    {
        // Fall back to the NSScreen lookup
        return NSScreen.screens.count;
    }
    
    Auto displayIDs = [NSMutableSet<NSNumber *> new];
    
    for(NSUInteger i = 0; i < KYADisplayCountMax; i++)
    {
        CGDirectDisplayID display = displaysIDs[i];
        if(display == kCGNullDirectDisplay || CGDisplayPixelsWide(display) == 0 || CGDisplayPixelsWide(display) == 1)
        {
            continue;
        }
        
        if([displayIDs containsObject:@(display)])
        {
            continue;
        }
        
        BOOL isMain = CGDisplayIsMain(display);
        if(isMain == YES)
        {
            continue;
        }
        
        [displayIDs addObject:@(display)];
    }
    
    return displayIDs.count;
}

#pragma clang diagnostic pop
