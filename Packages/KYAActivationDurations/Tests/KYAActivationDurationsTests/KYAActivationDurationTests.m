//
//  KYAActivationDurationTests.m
//  KYAActivationDurationsTests
//
//  Created by Marcel Dierkes on 07.05.22.
//

#import <XCTest/XCTest.h>
#import <KYACommon/KYACommon.h>
#import <KYAActivationDurations/KYAActivationDurations.h>

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

#pragma mark - Clock Time

- (void)testClockTimeInitializerRejectsInvalidInput
{
    XCTAssertNil([[KYAActivationDuration alloc] initWithClockTimeSeconds:-1]);
    XCTAssertNil([[KYAActivationDuration alloc] initWithClockTimeSeconds:24 * 60 * 60]);
    XCTAssertNil([[KYAActivationDuration alloc] initWithClockTimeHour:24 minute:0]);
    XCTAssertNil([[KYAActivationDuration alloc] initWithClockTimeHour:17 minute:60]);
}

- (void)testClockTimeDurationEndsAtNextOccurrence
{
    Auto duration = [[KYAActivationDuration alloc] initWithClockTimeHour:17 minute:0];
    XCTAssertNotNil(duration);
    XCTAssertTrue(duration.isClockTime);
    XCTAssertEqual(duration.clockTimeSeconds, 17 * 60 * 60);
    
    Auto fireDate = duration.nextClockTimeDate;
    XCTAssertNotNil(fireDate);
    XCTAssertGreaterThan(fireDate.timeIntervalSinceNow, 0);
    XCTAssertLessThanOrEqual(fireDate.timeIntervalSinceNow, 24 * 60 * 60 + 1);
    
    Auto components = [NSCalendar.currentCalendar components:NSCalendarUnitHour | NSCalendarUnitMinute
                                                    fromDate:fireDate];
    XCTAssertEqual(components.hour, 17);
    XCTAssertEqual(components.minute, 0);
    
    XCTAssertGreaterThan(duration.seconds, KYAActivationDurationIndefinite);
    XCTAssertEqualWithAccuracy(duration.seconds, fireDate.timeIntervalSinceNow, 2.0);
}

- (void)testClockTimeEquality
{
    Auto five = [[KYAActivationDuration alloc] initWithClockTimeHour:17 minute:0];
    Auto fiveAgain = [[KYAActivationDuration alloc] initWithClockTimeSeconds:17 * 60 * 60];
    Auto six = [[KYAActivationDuration alloc] initWithClockTimeHour:18 minute:0];
    Auto fixed = [[KYAActivationDuration alloc] initWithSeconds:five.seconds];
    
    XCTAssertEqualObjects(five, fiveAgain);
    XCTAssertEqual(five.hash, fiveAgain.hash);
    XCTAssertNotEqualObjects(five, six);
    XCTAssertNotEqualObjects(five, fixed);
    XCTAssertFalse(fixed.isClockTime);
    XCTAssertEqual(fixed.clockTimeSeconds, -1);
}

- (void)testClockTimeSecureCoding
{
    Auto duration = [[KYAActivationDuration alloc] initWithClockTimeHour:17 minute:30];
    NSError *error;
    Auto data = [NSKeyedArchiver archivedDataWithRootObject:duration requiringSecureCoding:YES error:&error];
    XCTAssertNil(error);
    KYAActivationDuration *decoded = [NSKeyedUnarchiver unarchivedObjectOfClass:[KYAActivationDuration class]
                                                                       fromData:data
                                                                          error:&error];
    XCTAssertNil(error);
    XCTAssertEqualObjects(decoded, duration);
    XCTAssertTrue(decoded.isClockTime);
}

@end
