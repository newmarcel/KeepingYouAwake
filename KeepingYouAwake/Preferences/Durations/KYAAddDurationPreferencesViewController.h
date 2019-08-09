//
//  KYAAddDurationPreferencesViewController.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 08.08.19.
//  Copyright © 2019 Marcel Dierkes. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYAAddDurationPreferencesViewController : NSViewController
@property (weak, nonatomic) IBOutlet NSTextField *hoursTextField;
@property (weak, nonatomic) IBOutlet NSTextField *minutesTextField;
@property (weak, nonatomic) IBOutlet NSTextField *secondsTextField;
@property (weak, nonatomic) IBOutlet NSTextField *warningLabel;
@property (weak, nonatomic) IBOutlet NSButton *addButton;

- (IBAction)addDuration:(nullable id)sender;

@end

NS_ASSUME_NONNULL_END
