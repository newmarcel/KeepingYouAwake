//
//  KYAIconSettingsViewController.h
//  KYAStatusItemUI
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

/// Settings view that lets the user pick a style for the active and
/// inactive menu bar icons.
@interface KYAIconSettingsViewController : NSViewController

/// A tab view item wrapping the controller, ready to be inserted into
/// the Settings tab view controller.
@property (class, nonatomic, readonly) NSTabViewItem *preferredTabViewItem;

@end

NS_ASSUME_NONNULL_END
