//
//  KYADurationCell.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 27.07.19.
//  Copyright © 2019 Marcel Dierkes. All rights reserved.
//

#import "KYADurationCell.h"
#import "KYADefines.h"

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

@end
