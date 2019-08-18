//
//  KYADurationCell.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 27.07.19.
//  Copyright © 2019 Marcel Dierkes. All rights reserved.
//

#import "KYADurationCell.h"
#import "KYADefines.h"
#import "KYALocalizedStrings.h"

@implementation KYADurationCell

+ (NSUserInterfaceItemIdentifier)identifier
{
    return (NSUserInterfaceItemIdentifier)NSStringFromClass(self);
}

+ (void)registerInTableView:(NSTableView *)tableView
{
    NSParameterAssert(tableView);
    
    KYA_AUTO identifier = [self identifier];
    KYA_AUTO bundle = [NSBundle bundleForClass:self];
    KYA_AUTO nib = [[NSNib alloc] initWithNibNamed:identifier bundle:bundle];
    [tableView registerNib:nib forIdentifier:identifier];
}

+ (instancetype)dequeueFromTableView:(NSTableView *)tableView owner:(id)owner
{
    NSParameterAssert(tableView);
    
    return [tableView makeViewWithIdentifier:[self identifier] owner:owner];
}

#pragma mark - Life Cycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.defaultLabel.stringValue = KYA_L10N_DEFAULT;
}

#pragma mark - Default Duration

- (void)setIsDefaultDuration:(BOOL)isDefaultDuration
{
    self.defaultLabel.hidden = !isDefaultDuration;
    
    CGFloat size = self.textLabel.font.pointSize;
    NSFontWeight weight = isDefaultDuration ? NSFontWeightSemibold : NSFontWeightRegular;
    self.textLabel.font = [NSFont monospacedDigitSystemFontOfSize:size weight:weight];
}

- (BOOL)isDefaultDuration
{
    return ![self.defaultLabel isHidden];
}

@end
