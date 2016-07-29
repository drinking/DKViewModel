//
//  DKTableViewModel.h
//  Pods
//
//  Created by drinking on 16/7/27.
//
//

#import "DKViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@class RACSignal;

@interface DKTableViewModel : DKViewModel

@property(nonatomic, strong) NSArray *listData;
@property(nonatomic, assign) NSInteger page;
@property(nonatomic, assign) NSInteger perPage;

- (RACSignal *)refresh;

- (RACSignal *)nextPage;

- (RACSignal *)loadPage:(NSInteger)pageNum;

@end
