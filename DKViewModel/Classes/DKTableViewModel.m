//
//  DKTableViewModel.m
//  Pods
//
//  Created by drinking on 16/7/27.
//
//

#import "DKTableViewModel.h"
#import "RACSignal.h"

@implementation DKTableViewModel


- (RACSignal *)refresh {
    NSError *error = [[NSError alloc] initWithDomain:@"DKTableViewModel.refresh" code:404 userInfo:nil];
    return [RACSignal error:error];
}

- (RACSignal *)nextPage {
    return [[self loadPage:self.page + 1] doNext:^(id x) {
        self.page += 1;
    }];
}

- (RACSignal *)loadPage:(NSInteger)pageNum {
    NSError *error = [[NSError alloc] initWithDomain:@"DKTableViewModel.loadPage" code:404 userInfo:nil];
    return [RACSignal error:error];
}


@end
