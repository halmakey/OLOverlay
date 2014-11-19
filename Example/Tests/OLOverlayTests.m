//
//  OLOverlayTests.m
//  OLOverlay
//
//  Created by Ryo on 2014/11/20.
//  Copyright (c) 2014年 halmakey. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OLOverlay.h"

@interface OLOverlayTests : XCTestCase

@end

@implementation OLOverlayTests

- (void)setUp {
    [super setUp];

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testAnimator {
    XCTAssertNotNil([OLZoomOverlayAnimator animator], @"OLZoomOverlayAnimator nil test");
    XCTAssertNotNil([OLSlideupOverlayAnimator animator], @"OLSlideupOverlayAnimator nil test");
}

@end
