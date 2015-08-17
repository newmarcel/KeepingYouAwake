//
//  KYAMenuBarIcon.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 17.08.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import "KYAMenuBarIcon.h"

NSString * const KYAMenubarActiveIconName = @"ActiveIcon";
NSString * const KYAMenubarInactiveIconName = @"InactiveIcon";

@interface KYAMenuBarIcon ()
@property (nonatomic, readwrite, null_resettable) NSImage *activeIcon;
@property (nonatomic, readwrite, null_resettable) NSImage *inactiveIcon;
@end

@implementation KYAMenuBarIcon

+ (instancetype)currentIcon
{
    if([self hasCustomIcons])
    {
        id activeIcon = [self customActiveIcon];
        id inactiveIcon = [self customInactiveIcon];
        return [[self alloc] initWithActiveIcon:activeIcon inactiveIcon:inactiveIcon];
    }
    else
    {
        // There are no costum image files, fall back to the default icon.
        return [self defaultIcon];
    }
}

+ (instancetype)defaultIcon
{
    return [self new];
}

#pragma mark -

- (instancetype)initWithActiveIcon:(NSImage *)activeIcon inactiveIcon:(NSImage *)inactiveIcon
{
    self = [super init];
    if(self)
    {
        self.activeIcon = activeIcon;
        self.inactiveIcon = inactiveIcon;
    }
    return self;
}

/**
 *  Convenience initializer for the default menubar icon.
 *
 *  @return A KYAMenuBarIcon instance.
 */
- (instancetype)init
{
    return [self initWithActiveIcon:nil inactiveIcon:nil];
}

#pragma mark - Resettable Setters

- (void)setActiveIcon:(NSImage *)activeIcon
{
    [self willChangeValueForKey:@"activeIcon"];
    if(activeIcon)
    {
        _activeIcon = activeIcon;
    }
    else
    {
        _activeIcon = [NSImage imageNamed:KYAMenubarActiveIconName];
    }
    [self didChangeValueForKey:@"activeIcon"];
}

- (void)setInactiveIcon:(NSImage *)inactiveIcon
{
    [self willChangeValueForKey:@"inactiveIcon"];
    if(inactiveIcon)
    {
        _inactiveIcon = inactiveIcon;
    }
    else
    {
        _inactiveIcon = [NSImage imageNamed:KYAMenubarInactiveIconName];
    }
    [self didChangeValueForKey:@"inactiveIcon"];
}

#pragma mark - Private Helper Methods

+ (nonnull NSURL *)applicationSupportDirectoryURL
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask].lastObject;
    return [appSupportURL URLByAppendingPathComponent:@"KeepingYouAwake"];
}

+ (BOOL)hasCustomIcons
{
    BOOL hasAllImageFiles = YES;
    
    if(![self iconWithNameExistsAtPath:KYAMenubarActiveIconName isRetinaIcon:NO])
    {
        hasAllImageFiles = NO;
    }
    if(![self iconWithNameExistsAtPath:KYAMenubarActiveIconName isRetinaIcon:YES])
    {
        hasAllImageFiles = NO;
    }
    if(![self iconWithNameExistsAtPath:KYAMenubarInactiveIconName isRetinaIcon:NO])
    {
        hasAllImageFiles = NO;
    }
    if(![self iconWithNameExistsAtPath:KYAMenubarInactiveIconName isRetinaIcon:YES])
    {
        hasAllImageFiles = NO;
    }
    
    return hasAllImageFiles;
}

+ (BOOL)iconWithNameExistsAtPath:(NSString *)name isRetinaIcon:(BOOL)isRetinaIcon
{
    NSURL *fileURL = [self iconFileURLWithName:name isRetinaIcon:isRetinaIcon];
    return [[NSFileManager defaultManager] fileExistsAtPath:fileURL.path];
}

+ (NSURL *)iconFileURLWithName:(NSString *)name isRetinaIcon:(BOOL)isRetinaIcon
{
    NSString *suffix = isRetinaIcon ? @"@2x" : @"";
    NSString *composedName = [NSString stringWithFormat:@"%@%@.png", name, suffix];
    return [[self applicationSupportDirectoryURL] URLByAppendingPathComponent:composedName];
}

+ (NSImage *)customActiveIcon
{
    return [self customIconNamed:KYAMenubarActiveIconName];
}

+ (NSImage *)customInactiveIcon
{
    return [self customIconNamed:KYAMenubarInactiveIconName];
}

+ (NSImage *)customIconNamed:(NSString *)name
{
    NSImage *image = [[NSImage alloc] initWithContentsOfURL:[self iconFileURLWithName:name
                                                                         isRetinaIcon:NO]];
    NSImageRep *retinaRep = [NSImageRep imageRepWithContentsOfURL:[self iconFileURLWithName:name
                                                                               isRetinaIcon:YES]];
    if(retinaRep)
    {
        [image addRepresentation:retinaRep];
    }
    
    return image;
}

@end
