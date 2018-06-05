//
//  DKHomeViewController.m
//  DKViewModel_Example
//
//  Created by drinking on 2018/6/5.
//  Copyright © 2018年 drinking. All rights reserved.
//

#import "DKHomeViewController.h"
#import "DKViewController.h"

@interface DKHomeViewController ()

@end

@implementation DKHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController pushViewController:[DKViewController new] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
