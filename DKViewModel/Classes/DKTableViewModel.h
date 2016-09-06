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


typedef NS_ENUM(NSUInteger, DKRequestStatus) {
    DKRNotStarted, DKRDataLoaded, DKRNoData, DKRNoMoreData, DKRError
};

@interface DKTableViewModel : DKViewModel

@property(nonatomic, assign) DKRequestStatus status;
@property(nonatomic, strong) NSArray *listData;
@property(nonatomic, assign) NSInteger page;
@property(nonatomic, assign) NSInteger perPage;

- (RACSignal *)rac_Refresh;

- (RACSignal *)rac_NextPage;

- (RACSignal *)rac_LoadPage:(NSInteger)pageNum;

- (void)refresh;

- (void)nextPage;

- (void)loadPage:(NSInteger)pageNum;

@end
