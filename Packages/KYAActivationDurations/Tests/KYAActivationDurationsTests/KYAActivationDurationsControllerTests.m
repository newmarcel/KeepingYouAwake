//
//  KYAActivationDurationsControllerTests.m
//  KYAActivationDurationsTests
//
//  Created by Marcel Dierkes on 08.05.22.
//

#import <XCTest/XCTest.h>
#import <KYACommon/KYACommon.h>
#import <KYAActivationDurations/KYAActivationDurations.h>

@interface KYAActivationDurationsControllerTests : XCTestCase
@property (nonatomic) KYAActivationDurationsController *controller;
@end

@implementation KYAActivationDurationsControllerTests

- (void)setUp
{
    [super setUp];
    
    Auto defaults = NSUserDefaults.standardUserDefaults;
    self.controller = [[KYAActivationDurationsController alloc] initWithUserDefaults:defaults];
    [self.controller resetActivationDurations];
    self.controller.defaultActivationDuration = KYAActivationDuration.indefiniteActivationDuration;
}

- (void)testSharedController
{
    XCTAssertEqual(KYAActivationDurationsController.sharedController, KYAActivationDurationsController.sharedController);
    XCTAssertEqualObjects(KYAActivationDurationsController.sharedController, KYAActivationDurationsController.sharedController);
    XCTAssertNotEqual(KYAActivationDurationsController.sharedController, self.controller);
    XCTAssertNotEqualObjects(KYAActivationDurationsController.sharedController, self.controller);
}

- (void)testInitializer
{
    Auto controller = self.controller;
    XCTAssertNotNil(controller);
    XCTAssertEqual(controller.userDefaults, NSUserDefaults.standardUserDefaults);
    XCTAssertEqualObjects(controller.defaultActivationDuration, KYAActivationDuration.indefiniteActivationDuration);
    
    Auto expectedDurations = [NSMutableArray<KYAActivationDuration *>
                              arrayWithObject:KYAActivationDuration.indefiniteActivationDuration];
    [expectedDurations addObjectsFromArray:KYAActivationDuration.defaultActivationDurations];
    XCTAssertEqualObjects(controller.activationDurations, expectedDurations);
}

- (void)testDefaultActivationDuration
{
    Auto controller = self.controller;
    
    Auto newDefault = controller.activationDurations[2];
    controller.defaultActivationDuration = newDefault;
    XCTAssertEqualObjects(controller.defaultActivationDuration, newDefault);
}

- (void)testAddAndRemoveActivationDuration
{
    Auto controller = self.controller;
    
    Auto newDuration = [[KYAActivationDuration alloc] initWithSeconds:1986.0f];
    XCTAssertTrue([controller addActivationDuration:newDuration]);
    XCTAssertTrue([controller.activationDurations containsObject:newDuration]);
    
    Auto duplicateDuration = [[KYAActivationDuration alloc] initWithSeconds:1986.0f];
    XCTAssertFalse([controller addActivationDuration:duplicateDuration]);
    
    Auto notAddedDuration = [[KYAActivationDuration alloc] initWithSeconds:2063.0f];
    XCTAssertFalse([controller.activationDurations containsObject:notAddedDuration]);
    XCTAssertFalse([controller removeActivationDuration:notAddedDuration]);
    
    [controller addActivationDuration:notAddedDuration];
    XCTAssertTrue([controller removeActivationDuration:notAddedDuration]);
}

- (void)testRemoveActivationDurationAtIndex
{
    Auto controller = self.controller;
    
    Auto count = controller.activationDurations.count;
    for(NSInteger i = 0; i < count; i++)
    {
        if(i == 0)
        {
            // The indefinite duration cannot be removed
            XCTAssertFalse([controller removeActivationDurationAtIndex:0]);
            continue;
        }
        XCTAssertTrue([controller removeActivationDurationAtIndex:1]);
    }
    XCTAssertEqual(controller.activationDurations.count, 1);
    
    // Out of bounds
    XCTAssertFalse([controller removeActivationDurationAtIndex:2063]);
}

- (void)testSetActivationDurationAsDefaultAtIndex
{
    Auto controller = self.controller;
    XCTAssertEqualObjects(controller.defaultActivationDuration, KYAActivationDuration.indefiniteActivationDuration);
    
    Auto secondDuration = controller.activationDurations[2];
    [controller setActivationDurationAsDefaultAtIndex:2];
    XCTAssertEqualObjects(controller.defaultActivationDuration, secondDuration);
    
    // Out of bounds
    [controller setActivationDurationAsDefaultAtIndex:2063];
    XCTAssertEqualObjects(controller.defaultActivationDuration, secondDuration);
}

