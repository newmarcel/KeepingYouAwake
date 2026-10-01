//
//  KYAActivateUntilDateWindowController.h
//  KeepingYouAwake
//
//  Created by Austin Taylor on 30.09.26.
//  Copyright © 2026 Marcel Dierkes. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

/// A small panel that asks for a one-off date and time and reports it back.
/// Nothing is stored; the caller activates the sleep wake timer with the
/// resulting date.
@interface KYAActivateUntilDateWindowController : NSWindowController

/// Called with the chosen date when the user confirms. Not called on cancel.
@property (copy, nonatomic, nullable) void (^completionHandler)(NSDate *endDate);

- (instancetype)init;

/// Resets the picker to the next full hour and brings the panel to the front.
- (void)showPanel;

@end

NS_ASSUME_NONNULL_END
