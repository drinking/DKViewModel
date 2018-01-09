//
//  DKViewModel.m
//  Pods
//
//  Created by drinking on 16/7/27.
//
//

#import "DKRACSubscriber.h"
#import "DKViewModel.h"

@interface DKViewModel()
@property(nonatomic, strong,readwrite) DKRACSubscriber *statusSubscriber;
@end

@implementation DKViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _status = DKRNotStarted;
        NSError *error = [[NSError alloc] initWithDomain:@"DKListViewModel.refresh" code:404 userInfo:nil];
        _rac_Refresh = [RACSignal error:error];
    }

    return self;
}

- (id <RACSubscriber>)refreshSubscriber {
    return [DKRACSubscriber subscriberWithNext:NULL error:NULL completed:NULL];
}

- (void)refresh {
    [self.rac_Refresh subscribe:self.refreshSubscriber];
}

@end

@implementation DKViewModel (Subscription)

- (RACDisposable *)subscribePrePorgress:(void (^)())preProgressBlock
                             notStarted:(void (^)())notStartedBlock
                             dataLoaded:(void (^)(NSArray *list))dataLoadedBlock
                                 noData:(void (^)())noDataBlock
                             noMoreData:(void (^)())noMoreDataBlock
                                  error:(void (^)())errorBlock {
    
    NSCParameterAssert(preProgressBlock != NULL);
    NSCParameterAssert(notStartedBlock != NULL);
    NSCParameterAssert(dataLoadedBlock != NULL);
    NSCParameterAssert(noDataBlock != NULL);
    NSCParameterAssert(noMoreDataBlock != NULL);
    NSCParameterAssert(errorBlock != NULL);
    
    self.statusSubscriber = [DKRACSubscriber subscribeWithPrePorgress:preProgressBlock
                                                           notStarted:notStartedBlock
                                                           dataLoaded:dataLoadedBlock
                                                               noData:noDataBlock
                                                           noMoreData:noMoreDataBlock
                                                                error:errorBlock];
    
    return [self.statusSubscriber rac_deallocDisposable];
}

- (RACDisposable *)subscribePrePorgress:(void (^)())preProgressBlock
                             dataLoaded:(void (^)(NSArray *list))dataLoadedBlock
                                 noData:(void (^)())noDataBlock
                                  error:(void (^)(NSError *error))errorBlock {
    
    NSCParameterAssert(preProgressBlock != NULL);
    NSCParameterAssert(dataLoadedBlock != NULL);
    NSCParameterAssert(noDataBlock != NULL);
    NSCParameterAssert(errorBlock != NULL);
    
    self.statusSubscriber = [DKRACSubscriber subscribeWithPrePorgress:preProgressBlock
                                                           notStarted:NULL
                                                           dataLoaded:dataLoadedBlock
                                                               noData:noDataBlock
                                                           noMoreData:NULL
                                                                error:errorBlock];
    return [self.statusSubscriber rac_deallocDisposable];
}

- (RACDisposable *)subscribePrePorgress:(void (^)())preProgressBlock
                             dataLoaded:(void (^)(NSArray *list))dataLoadedBlock
                             noMoreData:(void (^)())noMoreDataBlock {
    
    NSCParameterAssert(preProgressBlock != NULL);
    NSCParameterAssert(dataLoadedBlock != NULL);
    NSCParameterAssert(noMoreDataBlock != NULL);
    
    self.statusSubscriber = [DKRACSubscriber subscribeWithPrePorgress:preProgressBlock
                                                           notStarted:NULL
                                                           dataLoaded:dataLoadedBlock
                                                               noData:NULL
                                                           noMoreData:noMoreDataBlock
                                                                error:NULL];
    return [self.statusSubscriber rac_deallocDisposable];
    
}

@end
