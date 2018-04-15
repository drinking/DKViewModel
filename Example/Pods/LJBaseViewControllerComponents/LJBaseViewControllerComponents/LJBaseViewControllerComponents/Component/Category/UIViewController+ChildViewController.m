//
//  UIViewController+ChildViewController.m
//  BaseFrame
//
//  Created by zhouzhi on 16/5/23.
//  Copyright © 2016年 LianJia. All rights reserved.
//

#import "UIViewController+ChildViewController.h"

@implementation UIViewController (ChildViewController)

- (UIViewController *)lj_currentChildViewController {
    if (self.childViewControllers.count) {
        return self.childViewControllers.lastObject;
    }

    return nil;
}

@end
