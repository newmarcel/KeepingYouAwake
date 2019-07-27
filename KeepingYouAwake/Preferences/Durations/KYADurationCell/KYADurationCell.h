//
//  KYADurationCell.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 27.07.19.
//  Copyright © 2019 Marcel Dierkes. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYADurationCell : NSTableCellView
@property (weak, nonatomic) IBOutlet NSTextField *textLabel;

+ (void)registerInTableView:(NSTableView *)tableView;
+ (instancetype)dequeueFromTableView:(NSTableView *)tableView
                               owner:(nullable id)owner;

@end

NS_ASSUME_NONNULL_END
