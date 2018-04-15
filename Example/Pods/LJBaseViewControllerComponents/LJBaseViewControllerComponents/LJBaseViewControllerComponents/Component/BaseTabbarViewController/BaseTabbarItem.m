//
//  LJTabbarItem.m
//  LianjiaNG
//
//  Created by Volcno on 15/8/21.
//  Copyright (c) 2015年 Lianjia. All rights reserved.
//

#import "BaseTabbarItem.h"
#import "BaseTabbarModel.h"
#import "UIView+Utils.h"

#define MAX_UNREAD_COUNT  100

@interface BaseTabbarItem()

@property (nonatomic, strong) UILabel *itemTitleLabel;
@property (nonatomic, strong) UIImageView *itemImageView;
@property (nonatomic, strong) UILabel *badgeLabel;
@property (nonatomic, strong) UIView *smallBadgeView;

@end

@implementation BaseTabbarItem

- (void)configTabbarModel:(BaseTabbarModel *)model
{
    _model = model;
    if (!self.itemImageView) {
        CGFloat top = -4;
        self.itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - 44) / 2, 0, 44, 44)];
        self.itemImageView.contentMode = UIViewContentModeCenter;
        self.itemImageView.centerX = self.boxCenterX;
        self.itemImageView.top = top;
        self.itemImageView.frame = CGRectIntegral(self.itemImageView.frame);
        if (self.badgeLabel) {
            [self insertSubview:self.itemImageView belowSubview:self.badgeLabel];
        } else {
            [self addSubview:self.itemImageView];
        }
    }

    if (!self.itemTitleLabel) {
        self.itemTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height - 12 - 4, self.width, 14)];
        self.itemTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.itemTitleLabel.font = [UIFont fontWithName:FONT_OF_NORMAL size:10];
        self.itemTitleLabel.textColor = model.titleColor;
        self.itemTitleLabel.highlightedTextColor = model.selectedTitleColor;
        self.itemTitleLabel.backgroundColor = [UIColor clearColor];
        self.itemTitleLabel.bottom = self.height-4;
        [self addSubview:self.itemTitleLabel];
    }
    NSString *title = model.title;
    UIImage *image = nil;
    UIImage *selectedImage = nil;
    if (model.image && model.selectedImage) {
        image = model.image;
        selectedImage = model.selectedImage;
    }
    self.itemImageView.image = image;
    self.itemImageView.highlightedImage = selectedImage;
    self.itemTitleLabel.text = title;
    [self setNeedsLayout];
}

- (void)setBadgeNumber:(NSInteger)badgeNumber
{
    if (!self.badgeLabel) {
        self.badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
     
        self.badgeLabel.backgroundColor = [UIColor colorWithRed:249*1.0/255 green:0 blue:9*1.0/255 alpha:1];
        self.badgeLabel.textColor = [UIColor whiteColor];
        self.badgeLabel.textAlignment = NSTextAlignmentCenter;
        self.badgeLabel.font = [UIFont fontWithName:FONT_OF_NORMAL size:12];
        self.badgeLabel.layer.cornerRadius = 8;
        self.badgeLabel.layer.masksToBounds = YES;
        [self addSubview:self.badgeLabel];
        CGFloat top = 2;
        self.badgeLabel.top =top;
        self.badgeLabel.right = (self.width + 44) / 2;
    }
    
    _badgeNumber = badgeNumber;
    if (badgeNumber < MAX_UNREAD_COUNT) {
        self.badgeLabel.text = [@(_badgeNumber) stringValue];
    } else {
        self.badgeLabel.text = @"...";
    }
//    [self.badgeLabel sizeToFit];
    if (self.badgeNumber < 10) {
        self.badgeLabel.width = 16;
    } else if (self.badgeNumber < MAX_UNREAD_COUNT) {
        self.badgeLabel.width = 25;
    } else {
        self.badgeLabel.width = 25;
    }
    if (!_hideBadge && _badgeNumber > 0) {
        self.badgeLabel.hidden = false;
    } else {
        self.badgeLabel.hidden = true;
    }
}

- (void)setHideBadge:(BOOL)hideBadge
{
    _hideBadge = !hideBadge;
    if (!_hideBadge && self.badgeNumber > 0) {
        self.badgeLabel.hidden = false;
    } else {
        self.badgeLabel.hidden = true;
    }
}

- (void)setShowSmallBadge:(BOOL)showSmallBadge{
    _showSmallBadge = showSmallBadge;
    if (_showSmallBadge) {
        if (!self.smallBadgeView ) {
            self.smallBadgeView = [[UIView alloc] initWithFrame:CGRectMake(self.itemImageView.right - 11, self.imageView.top + 4, 8, 8)];
            self.smallBadgeView.backgroundColor = [UIColor colorWithRed:249*1.0/255 green:0 blue:9*1.0/255 alpha:1];
            self.smallBadgeView.layer.cornerRadius = 4;
            self.smallBadgeView.layer.masksToBounds = YES;
            [self addSubview:self.smallBadgeView];
        }
    }
    self.smallBadgeView.hidden = !_showSmallBadge;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.itemImageView.centerX != self.boxCenterX) {
        self.itemImageView.centerX = self.boxCenterX;
    }
    if (self.itemTitleLabel.centerX != self.boxCenterX) {
        self.itemTitleLabel.centerX = self.boxCenterX;
    }
    if (self.badgeLabel.right != self.itemImageView.right) {
        self.badgeLabel.right = self.itemImageView.right;
    }
}

@end
