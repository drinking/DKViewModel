//
//  BaseViewController.m
//  LJBaseViewControllerComponents
//
//  Created by Volcno on 16/7/12.
//  Copyright © 2016年 lianjia. All rights reserved.
//

#import "BaseViewController.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
static DDLogLevel ddLogLevel = DDLogLevelInfo;

@implementation BaseViewController

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    DDLogInfo(@"%@,%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    DDLogInfo(@"%@,%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    DDLogInfo(@"%@,%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    DDLogInfo(@"%@,%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    DDLogInfo(@"%@,%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    DDLogInfo(@"%@,%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    DDLogInfo(@"%@,%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    // Dispose of any resources that can be recreated.
}
@end
