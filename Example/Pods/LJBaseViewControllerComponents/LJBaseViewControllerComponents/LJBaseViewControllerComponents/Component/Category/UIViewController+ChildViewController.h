//
//  UIViewController+ChildViewController.h
//  BaseFrame
//
//  Created by zhouzhi on 16/5/23.
//  Copyright © 2016年 LianJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ChildViewController)

/**
 *  适配业务，获取当前页面的最后一个 childViewController
 *
 *  @return childViewController
 */
- (UIViewController *)lj_currentChildViewController;

@end
