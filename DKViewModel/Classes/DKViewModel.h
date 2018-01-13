//
//  DKViewModel.h
//  Pods
//
//  Created by drinking on 16/7/27.
//
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "DKRACSubscriber.h"

typedef NS_ENUM(NSUInteger, DKRequestStatus) {
    DKRNotStarted, DKRDataLoaded, DKRNoData, DKRNoMoreData, DKRError
};

@interface DKViewModel : NSObject

@property(nonatomic, strong,readonly) DKRACSubscriber *statusSubscriber;
@property(nonatomic, assign) DKRequestStatus status;
@property(nonatomic, strong) RACSignal *rac_Refresh;
@property(nonatomic, strong) id response;

- (void)refresh;

@end

@interface DKViewModel (Subscription)

- (RACDisposable *)subscribePrePorgress:(void (^)())preProgressBlock
                             notStarted:(void (^)())notStartedBlock
                             dataLoaded:(void (^)(NSArray *list,NSArray *pathsToDelete,NSArray *pathsToInsert,NSArray *pathsToMove,NSArray *destinationPaths))dataLoadedBlock
                                  error:(void (^)(NSError *error))errorBlock;

@end
