//
//  LORACSubscriber.m
//  LianjiaOnlineApp
//
//  Created by drinking on 16/9/18.
//  Copyright © 2016年 Bill Xie. All rights reserved.
//

#import "DKRACSubscriber.h"

@interface DKRACSubscriber ()

// These callbacks should only be accessed while synchronized on self.
@property (nonatomic, copy) void (^next)(id value);
@property (nonatomic, copy) void (^error)(NSError *error);
@property (nonatomic, copy) void (^completed)(void);

@property (nonatomic, copy) void (^preProcess)(void);
@property (nonatomic, copy) void (^notStarted)(void);
@property (nonatomic, copy) void (^loaded)(void);
@property (nonatomic, copy) void (^simpleLoaded)(void);
@property (nonatomic, copy) void (^loadError)(NSError *error);

@property (nonatomic, strong, readonly) RACCompoundDisposable *disposable;

@end

@implementation DKRACSubscriber

#pragma mark Lifecycle

+ (instancetype)subscriberWithNext:(void (^)(id x))next error:(void (^)(NSError *error))error completed:(void (^)(void))completed {
    DKRACSubscriber *subscriber = [[self alloc] init];
    
    subscriber->_next = [next copy];
    subscriber->_error = [error copy];
    subscriber->_completed = [completed copy];
    
    return subscriber;
}

+ (instancetype)subscribeWithPrePorgress:(void (^)())preProgressBlock
                              notStarted:(void (^)())notStartedBlock
                              dataLoaded:(void (^)(NSArray *list,NSArray *pathsToDelete,NSArray *pathsToInsert,NSArray *pathsToMove,NSArray *destinationPaths))dataLoadedBlock
                                   simpleLoaded:(void (^)(NSArray *list))simpleLoaded
                                   error:(void (^)(NSError *error))error {
    DKRACSubscriber *subscriber = [[self alloc] init];
    subscriber->_preProcess = [preProgressBlock copy];
    subscriber->_notStarted = [notStartedBlock copy];
    subscriber->_loaded = [dataLoadedBlock copy];
    subscriber->_simpleLoaded = [simpleLoaded copy];
    subscriber->_loadError = [error copy];
    return subscriber;
}


- (id)init {
    self = [super init];
    if (self == nil) return nil;
    
    @unsafeify(self);
    
    RACDisposable *selfDisposable = [RACDisposable disposableWithBlock:^{
        @strongify(self);
        
        @synchronized (self) {
            self.next = nil;
            self.error = nil;
            self.completed = nil;
            self.preProcess = nil;
            self.notStarted = nil;
            self.loaded = nil;
            self.loadError = nil;
            
        }
    }];
    
    _disposable = [RACCompoundDisposable compoundDisposable];
    [_disposable addDisposable:selfDisposable];
    
    return self;
}

- (void)dealloc {
    [self.disposable dispose];
}

#pragma mark RACSubscriber

- (void)sendNext:(id)value {
    @synchronized (self) {
        void (^nextBlock)(id) = [self.next copy];
        if (nextBlock == nil) return;
        
        nextBlock(value);
    }
}

- (void)sendError:(NSError *)e {
    @synchronized (self) {
        void (^errorBlock)(NSError *) = [self.error copy];
        [self.disposable dispose];
        
        if (errorBlock == nil) return;
        errorBlock(e);
    }
}

- (void)sendCompleted {
    @synchronized (self) {
        void (^completedBlock)(void) = [self.completed copy];
        [self.disposable dispose];
        
        if (completedBlock == nil) return;
        completedBlock();
    }
}

- (void)didSubscribeWithDisposable:(RACCompoundDisposable *)otherDisposable {
    if (otherDisposable.disposed) return;
    
    RACCompoundDisposable *selfDisposable = self.disposable;
    [selfDisposable addDisposable:otherDisposable];
    
    @unsafeify(otherDisposable);
    
    // If this subscription terminates, purge its disposable to avoid unbounded
    // memory growth.
    [otherDisposable addDisposable:[RACDisposable disposableWithBlock:^{
        @strongify(otherDisposable);
        [selfDisposable removeDisposable:otherDisposable];
    }]];
}


- (void)sendPreProcess {
    void (^preProcess)(void) = [self.preProcess copy];
    if (preProcess == nil) return;
    preProcess();
}

- (void)sendNotStarted {
    @synchronized (self) {
        void (^notStarted)(void) = [self.notStarted copy];
        if (notStarted == nil) return;
        if(self.preProcess){
            self.preProcess();
        }
        notStarted();
    }
}

- (void)sendLoadedListData:(NSArray *)listData
             pathsToDelete:(NSArray *)pathsToDelete
             pathsToDelete:(NSArray *)pathsToInsert
               pathsToMove:(NSArray *)pathsToMove
          destinationPaths:(NSArray *)destinationPaths {
    
    @synchronized (self) {
        void (^loaded)(NSArray *list,NSArray *pathsToDelete,NSArray *pathsToInsert,NSArray *pathsToMove,NSArray *destinationPaths) = [self.loaded copy];
        if (loaded == nil) return;
        if(self.preProcess){
            self.preProcess();
        }
        loaded(listData,pathsToDelete,pathsToInsert,pathsToMove,destinationPaths);
    }
}

- (void)sendSimpleLoaded:(NSArray *)listData {
    @synchronized (self) {
        void (^loaded)(NSArray *list) = [self.simpleLoaded copy];
        if (loaded == nil) return;
        if(self.preProcess){
            self.preProcess();
        }
        loaded(listData);
    }
}

- (void)sendLoadError:(NSError *)value {
    @synchronized (self) {
        void (^loadError)(id) = [self.loadError copy];
        if (loadError == nil) return;
        if(self.preProcess){
            self.preProcess();
        }
        loadError(value);
    }
}

@end
