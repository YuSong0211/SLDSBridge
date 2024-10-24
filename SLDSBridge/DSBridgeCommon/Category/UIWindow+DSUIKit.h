//
//  UIWindow+DSUIKit.h
//  HeyLumi
//
//  Created by 王玉松 on 2024/8/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (DSUIKit)
@property (strong, nonatomic, setter=ds_setRootViewController:) __kindof UIViewController *ds_rootViewController;

- (UIEdgeInsets)ds_layoutInsets;

- (CGFloat)ds_navigationHeight;

+ (UIWindow *)ds_getKeyWindow;
@end

NS_ASSUME_NONNULL_END
