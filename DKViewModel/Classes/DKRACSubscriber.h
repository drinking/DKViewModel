//
//  LORACSubscriber.h
//  LianjiaOnlineApp
//
//  Created by drinking on 16/9/18.
//  Copyright © 2016年 Bill Xie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface DKRACSubscriber : NSObject<RACSubscriber>

+ (instancetype)subscriberWithNext:(void (^)(id x))next error:(void (^)(NSError *error))error completed:(void (^)(void))completed;



+ (instancetype)subscribeWithPrePorgress:(void (^)())preProgressBlock
                             notStarted:(void (^)())notStartedBlock
                             dataLoaded:(void (^)(NSArray *list))dataLoadedBlock
                                 noData:(void (^)())noDataBlock
                             noMoreData:(void (^)())noMoreDataBlock
                                   error:(void (^)())errorBlock;

- (void)sendPreProcess;

- (void)sendNotStarted;

- (void)sendLoaded:(id)value;

- (void)sendNoData;

- (void)sendNoMore;

@end
