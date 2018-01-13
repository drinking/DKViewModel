//
//  DKListViewModel.m
//  Pods
//
//  Created by drinking on 16/7/27.
//
//

#import "DKListViewModel.h"
#import "DKRACSubscriber.h"

@interface DKListViewModel()

@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@end

@implementation DKListViewModel 

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
    }
    return self;
}

- (id <RACSubscriber>)refreshSubscriber {
    return [DKRACSubscriber subscriberWithNext:^(RACTuple *tuple) {
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
    @weakify(self)
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @strongify(self)
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        NSArray *oldArray = self.listData;
        RACTuple *changes = [self calculateBetweenOldArray:oldArray newArray:listData sectionIndex:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self)
            if(self){
                [self _setListData:listData];
                [self.statusSubscriber sendLoadedListData:listData pathsToDelete:changes.first pathsToDelete:changes.second
                                              pathsToMove:changes.third destinationPaths:changes.fourth];
                dispatch_semaphore_signal(self.semaphore);
            }
        });
    });
}

// prevent retain cycle for setListDAta
- (void)_setListData:(NSArray *)listData {
    _listData = listData;
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
    if (!self.listData || [self.listData count] == 0 || self.page == 1) {
        self.listData = list;
        return;
    }
    NSMutableArray *arrays = [self.listData mutableCopy];
    [arrays addObjectsFromArray:list];
    self.listData = [arrays copy];
}

- (RACSignal *)rac_NextPage {
    return [[self rac_LoadPage:self.page + 1] doNext:^(id x) {
        self.page += 1;
    }];
}

- (void)nextPage {
    [[self rac_NextPage] subscribe:self.loadPageSubscriber];
}

- (RACSignal *)rac_LoadPage:(NSInteger)pageNum {

    if (self.requestBlock) {
        @weakify(self)
        return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
            @strongify(self)
            self.requestBlock(self, subscriber, (pageNum - 1) * self.perPage);
            return nil;
        }];
    }

    return nil;
}

- (id <RACSubscriber>)loadPageSubscriber {
    return [self refreshSubscriber];
}

- (void)loadPage:(NSInteger)pageNum {
    [[self rac_LoadPage:pageNum] subscribe:self.loadPageSubscriber];
}

- (void)refresh {
    self.page = 1;
    [self loadPage:self.page];
}

- (RACSignal *)rac_Refresh {
    self.page = 1;
    return [self rac_LoadPage:self.page];
}

@end
