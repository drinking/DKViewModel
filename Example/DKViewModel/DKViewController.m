//
//  DKViewController.m
//  DKViewModel
//
//  Created by drinking on 07/27/2016.
//  Copyright (c) 2016 drinking. All rights reserved.
//

#import "DKViewController.h"
#import <DKViewModel/DKListViewModel.h>
#import <MJRefresh/MJRefresh.h>
#import "DKTableViewItem.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface DKViewController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) DKListViewModel *tableViewModel;
@property(nonatomic, strong) UILabel *textLabel;

@end

@implementation DKViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    @weakify(self)
    _tableViewModel = [DKListViewModel instanceWithRequestBlock:^(DKListViewModel *instance,
            id <RACSubscriber> subscriber, NSInteger pageOffset) {
        //do some asynchronous request
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self)
            if (pageOffset<40){
                BOOL hasMore = YES;
                [subscriber sendNext:RACTuplePack([self createStringArray:pageOffset], @(hasMore))];
            }else{
                BOOL hasMore = NO;
                [subscriber sendNext:RACTuplePack(@[], @(hasMore))];
            }
            [subscriber sendCompleted];
        });
    }];
    
    [self.tableViewModel.executing subscribeNext:^(NSNumber *loading) {
        @strongify(self)
        if([loading boolValue]){
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            return;
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(self.tableViewModel.status == DKRError){
            //add refresh view
        }
    }];

    _tableView = [UITableView new];
    _tableView.frame = self.view.bounds;
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _textLabel = [UILabel new];
    _textLabel.textAlignment = NSTextAlignmentCenter;

    [self bindView:self.tableView withViewModel:self.tableViewModel];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self.tableViewModel refresh];
//        [self randomAsyncLoading];
//        [self randomAsyncLoading];
//        [self randomLoading];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        [self.tableViewModel nextPage];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)randomAsyncLoading {
    NSInteger total = 0;
    while (total<10) {
        int delay = arc4random()%4;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableArray *list = [@[] mutableCopy];
            DKTableViewItem *item = [DKTableViewItem new];
            item.text = [NSString stringWithFormat:@"Round %@ Value%@",@(total),[@(0) stringValue]];
            item.index = total;
            NSLog(@"append %@",@(item.index));
            [list addObject:item];
            [list addObjectsFromArray:self.tableViewModel.listData?:@[]];
            self.tableViewModel.listData = [list copy];
        });
        total+=1;
    }
}

- (void)randomLoading {
    NSInteger total = 0;
    while (total<10) {
        NSMutableArray *list = [@[] mutableCopy];
        DKTableViewItem *item = [DKTableViewItem new];
        item.text = [NSString stringWithFormat:@"Round %@ Value%@",@(total),[@(0) stringValue]];
        item.index = total;
        [list addObject:item];
        NSLog(@"append2 %@",@(item.index));
        [list addObjectsFromArray:self.tableViewModel.listData?:@[]];
        self.tableViewModel.listData = [list copy];
        total+=1;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)updateTableViewStatusText:(NSString *)text {
    self.textLabel.frame = self.tableView.bounds;
    self.textLabel.text = text;
    self.tableView.tableFooterView = self.textLabel;
}

#define addObj(x) item = [DKTableViewItem new]; \
                        item.text = [NSString stringWithFormat:@"This is item %ld", (long)x]; \
                        item.index = x; \
                        [array addObject:item]; \

- (NSArray *)createStringArray:(NSInteger)base {
    
    static NSInteger count = 1;
    NSMutableArray *array = [@[] mutableCopy];
    DKTableViewItem *item;
    if(count == 1){
        addObj(1)
        addObj(2)
        addObj(3)
        addObj(4)
        [array addObject:array[1]];
    }else {
        
        NSMutableArray *list = [self.tableViewModel.listData mutableCopy];
        DKTableViewItem *item = list[1];
        list[1] = list[2];
        list[2] = item;
        return [list copy];
        
//        addObj(1)
//        addObj(3)
//        addObj(2)
//        addObj(2)
//        addObj(4)
        
    }
    count+=1;
    
    
    
    
//    NSMutableArray *array = [@[] mutableCopy];
//    for (NSInteger i = base; i < base + 20; ++i) {
//        DKTableViewItem *item = [DKTableViewItem new];
//        item.text = [NSString stringWithFormat:@"This is item %ld", (long)10];
//        item.index = i;
//        [array addObject:item];
//    }
    return [array copy];
}

- (void)bindView:(UITableView *)tableView withViewModel:(DKListViewModel *)viewModel {

     @weakify(self)
    [viewModel subscribePrePorgress:^{
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } notStarted:^{
        @strongify(self)
        [self updateTableViewStatusText:@"Request not started"];
    } dataLoaded:^(NSArray *list, NSArray *pathsToDelete, NSArray *pathsToInsert, NSArray *pathsToMove, NSArray *destinationPaths) {
        @strongify(self)
        self.tableView.tableFooterView.frame = CGRectZero;

        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:pathsToInsert withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView deleteRowsAtIndexPaths:pathsToDelete withRowAnimation:UITableViewRowAnimationNone];
        [pathsToMove enumerateObjectsUsingBlock:^(id pathToMove, NSUInteger idx, BOOL *stop) {
            [self.tableView moveRowAtIndexPath:pathToMove toIndexPath:destinationPaths[idx]];
        }];
        [self.tableView endUpdates];

        
        
    } error:^(NSError *error) {
        @strongify(self)
        [self updateTableViewStatusText:@"Request Error!"];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableViewModel.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifier"];
    }
    DKTableViewItem *item = self.tableViewModel.listData[indexPath.row];
    cell.textLabel.text = item.text;
    return cell;
    
}

@end