- (void)testResetActivationDurations
{
    Auto controller = self.controller;
    XCTAssertEqual(self.controller.activationDurations.count, 8);
    
    [controller removeActivationDurationAtIndex:1];
    [controller removeActivationDurationAtIndex:1];
    [controller removeActivationDurationAtIndex:1];
    
    Auto duration = [[KYAActivationDuration alloc] initWithSeconds:1986.0f];
    [controller addActivationDuration:duration];
    
    XCTAssertEqual(self.controller.activationDurations.count, 6);
    
    [controller resetActivationDurations];
    Auto expectedDurations = [NSMutableArray<KYAActivationDuration *>
                              arrayWithObject:KYAActivationDuration.indefiniteActivationDuration];
    [expectedDurations addObjectsFromArray:KYAActivationDuration.defaultActivationDurations];
    XCTAssertEqualObjects(controller.activationDurations, expectedDurations);
}

- (void)testDidChangeNotification
{
    Auto controller = self.controller;
    
    Auto addExpectation = [[XCTNSNotificationExpectation alloc] initWithName:KYAActivationDurationsDidChangeNotification
                                                                      object:controller];
    Auto newDuration = [[KYAActivationDuration alloc] initWithSeconds:1986.0f];
    XCTAssertTrue([controller addActivationDuration:newDuration]);
    XCTAssertTrue([controller.activationDurations containsObject:newDuration]);
    [self waitForExpectations:@[addExpectation] timeout:5.0f];
    
    Auto defaultExpectation = [[XCTNSNotificationExpectation alloc] initWithName:KYAActivationDurationsDidChangeNotification
                                                                         object:controller];
    controller.defaultActivationDuration = newDuration;
    [self waitForExpectations:@[defaultExpectation] timeout:5.0f];
    
    Auto removeExpectation = [[XCTNSNotificationExpectation alloc] initWithName:KYAActivationDurationsDidChangeNotification
                                                                         object:controller];
    [controller removeActivationDuration:newDuration];
    [self waitForExpectations:@[removeExpectation] timeout:5.0f];
    
    Auto resetExpectation = [[XCTNSNotificationExpectation alloc] initWithName:KYAActivationDurationsDidChangeNotification
                                                                         object:controller];
    [controller resetActivationDurations];
    [self waitForExpectations:@[resetExpectation] timeout:5.0f];
}

#pragma mark - Clock Time

- (void)testClockTimesSortAfterFixedDurationsByTimeOfDay
{
    Auto controller = self.controller;
    Auto calendar = NSCalendar.currentCalendar;
    Auto now = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[NSDate date]];
    
    NSInteger soonMinute = (now.hour * 60 + now.minute + 1) % (24 * 60);
    Auto soon = [[KYAActivationDuration alloc] initWithClockTimeHour:soonMinute / 60 minute:soonMinute % 60];
    NSInteger laterMinute = (soonMinute + 12 * 60) % (24 * 60);
    Auto later = [[KYAActivationDuration alloc] initWithClockTimeHour:laterMinute / 60 minute:laterMinute % 60];
    [controller addActivationDuration:later];
    [controller addActivationDuration:soon];
    
    Auto durations = controller.activationDurations;
    NSUInteger fixedCount = durations.count - 2;
    for(NSUInteger i = 0; i < fixedCount; i++)
    {
        XCTAssertFalse(durations[i].isClockTime);
    }
    XCTAssertTrue(durations[fixedCount].isClockTime);
    XCTAssertTrue(durations[fixedCount + 1].isClockTime);
    XCTAssertLessThan(durations[fixedCount].clockTimeSeconds, durations[fixedCount + 1].clockTimeSeconds);
}

- (void)testClockTimeDurationPersistsAndCanBeDefault
{
    Auto controller = self.controller;
    Auto five = [[KYAActivationDuration alloc] initWithClockTimeHour:18 minute:30];
    XCTAssertTrue([controller addActivationDuration:five]);
    XCTAssertFalse([controller addActivationDuration:five]);
    XCTAssertTrue([controller.activationDurations containsObject:five]);
    
    controller.defaultActivationDuration = five;
    XCTAssertEqualObjects(controller.defaultActivationDuration, five);
    XCTAssertEqual(controller.userDefaults.kya_defaultClockTimeSeconds, 18 * 60 * 60 + 30 * 60);
    
    Auto reloaded = [[KYAActivationDurationsController alloc] initWithUserDefaults:controller.userDefaults];
    XCTAssertTrue([reloaded.activationDurations containsObject:five]);
    XCTAssertEqualObjects(reloaded.defaultActivationDuration, five);
    XCTAssertTrue(reloaded.defaultActivationDuration.isClockTime);
    
    Auto fixed = reloaded.activationDurations[1];
    XCTAssertFalse(fixed.isClockTime);
    reloaded.defaultActivationDuration = fixed;
    XCTAssertEqual(reloaded.userDefaults.kya_defaultClockTimeSeconds, KYADefaultClockTimeSecondsNone);
    XCTAssertEqualObjects(reloaded.defaultActivationDuration, fixed);
    
    reloaded.defaultActivationDuration = five;
    XCTAssertTrue([reloaded removeActivationDuration:five]);
    XCTAssertFalse([reloaded.activationDurations containsObject:five]);
    XCTAssertEqualObjects(reloaded.defaultActivationDuration, KYAActivationDuration.indefiniteActivationDuration);
}

@end
