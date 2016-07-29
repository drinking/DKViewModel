//
// Created by drinking on 16/7/28.
//

#import "UIView+DKBinder.h"
#import <objc/runtime.h>


@implementation UIView (DKBinder)


- (id)bindedVM {
    objc_getAssociatedObject(self, _cmd);
}

- (void)setBindedVM:(id)bindedVM {
    objc_setAssociatedObject(self, @selector(bindedVM), bindedVM, OBJC_ASSOCIATION_ASSIGN);

}

@end