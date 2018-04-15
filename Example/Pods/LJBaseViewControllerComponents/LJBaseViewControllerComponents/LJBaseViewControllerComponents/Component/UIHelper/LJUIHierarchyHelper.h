//
//  LJUIHierarchyHelper.h
//  LJBaseViewControllerComponents
//
//  Created by Volcno on 16/8/1.
//  Copyright © 2016年 lianjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJUIHierarchyHelper : NSObject

+ (LJUIHierarchyHelper *)sharedInstance;

/**
 *  获取当前 app 页面层级最上层页面
 *
 *  @return 最上层页面
 */
- (UIViewController *)getcurrentTopViewController;

@end
