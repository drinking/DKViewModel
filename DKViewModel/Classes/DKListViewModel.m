//
//  DKListViewModel.m
//  Pods
//
//  Created by drinking on 16/7/27.
//
//

#import "DKListViewModel.h"
#import "DKSubscriber.h"

@interface DKListViewModel()

@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property(nonatomic, strong) NSOperationQueue *operationQueue;
@property(nonatomic, strong) NSMutableArray<NSOperation *>* updateUIOperations;
@property (nonatomic, strong) RACCommand *requestCommand;
@end

@implementation DKListViewModel {
    NSArray *_originList;
}

+ (instancetype)instanceWithRequestBlock:(DKRequestListBlock)block {
    DKListViewModel *viewModel = (DKListViewModel *) [[self class] new];
    viewModel.requestBlock = block;
    return viewModel;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _page = 1;
        _perPage = 20;
        self.semaphore = dispatch_semaphore_create(1);
        self.operationQueue = [NSOperationQueue new];
        self.updateUIOperations = [NSMutableArray new];
    }
    return self;
}

- (id <RACSubscriber>)refreshSubscriber {
    return [DKSubscriber subscriberWithNext:^(RACTuple *tuple) {
        NSAssert(tuple.count == 2, @"Tuple must contain two values (array,hasMore)");
        [self appendListData:tuple.first];
        if ([self.listData count] == 0) {
            self.status = DKRNoData;
        } else {
            //tuple.last is hasMore
            self.status = [tuple.last boolValue] ? DKRDataLoaded : DKRNoMoreData;
        }
    }                                    error:^(NSError *error) {
        self.status = DKRError;
        [self.statusSubscriber sendLoadError:error];
    }                                completed:^{

    }];
}

- (void)setListData:(NSArray *)listData {
    
    if (self->_originList == nil) {
        self->_originList = self.listData?:@[];
    }else {
        [self.operationQueue cancelAllOperations];
    }

    self->_listData = listData;
    [self.statusSubscriber sendSimpleLoaded:listData];
    
    @weakify(self)
    [self.operationQueue addOperationWithBlock:^{
        @strongify(self)
        NSLog(@"background thread operating...");
        RACTuple *changes = [self calculateBetweenOldArray:self->_originList newArray:listData sectionIndex:0];
        NSOperation *op = [NSBlockOperation blockOperationWithBlock:^{
            @strongify(self)
            if([self.listData count] != [listData count]) {
                //校验
                return;
            }
            self->_originList = nil;
            [self.statusSubscriber sendLoadedListData:self->_listData pathsToDelete:changes.first pathsToDelete:changes.second
                                          pathsToMove:changes.third destinationPaths:changes.fourth];
            NSLog(@"main thread operating...");
        }];
        
        //防止同时操作数组
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        if([self.updateUIOperations count]>0){
            [self.updateUIOperations makeObjectsPerformSelector:@selector(cancel)];
            [self.updateUIOperations removeAllObjects];
        }
        [[NSOperationQueue mainQueue] addOperation:op];
        [self.updateUIOperations addObject:op];
        dispatch_semaphore_signal(self.semaphore);
        
    }];
    
}

- (RACTuple *)calculateBetweenOldArray:(NSArray *)oldObjects
                              newArray:(NSArray *)newObjects
                          sectionIndex:(NSInteger)section {
    
    NSMutableArray *pathsToDelete = [NSMutableArray new];
    NSMutableArray *pathsToInsert = [NSMutableArray new];
    NSMutableArray *pathsToMove = [NSMutableArray new];
    NSMutableArray *destinationPaths = [NSMutableArray new];
    
    // Deletes and moves
    for (NSInteger oldIndex = 0; oldIndex < oldObjects.count; oldIndex++) {
        NSObject *object = oldObjects[oldIndex];
        NSInteger newIndex = [newObjects indexOfObject:object];
        
        if (newIndex == NSNotFound) {
            [pathsToDelete addObject:[NSIndexPath indexPathForRow:oldIndex inSection:section]];
        } else if (newIndex != oldIndex) {
            [pathsToMove addObject:[NSIndexPath indexPathForRow:oldIndex inSection:section]];
            [destinationPaths addObject:[NSIndexPath indexPathForRow:newIndex inSection:section]];
        }
    }
    
    // Inserts
    for (NSInteger newIndex = 0; newIndex < newObjects.count; newIndex++) {
        NSObject *object = newObjects[newIndex];
        if (![oldObjects containsObject:object]) {
            [pathsToInsert addObject:[NSIndexPath indexPathForRow:newIndex inSection:section]];
        }
    }
    
    return RACTuplePack([pathsToDelete copy],[pathsToInsert copy],[pathsToMove copy],[destinationPaths copy]);
}

- (void)appendListData:(NSArray *)list {
    if (!self.listData || [self.listData count] == 0 || self.page-1 == 1) {
        self.listData = list;
        return;
    }
    NSMutableArray *arrays = [self.listData mutableCopy];
    [arrays addObjectsFromArray:list];
    self.listData = [arrays copy];
}

- (RACCommand *)requestCommand {
    if(self.requestBlock && !_requestCommand) {
        @weakify(self)
        _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * (NSNumber *pageNum) {
            return [[RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
                @strongify(self)
                self.requestBlock(self, subscriber, ([pageNum integerValue] - 1) * self.perPage);
                return nil;
            }] doNext:^(id x) {
                @strongify(self)
                self.page += 1;
            }];
        }];
        
    }
    return _requestCommand;
}

- (RACSignal *)executing {
    return self.requestCommand.executing;
}

- (id <RACSubscriber>)loadPageSubscriber {
    return [self refreshSubscriber];
}

- (void)nextPage {
    [[self.requestCommand execute:@(self.page)] subscribe:self.loadPageSubscriber];
}

- (void)loadPage:(NSInteger)pageNum {
    self.page = pageNum;
    [[self.requestCommand execute:@(pageNum)] subscribe:self.loadPageSubscriber];
}

- (void)refresh {
    [self loadPage:1];
}

- (RACCommand *)racRefresh {
    self.page = 1;
    return self.requestCommand;
}

@end
