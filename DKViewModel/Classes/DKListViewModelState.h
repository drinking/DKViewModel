//
//  DKListViewModelState.h
//  DKViewModel
//
//  Created by drinking on 2018/7/25.
//

#import "DKViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DKListViewModelState : NSObject
@property(nonatomic,strong) NSArray *list;
@property(nonatomic,assign) NSInteger page;
@property(nonatomic,assign) DKRequestStatus status;
@property(nonatomic,assign) CGPoint contentOffset;
@end
NS_ASSUME_NONNULL_END
