//
//  LJUIHierarchyHelper.m
//  LJBaseViewControllerComponents
//
//  Created by Volcno on 16/8/1.
//  Copyright © 2016年 lianjia. All rights reserved.
//

#import "LJUIHierarchyHelper.h"
#import "UIViewController+ChildViewController.h"

@implementation LJUIHierarchyHelper

+ (LJUIHierarchyHelper *)sharedInstance {
    static LJUIHierarchyHelper *sharedLJUIHierarchyHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLJUIHierarchyHelper = [[self alloc] init];
    });
    return sharedLJUIHierarchyHelper;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (UIViewController *)getcurrentTopViewController {
//    NSAssert([NSThread isMainThread], @"must call getcurrentTopViewController on main thread !!!");
    __block UIViewController *blockViewController;
    if ([NSThread isMainThread]) {
        blockViewController = [self findTopViewController];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            blockViewController = [self findTopViewController];
        });
    }
    return blockViewController;
}

- (UIViewController *)findTopViewController {
    __block UIViewController *blockViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    while (blockViewController.presentedViewController) {
        blockViewController = blockViewController.presentedViewController;
    }
    if (![blockViewController isKindOfClass:[UITabBarController class]] &&
        ![blockViewController isKindOfClass:[UINavigationController class]]) {
        while (blockViewController.lj_currentChildViewController) {
            blockViewController = blockViewController.lj_currentChildViewController;
            if ([blockViewController isKindOfClass:[UITabBarController class]]) {
                blockViewController = [(UITabBarController *)blockViewController selectedViewController];
            }
            
            if ([blockViewController isKindOfClass:[UINavigationController class]]) {
                blockViewController = [(UINavigationController *)blockViewController topViewController];
            }
        }
    }
    if ([blockViewController isKindOfClass:[UITabBarController class]]) {
        blockViewController = [(UITabBarController *)blockViewController selectedViewController];
    }
    
    if ([blockViewController isKindOfClass:[UINavigationController class]]) {
        blockViewController = [(UINavigationController *)blockViewController topViewController];
    }
    
    return blockViewController;
}

@end
