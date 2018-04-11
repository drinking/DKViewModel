//
//  DKViewModelTests.m
//  DKViewModelTests
//
//  Created by drinking on 07/27/2016.
//  Copyright (c) 2016 drinking. All rights reserved.
//

#import <DKViewModel/DKListViewModel.h>
#import <ReactiveObjC/ReactiveObjC.h>

@import XCTest;

@interface Tests : XCTestCase

@property (nonatomic,strong) DKListViewModel *viewModel;

@end

@implementation Tests

- (void)setUp
{
    [super setUp];
    self.viewModel = [DKListViewModel instanceWithRequestBlock:^(DKListViewModel *instance, id <RACSubscriber> subscriber, NSInteger pageOffset) {
        NSMutableArray *list = [@[] mutableCopy];
        for (int i = 0; i<instance.perPage; i++) {
            NSString *text = [NSString stringWithFormat:@"%@",@(pageOffset+i)];
            [list addObject:text];
        }
        [subscriber sendNext:RACTuplePack(list, @(NO))];
        [subscriber sendCompleted];
    }];
    

}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    
    
    NSMutableArray *expects = [@[] mutableCopy];
    
    [self.viewModel subscribeDataLoaded:^(NSArray *list) {
        XCTAssertNotNil(list);
        XCTestExpectation *expect =  expects.firstObject;
        [expect fulfill];
        [expects removeObjectAtIndex:0];
    } error:^(NSError *error) {
        XCTestExpectation *expect =  expects.firstObject;
        [expect fulfill];
        [expects removeObjectAtIndex:0];
        XCTAssertNil(error);
    }];
    
    
    [self.viewModel nextPage];
    [expects addObject:[self expectationWithDescription:@"Oh, firt timeout!"]];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * error) {
        XCTAssert([self.viewModel.listData count] == self.viewModel.perPage,@"list data count should be 20");
    }];

    [expects addObject:[self expectationWithDescription:@"Oh, second timeout!"]];
    [self.viewModel nextPage];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * error) {
        XCTAssert([self.viewModel.listData count] == 2*self.viewModel.perPage,@"list data count should be 40");
        XCTAssert( [@"15" isEqualToString:self.viewModel.listData[15]] ,@"index at 15 must be equal to 15");
        XCTAssert( [@"25" isEqualToString:self.viewModel.listData[25]] ,@"index at 25 must be equal to 25");
    }];
    
    
    [expects addObject:[self expectationWithDescription:@"Oh, refresh timeout!"]];
    [self.viewModel refresh];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * error) {
        XCTAssert([self.viewModel.listData count] == self.viewModel.perPage,@"list data count should be 20");
        XCTAssert( [@"15" isEqualToString:self.viewModel.listData[15]] ,@"index at 15 must be equal to 15");
    }];
    
}

@end

