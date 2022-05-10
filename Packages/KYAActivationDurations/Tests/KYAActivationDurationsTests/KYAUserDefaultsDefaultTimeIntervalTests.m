//
//  KYAUserDefaultsDefaultTimeIntervalTests.m
//  KYAActivationDurationsTests
//
//  Created by Marcel Dierkes on 08.05.22.
//

#import <XCTest/XCTest.h>
#import <KYAActivationDurations/KYAActivationDurations.h>
#import "../../Sources/KYAActivationDurations/KYADefines.h"

@interface KYAUserDefaultsDefaultTimeIntervalTests : XCTestCase
@end

@implementation KYAUserDefaultsDefaultTimeIntervalTests

- (void)setUp
{
    [super setUp];
    
    Auto userDefaults = NSUserDefaults.standardUserDefaults;
    [userDefaults removeObjectForKey:KYAUserDefaultsKeyDefaultTimeInterval];
}

- (void)testDefaultTimeInterval
{
    Auto userDefaults = NSUserDefaults.standardUserDefaults;
    XCTAssertEqual(userDefaults.kya_defaultTimeInterval, 0.0f);
    
    userDefaults.kya_defaultTimeInterval = 18000.0f;
    XCTAssertEqual(userDefaults.kya_defaultTimeInterval, 18000.0f);
    
    // Test the decimal cut-off:
    userDefaults.kya_defaultTimeInterval = 432.5f;
    XCTAssertEqual(userDefaults.kya_defaultTimeInterval, 432.0f);
    
    userDefaults.kya_defaultTimeInterval = 0.0f;
    XCTAssertEqual(userDefaults.kya_defaultTimeInterval, 0.0f);
}

- (void)testDefaultTimeIntervalKeys
{
    Auto userDefaults = NSUserDefaults.standardUserDefaults;
    XCTAssertEqual(userDefaults.kya_defaultTimeInterval, 0.0f);
    XCTAssertEqual([userDefaults doubleForKey:KYAUserDefaultsKeyDefaultTimeInterval], 0.0f);
    
    userDefaults.kya_defaultTimeInterval = 18000.0f;
    XCTAssertEqual([userDefaults doubleForKey:KYAUserDefaultsKeyDefaultTimeInterval],
                   18000.0f);
    
    // Test the decimal cut-off:
    [userDefaults setObject:@432.5f forKey:KYAUserDefaultsKeyDefaultTimeInterval];
    XCTAssertEqual(userDefaults.kya_defaultTimeInterval, 432.0f);
    
    [userDefaults removeObjectForKey:KYAUserDefaultsKeyDefaultTimeInterval];
    XCTAssertEqual(userDefaults.kya_defaultTimeInterval, 0.0f);
}

@end
