//
//  NSApplication+Versions.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 18.12.15.
//  Copyright © 2015 Marcel Dierkes. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSApplication (Versions)
@property (copy, nonatomic, readonly) NSString *kya_shortVersionString;
@property (copy, nonatomic, readonly) NSString *kya_buildVersionString;
@property (copy, nonatomic, readonly) NSString *kya_localizedVersionString;

@property (copy, nonatomic, readonly) NSString *kya_localizedCopyrightString;

@end

NS_ASSUME_NONNULL_END
