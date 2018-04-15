//
//  LJTabbarModel.h
//  LianjiaNG
//
//  Created by Volcno on 15/8/20.
//  Copyright (c) 2015年 Lianjia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BaseTabbarModel : NSObject

@property (nonatomic, copy) NSString *title;                        // tab 显示的文字
@property (nonatomic, strong) UIImage *image;                       // tab 显示的图标
@property (nonatomic, strong) UIImage *selectedImage;               // tab 被选中时显示的图标
@property (nonatomic, strong) UIColor *titleColor;                  // tab 显示的文字颜色
@property (nonatomic, strong) UIColor *selectedTitleColor;          // tab 被选中时显示的文字颜色
@property (nonatomic, strong) UIViewController *rootViewController; // tab 对应的 viewController
@property (nonatomic, assign) BOOL shouldNotHighlighted;            // 点击 tab 时不高亮
@property (nonatomic, copy) NSString *logKey;                       // 如需记录日志，tab 对应的日志 key 值

@end
