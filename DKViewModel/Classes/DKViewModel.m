//
//  DKViewModel.m
//  Pods
//
//  Created by drinking on 16/7/27.
//
//

#import "DKSubscriber.h"
#import "DKViewModel.h"

@interface DKViewModel()
@property(nonatomic, strong,readwrite) DKSubscriber *statusSubscriber;
@end

@implementation DKViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _status = DKRNotStarted;
        _enableDiff = NO;
    }

    return self;
}

- (id <RACSubscriber>)refreshSubscriber {
    return [DKSubscriber subscriberWithNext:NULL error:NULL completed:NULL];
}

- (void)refresh {
    [[[self.racRefresh executionSignals] switchToLatest] subscribe:self.refreshSubscriber];
    [self.racRefresh execute:@(1)];
}

@end

@implementation DKViewModel (Subscription)


- (RACDisposable *)subscribePrePorgress:(void (^)(void))preProgressBlock
                             notStarted:(void (^)(void))notStartedBlock
                             dataLoaded:(void (^)(NSArray *list,NSArray *pathsToDelete,NSArray *pathsToInsert,NSArray *pathsToMove,NSArray *destinationPaths))dataLoadedBlock
                                  error:(void (^)(NSError *error))errorBlock {
    
    NSCParameterAssert(preProgressBlock != NULL);
    NSCParameterAssert(notStartedBlock != NULL);
    NSCParameterAssert(dataLoadedBlock != NULL);
    NSCParameterAssert(errorBlock != NULL);
    self.enableDiff = YES;
    self.statusSubscriber = [DKSubscriber subscribeWithPrePorgress:preProgressBlock
                                                           notStarted:notStartedBlock
                                                           dataLoaded:dataLoadedBlock
                                                          simpleLoaded:NULL
                                                                error:errorBlock];
    if(self.status == DKRNotStarted) {
        notStartedBlock();
    }
    
    return [self.statusSubscriber rac_deallocDisposable];
    
}

- (RACDisposable *)subscribeDataLoaded:(void (^)(NSArray *list))dataLoadedBlock
                                  error:(void (^)(NSError *error))errorBlock {
    
    NSCParameterAssert(dataLoadedBlock != NULL);
    NSCParameterAssert(errorBlock != NULL);
    
    self.statusSubscriber = [DKSubscriber subscribeWithPrePorgress:NULL
                                                           notStarted:NULL
                                                           dataLoaded:NULL
                                                         simpleLoaded:dataLoadedBlock
                                                                error:errorBlock];
    
    return [self.statusSubscriber rac_deallocDisposable];
    
}


@end
