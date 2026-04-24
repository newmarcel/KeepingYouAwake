//
//  KYAAboutSettingsViewController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 18.12.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import "KYAAboutSettingsViewController.h"
#import "KYALocalizedStrings.h"

static NSString * const KYARepositoryURLString = @"https://github.com/joyjeet-sarkar/KeepingYouAwake";

@interface KYAAboutSettingsViewController ()
@end

@implementation KYAAboutSettingsViewController

+ (NSImage *)tabViewItemImage
{
    if(@available(macOS 11.0, *))
    {
        return [NSImage imageWithSystemSymbolName:@"info.circle"
                         accessibilityDescription:nil];
    }
    else
    {
        return [NSImage imageNamed:NSImageNameInfo];
    }
}

+ (NSString *)preferredTitle
{
    return KYA_SETTINGS_L10N_ABOUT;
}

#pragma mark - Bindings

- (NSString *)versionText
{
    return [NSString localizedStringWithFormat:@"%@ %@",
            KYA_L10N_VERSION,
            NSBundle.mainBundle.kya_fullVersionString];
}

- (NSString *)copyrightText
{
    return NSBundle.mainBundle.kya_localizedCopyrightString;
}

- (NSURL *)repositoryURL
{
    return [NSURL URLWithString:KYARepositoryURLString];
}

- (id)creditsFileURL
{
    return [NSBundle.mainBundle URLForResource:@"Credits" withExtension:@"rtf"];
}

- (BOOL)isEditable
{
    return NO;
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self installRepositoryLinkLabel];
}

- (void)installRepositoryLinkLabel
{
    NSView *root = self.view;
    NSView *copyrightContainer = [self bottommostContainerInView:root];
    if(copyrightContainer == nil) { return; }

    NSString *displayText = [KYARepositoryURLString stringByReplacingOccurrencesOfString:@"https://" withString:@""];
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:displayText];
    NSRange range = NSMakeRange(0, displayText.length);
    [attributed addAttribute:NSLinkAttributeName value:self.repositoryURL range:range];
    [attributed addAttribute:NSFontAttributeName
                       value:[NSFont systemFontOfSize:NSFont.smallSystemFontSize]
                       range:range];

    NSTextField *linkField = [NSTextField labelWithAttributedString:attributed];
    linkField.translatesAutoresizingMaskIntoConstraints = NO;
    linkField.allowsEditingTextAttributes = YES;
    linkField.selectable = YES;
    linkField.alignment = NSTextAlignmentCenter;
    [root addSubview:linkField];

    [NSLayoutConstraint activateConstraints:@[
        [linkField.centerXAnchor constraintEqualToAnchor:root.centerXAnchor],
        [linkField.bottomAnchor constraintEqualToAnchor:copyrightContainer.topAnchor constant:-4],
    ]];
}

- (nullable NSView *)bottommostContainerInView:(NSView *)parent
{
    NSView *bottom = nil;
    CGFloat minY = CGFLOAT_MAX;
    for(NSView *subview in parent.subviews)
    {
        if(subview.frame.origin.y < minY)
        {
            minY = subview.frame.origin.y;
            bottom = subview;
        }
    }
    return bottom;
}

@end
