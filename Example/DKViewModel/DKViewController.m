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

@interface DKViewController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) DKListViewModel *tableViewModel;
@property(nonatomic, strong) UILabel *textLabel;


@end

@implementation DKViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableViewModel = [DKListViewModel instanceWithRequestBlock:^(DKListViewModel *instance,
            id <RACSubscriber> subscriber, NSInteger pageOffset) {

        //do some asynchronous request
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (pageOffset<40){
                BOOL hasMore = YES;
                [subscriber sendNext:RACTuplePack([self createStringArray:pageOffset], @(hasMore))];
            }else{
                BOOL hasMore = NO;
                [subscriber sendNext:RACTuplePack(@[], @(hasMore))];
            }
            
        });
        

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
        [self.tableViewModel refresh];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.tableViewModel nextPage];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)updateTableViewStatusText:(NSString *)text {
    self.textLabel.frame = self.tableView.bounds;
    self.textLabel.text = text;
    self.tableView.tableFooterView = self.textLabel;
}

- (NSArray *)createStringArray:(NSInteger)base {
    NSMutableArray *array = [@[] mutableCopy];

    for (NSInteger i = base; i < base + 20; ++i) {
        [array addObject:[NSString stringWithFormat:@"This is item %ld", (long)i]];
    }

    return [array copy];
}

- (void)bindView:(UITableView *)tableView withViewModel:(DKListViewModel *)viewModel {

    @weakify(self)
    [viewModel.statusChangedSignal subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        DKRequestStatus status = (DKRequestStatus) [tuple.first unsignedIntegerValue];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        
        switch (status) {
            case DKRNotStarted:
                [self updateTableViewStatusText:@"Request not started"];
                break;

            case DKRDataLoaded:
                self.tableView.tableFooterView.frame = CGRectZero;
                [self.tableView reloadData];
                break;

            case DKRNoData:
                [self updateTableViewStatusText:@"No Data!"];
                break;

            case DKRNoMoreData:
                [self.tableView reloadData];
                [self.tableView.mj_footer resetNoMoreData];
                break;

            case DKRError:
                [self updateTableViewStatusText:@"Request Error!"];
                break;
        }

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
    cell.textLabel.text = self.tableViewModel.listData[indexPath.row];
    return cell;
    
}

@end
