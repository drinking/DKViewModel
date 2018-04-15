//
//  LJTabbarItem.h
//  LianjiaNG
//
//  Created by Volcno on 15/8/21.
//  Copyright (c) 2015年 Lianjia. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FONT_OF_NORMAL ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) ? @"Helvetica Neue" : @"Heiti SC"

@class BaseTabbarModel;

@interface BaseTabbarItem : UIButton

@property (nonatomic, assign) NSInteger badgeNumber;  // tab 上显示数字
@property (nonatomic, assign) BOOL hideBadge;         // 隐藏 tab 数字的开关
@property (nonatomic, assign) BOOL showSmallBadge;    // 隐藏 tab 上小红点的开关
@property (nonatomic, strong) BaseTabbarModel *model; // 配置的 model

/**
 *  通过 tabbar model 配置 tabbar item
 */
- (void)configTabbarModel:(BaseTabbarModel *)model;

@end
