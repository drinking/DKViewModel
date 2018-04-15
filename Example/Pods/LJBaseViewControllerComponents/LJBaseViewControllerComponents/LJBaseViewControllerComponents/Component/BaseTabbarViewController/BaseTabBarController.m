//
//  LJTabBarController.m
//  LianjiaNG
//
//  Created by Volcno on 15/8/20.
//  Copyright (c) 2015年 Lianjia. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseTabbarItem.h"
#import "BaseTabbarModel.h"
#import "UIView+Utils.h"

#define iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define MinWidth (iPad ? 30 : 0)
#define ItemWidth (iPad ? 120 : (iPhone6 ? 70 : (iPhone6Plus ? 80 : 65)))
#define ButtonWidth (iPad ? 60 : 40)
#define ButtonHeight 49

@interface BaseTabBarController ()

@property (nonatomic, copy) NSArray *buttons;
@property (nonatomic, strong) UIView *customBar;
@property (nonatomic, strong) UIImageView *sliderImageView;

@end

@implementation BaseTabBarController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tabbarBackgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        self.tabbarLineColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setupWithTabModelArray:(NSArray *)tabModelArray {
    self.tabModelArray = tabModelArray;
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:5];
    if (!self.classArray) {
        self.classArray = [[NSMutableArray alloc] initWithCapacity:5];
    }
    [self.classArray removeAllObjects];
    NSArray *array = [self.childViewControllers copy];
    for (UIViewController *vc in array) {
        [vc removeFromParentViewController];
    }
    for (BaseTabbarModel *model in tabModelArray) {
        if (!model.rootViewController) {
            continue;
        }
        
        [self addChildViewController:model.rootViewController];
        [viewControllers addObject:model.rootViewController];
        UIViewController *viewController = model.rootViewController;
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            viewController = ((UINavigationController *)viewController).viewControllers.firstObject;
        }
        [self.classArray addObject:viewController.class];
    }

    self.viewControllers = viewControllers;
    [super setSelectedIndex:0];
    [self setupCustomTabBar];
}

- (void)setupCustomTabBar {
    if (!self.tabBar) {
        return;
    }

    for (BaseTabbarItem *button in self.buttons) {
        [button removeFromSuperview];
    }

    if (!self.customBar) {
        self.customBar = [[UIView alloc] initWithFrame:self.tabBar.bounds];
        self.customBar.height = self.tabBar.height;
        self.customBar.backgroundColor = self.tabbarBackgroundColor;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.customBar.width, 0.5)];
        line.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        line.backgroundColor = self.tabbarLineColor;
        [self.customBar addSubview:line];
        [self.tabBar addSubview:self.customBar];
    }

    NSUInteger itemCount = [self.tabModelArray count];

    CGFloat itemWidth = (self.tabBar.frame.size.width - MinWidth * 2) / itemCount;
    CGFloat left = MinWidth;

    NSMutableArray *array = [NSMutableArray arrayWithCapacity:5];
    for (NSUInteger index = 0; index < itemCount; index++) {
        BaseTabbarModel *tabModel = [self.tabModelArray objectAtIndex:index];

        BaseTabbarItem *button = [BaseTabbarItem buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        button.tag = index;
        button.frame = CGRectMake(left + itemWidth * index, 0, itemWidth, ButtonHeight);
        [button addTarget:self action:@selector(btnTouchDown:) forControlEvents:UIControlEventTouchDown];
        [button configTabbarModel:tabModel];
        button.frame = CGRectIntegral(button.frame);
        [self.customBar addSubview:button];
        UIViewController *viewController = tabModel.rootViewController;
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            viewController = [(UINavigationController *)viewController topViewController];
        }
        [array addObject:button];
    }
    self.buttons = array;
    [self setSelectedIndex:self.selectedIndex];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (!iPad) {
        CGRect rect = self.view.frame;
        if (rect.size.width > rect.size.height) {
            CGFloat width = rect.size.width;
            rect.size.width = rect.size.height;
            rect.size.height = width;
        }
        self.view.frame = rect;
    }
    if (self.customBar.superview != self.tabBar) {
        return;
    }
    self.customBar.frame = self.tabBar.bounds;
    if (self.tabBar.height != self.tabBar.height) {
        self.customBar.top = self.tabBar.top;
        self.customBar.height = self.tabBar.height;
    }
    NSUInteger buttonCount = [self.buttons count];
    CGFloat itemWidth = (self.tabBar.frame.size.width - MinWidth * 2) / buttonCount;
    CGFloat left = MinWidth;

    for (NSUInteger index = 0; index < buttonCount; index++) {
        UIButton *button = [self.buttons objectAtIndex:index];
        button.frame = CGRectIntegral(CGRectMake(left + itemWidth * index, 0, itemWidth, ButtonHeight));
    }
}

