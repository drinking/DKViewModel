//
//  DKViewModel.h
//  Pods
//
//  Created by drinking on 16/7/27.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DKRequestStatus) {
    DKRNotStarted, DKRDataLoaded, DKRNoData, DKRNoMoreData, DKRError
};

@interface DKViewModel : NSObject

@property(nonatomic, assign) DKRequestStatus status;
@property(nonatomic, strong, readonly) RACSignal *statusChangedSignal;
@property(nonatomic, strong) RACSignal *rac_Refresh;
@property(nonatomic, strong) id response;

- (void)refresh;

@end
