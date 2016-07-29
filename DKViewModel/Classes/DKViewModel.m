//
//  DKViewModel.m
//  Pods
//
//  Created by drinking on 16/7/27.
//
//

#import "DKViewModel.h"

@implementation DKViewModel


- (void)bind:(UIView *)view {
    NSString *name = NSStringFromClass([view class]);
    SEL sel = BINDSELECTOR(name);
    NSLog(@"preparing to bind instance of %@", name);
    if ([self respondsToSelector:sel]) {
        NSLog(@"binding instance of %@", name);
        [self performSelector:sel withObject:view];
    } else {
#ifdef DEBUG
        NSAssert(NO, @"binding method not found for :%@", name);
#endif
    }

}
@end
