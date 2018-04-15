//
//  LJTabBarController.h
//  LianjiaNG
//
//  Created by Volcno on 15/8/20.
//  Copyright (c) 2015年 Lianjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseTabbarItem;
@class BaseTabbarModel;

typedef void (^TabClickBlock)(BaseTabbarModel *model);

@interface BaseTabBarController : UITabBarController

@property (nonatomic, copy) NSArray *tabModelArray;           //存储的 tabbar model 数组
@property (nonatomic, strong) NSMutableArray *classArray;     // tabbar 对应的根 viewController 的类名字符串数组
@property (nonatomic, copy) TabClickBlock clickBlock;         //点击了 tabbar 后的回调 block
@property (nonatomic, strong) UIColor *tabbarBackgroundColor; // tabbar 背景颜色
@property (nonatomic, strong) UIColor *tabbarLineColor;       // tabbar 最上方的线的颜色

/**
 *  更新对应页面的 tabbar 显示的数字
 *
 *  @param viewControllerClass viewController 的类名字符串
 *  @param number              显示的数字
 */
- (void)updateTabBadgeNumberWithClass:(Class)viewControllerClass number:(NSInteger)number;

/**
 *  更新对应页面的 tabbar 显示的状态
 *
 *  @param viewControllerClass viewController 的类名字符串
 *  @param shouldShow          显示状态
 */
- (void)updateTabBadgeNumberShowStatusWithClass:(Class)viewControllerClass showStatus:(BOOL)shouldShow;

/**
 *  获取某页面的 tabbar 显示的数字值
 *
 *  @param viewControllerClass viewController 的类名字符串
 *
 *  @return 显示的数字
 */
- (NSInteger)badgeNumberOfClass:(Class)viewControllerClass;

/**
 *  配置 tabbar
 *
 *  @param tabModelArray tabbarmodel 的数组
 */
- (void)setupWithTabModelArray:(NSArray *)tabModelArray;

/**
 *  更新对应页面的 tabbar 显示小红点的状态
 *
 *  @param viewControllerClass viewController 的类名字符串
 *  @param show                显示状态
 */
- (void)showSmallBadgeWithClass:(Class)viewControllerClass showSmallBadge:(BOOL)show;

@end