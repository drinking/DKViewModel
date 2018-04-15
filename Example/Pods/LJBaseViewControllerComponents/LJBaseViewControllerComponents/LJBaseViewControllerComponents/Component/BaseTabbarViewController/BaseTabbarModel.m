//
//  LJTabbarModel.m
//  LianjiaNG
//
//  Created by Volcno on 15/8/20.
//  Copyright (c) 2015年 Lianjia. All rights reserved.
//

#import "BaseTabbarModel.h"

@implementation BaseTabbarModel

- (UIColor *)titleColor {
    if (_titleColor) {
        return _titleColor;
    }
    return [[UIColor whiteColor] colorWithAlphaComponent:0.7];
}

- (UIColor *)selectedTitleColor {
    if (_selectedTitleColor) {
        return _selectedTitleColor;
    }
    return [UIColor whiteColor];
}

@end
