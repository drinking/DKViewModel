//
//  DKViewController.m
//  DKViewModel
//
//  Created by drinking on 07/27/2016.
//  Copyright (c) 2016 drinking. All rights reserved.
//

#import "DKViewController.h"
#import <DKViewModel/UIView+DKBinder.h>

@interface DKViewController ()
@end

@implementation DKViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)initPlayerView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.attachedController;

}

@end
