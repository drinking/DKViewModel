//
//  DKListViewModel.h
//  Pods
//
//  Created by drinking on 16/7/27.
//
//

#import "DKViewModel.h"
#import "DKListViewModelState.h"
#import <ReactiveObjC/ReactiveObjC.h>

@class DKListViewModel;

typedef void (^DKRequestListBlock)(DKListViewModel *instance, id <RACSubscriber> subscriber, NSInteger pageOffset);

@interface DKListViewModel : DKViewModel

@property(nonatomic, strong) NSArray *listData;
@property(nonatomic, assign) NSInteger page;
@property(nonatomic, assign) NSInteger perPage;
@property(nonatomic, copy) DKRequestListBlock requestBlock;
@property(nonatomic, strong,readonly) RACSignal *executing;

- (void)appendListData:(NSArray *)list;

- (void)nextPage;

- (void)loadPage:(NSInteger)pageNum;

- (RACTuple *)calculateBetweenOldArray:(NSArray *)oldObjects
                              newArray:(NSArray *)newObjects
                          sectionIndex:(NSInteger)section;

+ (instancetype)instanceWithRequestBlock:(DKRequestListBlock)block;

- (void)clean;

- (DKListViewModelState *)saveSate;

- (void)restoreState:(DKListViewModelState *)state;

@end
