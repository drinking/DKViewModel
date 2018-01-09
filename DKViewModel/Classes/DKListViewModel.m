//
//  DKListViewModel.m
//  Pods
//
//  Created by drinking on 16/7/27.
//
//

#import "DKListViewModel.h"
#import "DKRACSubscriber.h"

@implementation DKListViewModel {
    RACSignal *_statusChangedSignal;
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
        @weakify(self)
        [RACObserve(self, statusSubscriber) subscribeNext:^(id value) {
            @strongify(self)
            if(value){
                [self subscribeStatusSignal];
            }
        }];
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

- (void)subscribeStatusSignal {
    @weakify(self)
    if (!_statusChangedSignal) {
        _statusChangedSignal = [RACObserve(self, status) map:^id(id value) {
            @strongify(self)
            if (self.status == DKRError) {
                self.listData = @[];
            }
            return RACTuplePack(value, self.listData);
        }];
    }
    
    [_statusChangedSignal subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        [self.statusSubscriber sendPreProcess];
        DKRequestStatus status = (DKRequestStatus)[tuple.first unsignedIntegerValue];
        switch (status) {
            case DKRNotStarted:{
                [self.statusSubscriber sendNotStarted];
            } break;
            case DKRDataLoaded:{
                [self.statusSubscriber sendLoaded:tuple.second];
            } break;
            case DKRNoData:{
                [self.statusSubscriber sendNoData];
            } break;
            case DKRNoMoreData:{
                [self.statusSubscriber sendNoMore];
            } break;
            case DKRError:{
                [self.statusSubscriber sendError:nil];
            } break;
            default:
                break;
        }
    }];
    
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
