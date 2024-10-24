//
//  BridgeCommon.m
//  SLDSBridge
//
//  Created by 王玉松 on 2024/8/5.
//

#import "BridgeCommon.h"



#define kNameSpace @"BridgeCommon"
@implementation BridgeCommon

-(instancetype)init{
    if (self = [super init]) {
        [self setConfig];
    }
    return self;
}

-(void)setConfig{
}

/**
 * app回到前台时调用dsbridge
 * @param dwebview dwebview
 * @param arg 传入的参数
 * @param completionHandler 从dsbridge返回的数据
 */
-(void)appWillBackground:(DWKWebView *)dwebview arg:(NSDictionary * _Nullable)arg completionHandler:(void (^)(id  _Nullable value))completionHandler{
    
    NSString *handler = [NSString stringWithFormat:@"%@.%@",kNameSpace,@"appWillBackground"];
    NSArray *array = @[arg];
    [dwebview callHandler:handler arguments:array completionHandler:^(id _Nullable value) {
        NSLog(@"Namespace BridgeCommon.appWillBackground: %@",value);
        if (completionHandler) {
            completionHandler(value);
        }
    }];
}

/**
 * app回到后台时调用dsbridge
 * @param dwebview dwebview
 * @param arg 传入的参数
 * @param completionHandler 从dsbridge返回的数据
 */
-(void)appWillEnterForeground:(DWKWebView *)dwebview arg:(NSDictionary * _Nullable)arg completionHandler:(void (^)(id  _Nullable value))completionHandler{
    NSArray *array = @[arg];
    NSString *handler = [NSString stringWithFormat:@"%@.%@",kNameSpace,@"appWillEnterForeground"];
    [dwebview callHandler:handler arguments:array completionHandler:^(id _Nullable value) {
         NSLog(@"Namespace BridgeCommon.appWillEnterForeground: %@",value);
        if (completionHandler) {
            completionHandler(value);
        }
    }];
}

/**
 * 网络发送变化时调用dsbridge
 * @param dwebview dwebview
 * @param arg 传入的参数（0：有网，1：无网）
 * @param completionHandler 从dsbridge返回的数据
 */
-(void)netWorkStatus:(DWKWebView *)dwebview arg:(NSInteger)arg completionHandler:(void (^)(id  _Nullable value))completionHandler{
    NSArray *array = @[@(arg)];
    NSString *handler = [NSString stringWithFormat:@"%@.%@",kNameSpace,@"netWorkStatus"];
    [dwebview callHandler:handler arguments:array completionHandler:^(id _Nullable value) {
         NSLog(@"Namespace BridgeCommon.netWorkStatus: %@",value);
        if (completionHandler) {
            completionHandler(value);
        }
    }];
}

//异步API
- (void) testAsyn:(NSString *) msg :(JSCallback)completionHandler
{
    completionHandler([msg stringByAppendingString:@" [ asyn call]"],YES);
}









@end
