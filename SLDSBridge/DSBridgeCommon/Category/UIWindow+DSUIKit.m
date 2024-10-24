//
//  UIWindow+DSUIKit.m
//  HeyLumi
//
//  Created by 王玉松 on 2024/8/14.
//

#import "UIWindow+DSUIKit.h"

@implementation UIWindow (DSUIKit)
- (void)ds_setRootViewController:(__kindof UIViewController *)ds_rootViewController{
    if (!ds_rootViewController) {
        return ;
    }
    
    if ([ds_rootViewController isKindOfClass:UINavigationController.class]) {
        UINavigationController *navController = ds_rootViewController;
        if ([self.rootViewController isKindOfClass:navController.viewControllers.firstObject.class]) {
            return ;
        }
    }
    
    self.rootViewController = ds_rootViewController;
    [self makeKeyAndVisible];
    
}

- (UIViewController *)ds_rootViewController{
    return self.rootViewController;
}

+(UIWindow *)ds_getKeyWindow{
    if (@available(iOS 13, *)) {
        NSArray<UIWindow *> *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *window in windows) {
            if (window.isKeyWindow) {
                if ([window ds_layoutInsets].bottom > 0) {
                    return window;
                }
            }
        }
    }else {
        if ([[UIApplication sharedApplication].keyWindow ds_layoutInsets].bottom > 0) {
            return [UIApplication sharedApplication].keyWindow;
        }
    }
    return nil;
}

- (UIEdgeInsets)ds_layoutInsets {
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets safeAreaInsets = self.safeAreaInsets;
        if (safeAreaInsets.bottom > 0) {
            
            return safeAreaInsets;
        }
        return UIEdgeInsetsMake(20, 0, 0, 0);
    }
    return UIEdgeInsetsMake(20, 0, 0, 0);
}

- (CGFloat)ds_navigationHeight {
    CGFloat statusBarHeight = [self ds_layoutInsets].top;
    return statusBarHeight + 44;
}
@end
