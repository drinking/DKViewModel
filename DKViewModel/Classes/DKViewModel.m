//
//  DKViewModel.m
//  Pods
//
//  Created by drinking on 16/7/27.
//
//

#import "DKRACSubscriber.h"
#import "DKViewModel.h"

@implementation DKViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _status = DKRNotStarted;
        NSError *error = [[NSError alloc] initWithDomain:@"DKTableViewModel.refresh" code:404 userInfo:nil];
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
