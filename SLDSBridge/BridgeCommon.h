//
//  BridgeCommon.h
//  SLDSBridge
//
//  Created by 王玉松 on 2024/8/5.
//

#import <Foundation/Foundation.h>
#import "dsbridge.h"
NS_ASSUME_NONNULL_BEGIN

@interface BridgeCommon : NSObject
/**
 * app回到前台时调用dsbridge
 * @param dwebview dwebview
 * @param arg 传入的参数
 * @param completionHandler 从dsbridge返回的数据
 */
-(void)appWillBackground:(DWKWebView *)dwebview arg:(NSDictionary * _Nullable)arg completionHandler:(void (^)(id  _Nullable value))completionHandler;

/**
 * app回到后台时调用dsbridge
 * @param dwebview dwebview
 * @param arg 传入的参数
 * @param completionHandler 从dsbridge返回的数据
 */
-(void)appWillEnterForeground:(DWKWebView *)dwebview arg:(NSDictionary * _Nullable)arg completionHandler:(void (^)(id  _Nullable value))completionHandler;

/**
 * 网络发送变化时调用dsbridge
 * @param dwebview dwebview
 * @param arg 传入的参数（0：有网，1：无网）
 * @param completionHandler 从dsbridge返回的数据
 */
-(void)netWorkStatus:(DWKWebView *)dwebview arg:(NSInteger)arg completionHandler:(void (^)(id  _Nullable value))completionHandler;




@end

NS_ASSUME_NONNULL_END
