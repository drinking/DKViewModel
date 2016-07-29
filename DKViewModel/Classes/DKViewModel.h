//
//  DKViewModel.h
//  Pods
//
//  Created by drinking on 16/7/27.
//
//

#import <Foundation/Foundation.h>

#ifndef BINDFOR
#define BINDSELECTOR(className) NSSelectorFromString([NSString stringWithFormat:@"bindFor%@:",className])
#define BINDFOR(__VMCLZ) \
    - (void)bindFor##__VMCLZ:(__VMCLZ *)vm
#endif

@interface DKViewModel : NSObject
- (void)bind:(UIView *)view;
@end
