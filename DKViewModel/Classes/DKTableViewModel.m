//
//  DKTableViewModel.m
//  Pods
//
//  Created by drinking on 16/7/27.
//
//

#import "DKTableViewModel.h"
#import "DKRACSubscriber.h"

@implementation DKTableViewModel {
    RACSignal *_statusChangedSignal;
}

+ (instancetype)instanceWithRequestBlock:(DKRequestListBlock)block {
    DKTableViewModel *viewModel = (DKTableViewModel *) [[self class] new];
    viewModel.requestBlock = block;
    return viewModel;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _page = 1;
        _perPage = 20;
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
    }                                completed:^{

    }];
}

- (RACSignal *)statusChangedSignal {
    if (!_statusChangedSignal) {
        @weakify(self)
        _statusChangedSignal = [RACObserve(self, status) map:^id(id value) {
            @strongify(self)
            if (self.status == DKRError) {
                self.listData = @[];
            }
            return RACTuplePack(value, self.listData);
        }];
    }
    return _statusChangedSignal;
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
