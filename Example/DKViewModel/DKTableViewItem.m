//
//  DKTableViewItem.m
//  DKViewModel_Example
//
//  Created by drinking on 2018/4/12.
//  Copyright © 2018年 drinking. All rights reserved.
//

#import "DKTableViewItem.h"

@implementation DKTableViewItem


- (id<NSObject>)diffIdentifier {
    return self.text;
}

- (BOOL)isEqualToDiffableObject:(nullable id<IGListDiffable>)object {
    return [self.text isEqualToString:(NSString *)object.diffIdentifier];
}

@end
