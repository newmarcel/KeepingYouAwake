//
//  KYASettingsWindow.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 18.06.23.
//  Copyright © 2023 Marcel Dierkes. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

/// Shows and manages app settings
@interface KYASettingsWindow : NSWindow

+ (instancetype)windowWithContentViewController:(NSViewController *)contentViewController NS_UNAVAILABLE;
- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)backingStoreType defer:(BOOL)flag NS_UNAVAILABLE;
- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)backingStoreType defer:(BOOL)flag screen:(nullable NSScreen *)screen NS_UNAVAILABLE;
- (NSWindow *)initWithWindowRef:(void *)windowRef NS_UNAVAILABLE;

- (instancetype)init;

/// Instantiates a new settings window and inserts the provided additional
/// `tabViewItems` at a pre-defined position besides the default items.
/// - Parameter tabViewItems: Additional tab view items
- (instancetype)initWithAdditionalTabViewItems:(nullable NSArray<NSTabViewItem *> *)tabViewItems NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
