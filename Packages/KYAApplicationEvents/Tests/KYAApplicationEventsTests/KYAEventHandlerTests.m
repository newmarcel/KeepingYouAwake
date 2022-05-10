//
//  KYAEventHandlerTests.m
//  KYAApplicationEventsTests
//
//  Created by Marcel Dierkes on 10.05.22.
//

#import <XCTest/XCTest.h>
#import <KYAApplicationEvents/KYAApplicationEvents.h>
#import "../../Sources/KYAApplicationEvents/KYADefines.h"

@interface KYAEventHandler (Private)
@property (nonatomic) NSMapTable *eventTable;
@end

@interface KYAEventHandlerTests : XCTestCase
@property (nonatomic) KYAEventHandler *eventHandler;
@end

@implementation KYAEventHandlerTests

- (void)setUp
{
    [super setUp];
    
    self.eventHandler = [KYAEventHandler new];
}

- (void)testDefaultHandler
{
    XCTAssertEqual(KYAEventHandler.defaultHandler, KYAEventHandler.defaultHandler);
    XCTAssertEqualObjects(KYAEventHandler.defaultHandler, KYAEventHandler.defaultHandler);
    XCTAssertNotEqual(KYAEventHandler.defaultHandler, [KYAEventHandler new]);
    XCTAssertNotEqualObjects(KYAEventHandler.defaultHandler, [KYAEventHandler new]);
}

- (void)testRegisterAndRemoveAction
{
    Auto eventHandler = self.eventHandler;
    XCTAssertEqual(eventHandler.eventTable.count, 0);
    
    Auto expectedActionName = @"ACTION_NAME";
    [eventHandler registerActionNamed:expectedActionName block:^(KYAEvent *event) {}];
    XCTAssertNotNil([eventHandler.eventTable objectForKey:expectedActionName]);
    
    [eventHandler registerActionNamed:expectedActionName block:^(KYAEvent *event) {}];
    XCTAssertEqual(eventHandler.eventTable.count, 1);
    
    [eventHandler removeActionNamed:expectedActionName];
    XCTAssertEqual(eventHandler.eventTable.count, 0);
    
    [eventHandler removeActionNamed:expectedActionName];
    [eventHandler removeActionNamed:@"UNKNOWN_NAME"];
}

- (void)testHandleEvent
{
    Auto eventHandler = self.eventHandler;
    
    Auto expectedURL = [NSURL URLWithString:@"appscheme:///deactivate"];
    Auto expectedName = @"deactivate";
    
    Auto expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    
    [eventHandler registerActionNamed:expectedName block:^(KYAEvent *event) {
        XCTAssertEqualObjects(event.name, expectedName);
        XCTAssertNil(event.arguments);
        [expectation fulfill];
    }];
    [eventHandler handleEventForURL:expectedURL];
    
    [self waitForExpectations:@[expectation] timeout:5.0f];
}

- (void)testHandleEventWithArguments
{
    Auto eventHandler = self.eventHandler;
    
    Auto expectedURL = [NSURL URLWithString:@"appscheme:///activate?seconds=5"];
    Auto expectedName = @"activate";
    Auto expectedArguments = @{ @"seconds": @"5" };
    
    Auto expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    
    [eventHandler registerActionNamed:expectedName block:^(KYAEvent *event) {
        XCTAssertEqualObjects(event.name, expectedName);
        XCTAssertEqualObjects(event.arguments, expectedArguments);
        [expectation fulfill];
    }];
    
    [eventHandler registerActionNamed:@"deactivate" block:^(KYAEvent *event) {
        XCTFail();
    }];
    [eventHandler handleEventForURL:expectedURL];
    
    [self waitForExpectations:@[expectation] timeout:5.0f];
}

@end
