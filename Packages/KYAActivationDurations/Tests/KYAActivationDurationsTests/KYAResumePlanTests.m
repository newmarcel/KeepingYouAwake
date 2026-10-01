//
//  KYAResumePlanTests.m
//  KYAActivationDurationsTests
//
//  Created by Austin Taylor on 30.09.26.
//

#import <XCTest/XCTest.h>
#import <KYACommon/KYACommon.h>
#import <KYAActivationDurations/KYAActivationDurations.h>

@interface KYAResumePlanTests : XCTestCase
@end

@implementation KYAResumePlanTests

- (NSDate *)dateAtHour:(NSInteger)hour minute:(NSInteger)minute
{
    Auto calendar = NSCalendar.currentCalendar;
    return [calendar dateBySettingHour:hour minute:minute second:0 ofDate:[NSDate date] options:0];
}

- (void)testClockTimeResumesAsTheSameClockTimeWhileItsEndIsAhead
{
    Auto five = [[KYAActivationDuration alloc] initWithClockTimeHour:17 minute:0];
    Auto plan = [KYAResumePlan planForResumingDuration:five
                                              fireDate:[self dateAtHour:17 minute:0]
                                          timeInterval:8 * 60 * 60
                                                   now:[self dateAtHour:16 minute:30]];
    XCTAssertEqual(plan.action, KYAResumeActionActivationDuration);
    XCTAssertEqualObjects(plan.activationDuration, five);
}

- (void)testClockTimeStaysOffOnceItsEndHasPassed
{
    Auto five = [[KYAActivationDuration alloc] initWithClockTimeHour:17 minute:0];
    KYAResumePlan *plan = [KYAResumePlan planForResumingDuration:five
                                              fireDate:[self dateAtHour:17 minute:0]
                                          timeInterval:8 * 60 * 60
                                                   now:[self dateAtHour:18 minute:0]];
    XCTAssertEqual(plan.action, KYAResumeActionNone);
    
    plan = [KYAResumePlan planForResumingDuration:five
                                         fireDate:[self dateAtHour:17 minute:0]
                                     timeInterval:8 * 60 * 60
                                              now:[self dateAtHour:17 minute:0]];
    XCTAssertEqual(plan.action, KYAResumeActionNone);
}

- (void)testOneOffResumesUntilItsRecordedEnd
{
    Auto end = [self dateAtHour:21 minute:15];
    Auto plan = [KYAResumePlan planForResumingDuration:nil
                                              fireDate:end
                                          timeInterval:3 * 60 * 60
                                                   now:[self dateAtHour:20 minute:0]];
    XCTAssertEqual(plan.action, KYAResumeActionUntilDate);
    XCTAssertEqualObjects(plan.endDate, end);
}

- (void)testFixedDurationResumesUntilItsRecordedEndToo
{
    Auto oneHour = [[KYAActivationDuration alloc] initWithSeconds:3600];
    Auto end = [self dateAtHour:10 minute:0];
    KYAResumePlan *plan = [KYAResumePlan planForResumingDuration:oneHour
                                              fireDate:end
                                          timeInterval:3600
                                                   now:[self dateAtHour:9 minute:45]];
    XCTAssertEqual(plan.action, KYAResumeActionUntilDate);
    XCTAssertEqualObjects(plan.endDate, end);
    
    plan = [KYAResumePlan planForResumingDuration:oneHour
                                         fireDate:end
                                     timeInterval:3600
                                              now:[self dateAtHour:10 minute:1]];
    XCTAssertEqual(plan.action, KYAResumeActionNone);
}

- (void)testIndefiniteResumesIndefinitely
{
    Auto plan = [KYAResumePlan planForResumingDuration:KYAActivationDuration.indefiniteActivationDuration
                                              fireDate:nil
                                          timeInterval:KYAActivationDurationIndefinite
                                                   now:[NSDate date]];
    XCTAssertEqual(plan.action, KYAResumeActionTimeInterval);
    XCTAssertEqual(plan.timeInterval, KYAActivationDurationIndefinite);
}

- (void)testFixedDurationWithoutFireDateFallsBackToItsInterval
{
    Auto plan = [KYAResumePlan planForResumingDuration:nil
                                              fireDate:nil
                                          timeInterval:900
                                                   now:[NSDate date]];
    XCTAssertEqual(plan.action, KYAResumeActionTimeInterval);
    XCTAssertEqual(plan.timeInterval, 900);
}

@end
