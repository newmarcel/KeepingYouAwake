//
//  KYAActivationDurationTests.m
//  KYAActivationDurationsTests
//
//  Created by Marcel Dierkes on 07.05.22.
//

#import <XCTest/XCTest.h>
#import <KYAActivationDurations/KYAActivationDurations.h>
#import "../../Sources/KYAActivationDurations/KYADefines.h"

@interface KYAActivationDurationTests : XCTestCase
@end

@implementation KYAActivationDurationTests

- (void)testIndefiniteActivationDuration
{
    Auto duration = KYAActivationDuration.indefiniteActivationDuration;
    XCTAssertEqual(duration.seconds, KYAActivationDurationIndefinite);
    XCTAssertEqualObjects(duration, KYAActivationDuration.indefiniteActivationDuration);
}

- (void)testSecondsInitializer
{
    NSTimeInterval expectedSeconds = 3400.0f;
    Auto duration = [[KYAActivationDuration alloc] initWithSeconds:expectedSeconds];
    XCTAssertEqual(duration.seconds, expectedSeconds);
}

- (void)testHoursMinutesSecondsInitializer
{
    NSTimeInterval expectedSeconds = 30615;
    Auto duration = [[KYAActivationDuration alloc] initWithHours:8 minutes:30 seconds:15];
    XCTAssertEqual(duration.seconds, expectedSeconds);
}

- (void)testEquatable
{
    NSTimeInterval expectedSeconds = 30615;
    XCTAssertEqualObjects([[KYAActivationDuration alloc] initWithSeconds:expectedSeconds],
                          [[KYAActivationDuration alloc] initWithSeconds:expectedSeconds]);
    XCTAssertTrue([[[KYAActivationDuration alloc] initWithSeconds:expectedSeconds]
                   isEqualToActivationDuration:[[KYAActivationDuration alloc]
                                                initWithSeconds:expectedSeconds]]);
    XCTAssertFalse([[[KYAActivationDuration alloc] initWithSeconds:expectedSeconds]
                   isEqualToActivationDuration:[[KYAActivationDuration alloc]
                                                initWithSeconds:0]]);
}

- (void)testArchiving
{
    NSTimeInterval expectedSeconds = 30615;
    Auto duration = [[KYAActivationDuration alloc] initWithSeconds:expectedSeconds];
    NSError *error;
    Auto data = [NSKeyedArchiver archivedDataWithRootObject:duration requiringSecureCoding:YES error:&error];
    XCTAssertNotNil(data);
    XCTAssertNil(error);
    
    Auto unarchivedDuration = (KYAActivationDuration *)[NSKeyedUnarchiver
                                                        unarchivedObjectOfClass:[KYAActivationDuration class]
                                                        fromData:data
                                                        error:&error];
    XCTAssertNotNil(unarchivedDuration);
    XCTAssertNil(error);
    XCTAssertEqualObjects(duration, unarchivedDuration);
}

- (void)testDefaultActivationDurations
{
    Auto durations = KYAActivationDuration.defaultActivationDurations;
    XCTAssertEqual(durations.count, 7);
    XCTAssertEqual(durations[0].seconds, 300.0f);
    XCTAssertEqual(durations[1].seconds, 600.0f);
    XCTAssertEqual(durations[2].seconds, 900.0f);
    XCTAssertEqual(durations[3].seconds, 1800.0f);
    XCTAssertEqual(durations[4].seconds, 3600.0f);
    XCTAssertEqual(durations[5].seconds, 7200.0f);
    XCTAssertEqual(durations[6].seconds, 18000.0f);
}

@end
