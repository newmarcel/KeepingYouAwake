//
//  KYAEventTests.m
//  KYAApplicationEventsTests
//
//  Created by Marcel Dierkes on 09.05.22.
//

#import <XCTest/XCTest.h>
#import <KYACommon/KYACommon.h>
#import <KYAApplicationEvents/KYAApplicationEvents.h>

@interface KYAEventTests : XCTestCase
@end

@implementation KYAEventTests

- (void)testInitializer
{
    Auto expectedName = @"EVENT_NAME";
    Auto expectedArguments = @{ @"KEY_1": @1, @"KEY_2": @YES };
    Auto event = [[KYAEvent alloc] initWithName:expectedName arguments:expectedArguments];
    XCTAssertEqualObjects(event.name, expectedName);
    XCTAssertEqualObjects(event.arguments, expectedArguments);
    
    Auto event2 = [[KYAEvent alloc] initWithName:expectedName arguments:nil];
    XCTAssertEqualObjects(event2.name, expectedName);
    XCTAssertNil(event2.arguments);
}

- (void)testEquatable
{
    Auto expectedName = @"EVENT_NAME";
    Auto expectedArguments = @{ @"KEY_1": @1, @"KEY_2": @YES };
    Auto event = [[KYAEvent alloc] initWithName:expectedName arguments:expectedArguments];
    XCTAssertEqualObjects(event, [[KYAEvent alloc] initWithName:expectedName arguments:expectedArguments]);
    
    Auto nilArgumentsEvent = [[KYAEvent alloc] initWithName:expectedName arguments:nil];
    XCTAssertNotEqualObjects(event, nilArgumentsEvent);
    
    Auto otherEvent = [[KYAEvent alloc] initWithName:@"OTHER_EVENT" arguments:@{}];
    XCTAssertNotEqualObjects(event, otherEvent);
}

- (void)testCopying
{
    Auto expectedName = @"EVENT_NAME";
    Auto expectedArguments = @{ @"KEY_1": @1, @"KEY_2": @YES };
    Auto event = [[KYAEvent alloc] initWithName:expectedName arguments:expectedArguments];
    XCTAssertEqualObjects(event, [event copy]);
    
    Auto nilArgumentsEvent = [[KYAEvent alloc] initWithName:expectedName arguments:nil];
    XCTAssertEqualObjects(nilArgumentsEvent, [nilArgumentsEvent copy]);
}

@end
