//
//  KYAUserDefaultsDefaultTimeIntervalTests.m
//  KYAActivationDurationsTests
//
//  Created by Marcel Dierkes on 08.05.22.
//

#import <XCTest/XCTest.h>
#import <KYACommon/KYACommon.h>
#import <KYAActivationDurations/KYAActivationDurations.h>

@interface KYAUserDefaultsDefaultTimeIntervalTests : XCTestCase
@end

@implementation KYAUserDefaultsDefaultTimeIntervalTests

- (void)setUp
{
    [super setUp];
    
    Auto userDefaults = NSUserDefaults.standardUserDefaults;
    [userDefaults removeObjectForKey:KYAUserDefaultsKeyDefaultTimeInterval];
    [userDefaults removeObjectForKey:KYAUserDefaultsKeyDefaultClockTimeSeconds];
}

- (void)testDefaultClockTimeSeconds
{
    Auto userDefaults = NSUserDefaults.standardUserDefaults;
    XCTAssertEqual(userDefaults.kya_defaultClockTimeSeconds, KYADefaultClockTimeSecondsNone);
    
    userDefaults.kya_defaultClockTimeSeconds = 61200;
    XCTAssertEqual(userDefaults.kya_defaultClockTimeSeconds, 61200);
    XCTAssertEqual([userDefaults integerForKey:KYAUserDefaultsKeyDefaultClockTimeSeconds], 61200);
    
    // Midnight is a valid clock time and must not read as "none"
    userDefaults.kya_defaultClockTimeSeconds = 0;
    XCTAssertEqual(userDefaults.kya_defaultClockTimeSeconds, 0);
    
    userDefaults.kya_defaultClockTimeSeconds = KYADefaultClockTimeSecondsNone;
    XCTAssertNil([userDefaults objectForKey:KYAUserDefaultsKeyDefaultClockTimeSeconds]);
    XCTAssertEqual(userDefaults.kya_defaultClockTimeSeconds, KYADefaultClockTimeSecondsNone);
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
