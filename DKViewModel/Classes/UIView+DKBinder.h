//
// Created by drinking on 16/7/28.
//

#import <Foundation/Foundation.h>

@interface UIView (DKBinder)

@property(nonatomic, weak) id bindedVM;
@property(nonatomic, strong, readonly) UIViewController *attachedController;
@end