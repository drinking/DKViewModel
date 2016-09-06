//
//  DKTableViewModel.m
//  Pods
//
//  Created by drinking on 16/7/27.
//
//

#import "DKTableViewModel.h"
#import "RACSignal.h"
#import "RACSubscriber+Private.h"

@implementation DKTableViewModel


- (instancetype)init {
    self = [super init];
    if (self) {
        _status = DKRNotStarted;
    }

    return self;
}

- (id <RACSubscriber>)refreshSubscriber {
    RACSubscriber *o = [RACSubscriber subscriberWithNext:NULL error:NULL completed:NULL];
    return o;
}

- (id <RACSubscriber>)loadPageSubscriber {
    RACSubscriber *o = [RACSubscriber subscriberWithNext:NULL error:NULL completed:NULL];
    return o;
}

- (RACSignal *)rac_Refresh {
    NSError *error = [[NSError alloc] initWithDomain:@"DKTableViewModel.refresh" code:404 userInfo:nil];
    return [RACSignal error:error];
}

- (RACSignal *)rac_NextPage {
    return [[self rac_LoadPage:self.page + 1] doNext:^(id x) {
        self.page += 1;
    }];
}

- (RACSignal *)rac_LoadPage:(NSInteger)pageNum {
    NSError *error = [[NSError alloc] initWithDomain:@"DKTableViewModel.loadPage" code:404 userInfo:nil];
    return [RACSignal error:error];
}

- (void)refresh {
    [[self rac_Refresh] subscribe:self.refreshSubscriber];
}

- (void)nextPage {
    [[self rac_NextPage] subscribe:self.loadPageSubscriber];
}

- (void)loadPage:(NSInteger)pageNum {
    [[self rac_LoadPage:pageNum] subscribe:self.loadPageSubscriber];
}

@end
