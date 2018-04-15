//
//  DKTableViewItem.h
//  DKViewModel_Example
//
//  Created by drinking on 2018/4/12.
//  Copyright © 2018年 drinking. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IGListKit/IGListKit.h>

@interface DKTableViewItem : NSObject<IGListDiffable>

@property (nonatomic,copy) NSString *text;
@property (nonatomic,assign) NSInteger index;

@end
