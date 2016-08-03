//
//  DKViewController.m
//  DKViewModel
//
//  Created by drinking on 07/27/2016.
//  Copyright (c) 2016 drinking. All rights reserved.
//

//#import <YKCVodPlayerFramework/YKCVodPlayerFramework.h>
#import "DKViewController.h"
//#import "LOHouseVideoViewModel.h"
//#import "VodPlayerView+Binder.h"
#import <DKViewModel/UIView+DKBinder.h>

@interface DKViewController ()
//@property(nonatomic, strong) LOHouseVideoViewModel *viewModel;
@end

@implementation DKViewController {
//    VodPlayerView *_playerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    [YKCloudSdk initSDK:@"878f34678a03d1e0" clientSecretKey:@"6fb7c7aa962754cf0d4dd2aeb7166031"];
    [self initPlayerView];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.viewModel refreshVideoLists];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)initPlayerView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.attachedController;

//    _playerView = [[VodPlayerView alloc] init];
//    _playerView.useSystemRotion = YES;
//    CGFloat width = CGRectGetWidth(self.view.frame);
//    _playerView.frame = CGRectMake(0, 0, width, width * 2 / 3);
//    [self.view addSubview:_playerView];
//
//    _viewModel = [[LOHouseVideoViewModel alloc] initWithVideoId:@"579860740cf20c4981a08068"];
//    [_playerView bindForLOHouseVideoViewModel:self.viewModel];

}

@end
