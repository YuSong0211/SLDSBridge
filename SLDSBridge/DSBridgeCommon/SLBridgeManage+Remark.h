//
//  SLBridgeManage+Remark.h
//  HeyLumi
//
//  Created by 王玉松 on 2024/9/4.
//

#import "SLBridgeManage.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLBridgeManage (Remark)

/**
 * app跳转备注web页面调用dsbridge
 * @param arg 传入备注信息{title:@"",content:""}
 * @param completionHandler 从dsbridge返回的数据
 */
-(void)postJSRemarkInfoArg:(NSDictionary * _Nullable)arg completionHandler:(void (^)(id  _Nullable value))completionHandler;
/**
 * 获取js的备注信息，调用dsbridge
 * @param arg 可选
 * @param completionHandler 从dsbridge返回的数据
 */

-(void)getJSRemarkInfoArg:(NSDictionary * _Nullable)arg completionHandler:(void (^)(id  _Nullable value))completionHandler;
@end

typedef void (^kgetRemarkInfoBlock)(NSDictionary *info);

@interface SLJSRemarkApi : NSObject
@property (nonatomic, copy) kgetRemarkInfoBlock getRemarkInfoBlock;//js调app备注信息回调block
@end
NS_ASSUME_NONNULL_END
