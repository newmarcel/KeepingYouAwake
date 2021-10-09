//
//  KYAAppUpdater.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 26.09.21.
//  Copyright © 2021 Marcel Dierkes. All rights reserved.
//

#import "KYAAppUpdater.h"
#import "KYADefines.h"

#if KYA_APP_UPDATER_ENABLED

#import <Sparkle/Sparkle.h>

static NSString * const KYAAppUpdaterReleaseFeedURLString = @"https://newmarcel.github.io/KeepingYouAwake/appcast.xml";
static NSString * const KYAAppUpdaterPreReleaseFeedURLString = @"https://newmarcel.github.io/KeepingYouAwake/prerelease-appcast.xml";

@interface KYAAppUpdater () <SPUUpdaterDelegate>
@property (nonatomic) SPUStandardUpdaterController *updaterController;
@end

@implementation KYAAppUpdater

+ (KYAAppUpdater *)defaultAppUpdater
{
    static dispatch_once_t once;
    static KYAAppUpdater *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.updaterController = [[SPUStandardUpdaterController alloc] initWithUpdaterDelegate:self
                                                                            userDriverDelegate:nil];
    }
    return self;
}

- (SPUUpdater *)updater
{
    return self.updaterController.updater;
}

- (void)checkForUpdates:(id)sender
{
    [self.updaterController checkForUpdates:sender];
}

#pragma mark - SPUUpdaterDelegate

- (NSString *)feedURLStringForUpdater:(SPUUpdater *)updater
{
    Auto defaults = NSUserDefaults.standardUserDefaults;
    if([defaults kya_arePreReleaseUpdatesEnabled])
    {
        return KYAAppUpdaterPreReleaseFeedURLString;
    }
    else
    {
        return KYAAppUpdaterReleaseFeedURLString;
    }
}

@end

#endif
