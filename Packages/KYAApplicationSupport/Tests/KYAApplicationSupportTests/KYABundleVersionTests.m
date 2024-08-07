//
//  KYABundleVersionTests.m
//  KYAApplicationSupportTests
//
//  Created by Marcel Dierkes on 11.05.22.
//

#import <XCTest/XCTest.h>
#import <KYACommon/KYACommon.h>
#import <KYAApplicationSupport/KYAApplicationSupport.h>

@interface KYABundleVersionTests : XCTestCase
@property (nonatomic) NSBundle *bundle;
@end

@implementation KYABundleVersionTests

- (void)setUp
{
    [super setUp];
    
    Auto parentBundle = SWIFTPM_MODULE_BUNDLE;
    Auto testBundleURL = [parentBundle URLForResource:@"TestBundle" withExtension:@"bundle"];
    self.bundle = [NSBundle bundleWithURL:testBundleURL];
}

- (void)testShortVersionString
{
    XCTAssertEqualObjects(self.bundle.kya_shortVersionString, @"1.2.3");
}

- (void)testBuildVersionString
{
    XCTAssertEqualObjects(self.bundle.kya_buildVersionString, @"1020301");
}

- (void)testFullVersionString
{
    XCTAssertEqualObjects(self.bundle.kya_fullVersionString, @"1.2.3 (1020301)");
}

- (void)testLocalizedCopyrightString
{
    XCTAssertEqualObjects(self.bundle.kya_localizedCopyrightString, @"A human-readable copyright.");
}

@end