- (void)highlightedButtonWithIndex:(NSInteger)selectedIndex {
    for (BaseTabbarItem *button in self.buttons) {
        BOOL isSelected = button.tag == selectedIndex;
        button.selected = isSelected;
        button.highlighted = isSelected;
        for (UIView *view in button.subviews) {
            if ([view respondsToSelector:@selector(setHighlighted:)]) {
                [view setValue:@(isSelected) forKey:@"highlighted"];
            }
        }
    }
}

- (void)buttonSelectedHandler:(BaseTabbarItem *)button {
    if (!button.model.shouldNotHighlighted) {
        [self highlightedButtonWithIndex:button.tag];
    }
    if (self.selectedIndex != button.tag) {
        BOOL shouldJump = true;
        if ([self.delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) {
            shouldJump =
            [self.delegate tabBarController:self shouldSelectViewController:[self.viewControllers objectAtIndex:button.tag]];
        }
        if (shouldJump) {
            [self setSelectedIndex:button.tag];
            if ([self.delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)]) {
                [self.delegate tabBarController:self
                        didSelectViewController:[self.viewControllers objectAtIndex:self.selectedIndex]];
            }
        }
    } else {
        UIViewController *selectController = self.selectedViewController;
        UINavigationController *navWrepper = (UINavigationController *)selectController;
        if (navWrepper.viewControllers.count > 1) {
            [((UINavigationController*)selectController) popToRootViewControllerAnimated:YES];
        }
    }
    
    if (self.clickBlock) {
        self.clickBlock(button.model);
    }
}

- (UITabBar *)tabBar {
    UITabBar *tabBar = super.tabBar;
    for (UIView *view in tabBar.subviews) {
        if (view != self.customBar) {
            view.hidden = YES;
            view.alpha = 0;
        }
    }
    return tabBar;
}

- (void)btnTouchDown:(BaseTabbarItem *)button {
    [self buttonSelectedHandler:button];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (nil == self.buttons || 0 == self.buttons.count) {
        return;
    }
    
    NSUInteger safeSelectedIndex = 0;
    if (selectedIndex < self.buttons.count) {
        safeSelectedIndex = selectedIndex;
    }
    
    [super setSelectedIndex:safeSelectedIndex];
    [self highlightedButtonWithIndex:safeSelectedIndex];
    
    UIButton *btn = self.buttons[safeSelectedIndex];
    self.sliderImageView.width = btn.width;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.20];
    self.sliderImageView.left = btn.left;
    [UIView commitAnimations];
}

- (void)updateTabBadgeNumberWithClass:(Class)viewControllerClass number:(NSInteger)number {
    NSInteger index = [self.classArray indexOfObject:viewControllerClass];
    if (index != NSNotFound) {
        BaseTabbarItem *item = [self.buttons objectAtIndex:index];
        item.badgeNumber = number;
    }
}

- (void)updateTabBadgeNumberShowStatusWithClass:(Class)viewControllerClass showStatus:(BOOL)shouldShow {
    NSInteger index = [self.classArray indexOfObject:viewControllerClass];
    if (index != NSNotFound) {
        BaseTabbarItem *item = [self.buttons objectAtIndex:index];
        item.hideBadge = !shouldShow;
    }
}

- (NSInteger)badgeNumberOfClass:(Class)viewControllerClass {
    NSInteger index = [self.classArray indexOfObject:viewControllerClass];
    if (index != NSNotFound) {
        BaseTabbarItem *item = [self.buttons objectAtIndex:index];
        return item.badgeNumber;
    }
    return 0;
}

- (void)showSmallBadgeWithClass:(Class)viewControllerClass showSmallBadge:(BOOL)show {
    NSInteger index = [self.classArray indexOfObject:viewControllerClass];
    if (index != NSNotFound) {
        BaseTabbarItem *item = [self.buttons objectAtIndex:index];
        item.showSmallBadge = show;
    }
}

#pragma mark - forward rotate support
- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.selectedViewController.preferredStatusBarStyle;
}

- (BOOL)prefersStatusBarHidden {
    return self.selectedViewController.prefersStatusBarHidden;
}

- (BOOL)shouldAutorotate {
    if (!self.selectedViewController) {
        // Return YES for supported orientations
        if (iPad) {
            return YES;
        } else {
            return NO;
        }
    }
    return self.selectedViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (!self.selectedViewController) {
        if (iPad) {
            return UIInterfaceOrientationMaskAll;
        } else {
            return UIInterfaceOrientationMaskPortrait;
        }
    }
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return [self.selectedViewController disablesAutomaticKeyboardDismissal];
}
@end
