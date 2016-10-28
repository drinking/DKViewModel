//
//  DKTableViewModel.h
//  Pods
//
//  Created by drinking on 16/7/27.
//
//

#import "DKViewModel.h"

@class DKTableViewModel;

typedef void (^DKRequestListBlock)(DKTableViewModel *instance, id <RACSubscriber> subscriber, NSInteger pageOffset);

@interface DKTableViewModel : DKViewModel

@property(nonatomic, strong) NSArray *listData;
@property(nonatomic, assign) NSInteger page;
@property(nonatomic, assign) NSInteger perPage;
@property(nonatomic, copy) DKRequestListBlock requestBlock;

- (void)appendListData:(NSArray *)list;

- (RACSignal *)rac_NextPage;

- (RACSignal *)rac_LoadPage:(NSInteger)pageNum;

- (void)nextPage;

- (void)loadPage:(NSInteger)pageNum;

+ (instancetype)instanceWithRequestBlock:(DKRequestListBlock)block;

@end
