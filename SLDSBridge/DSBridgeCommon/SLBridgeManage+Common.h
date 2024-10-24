//
//  SLBridgeManage+Common.h
//  SLDSBridge
//
//  Created by 王玉松 on 2024/8/13.
//

#import "SLBridgeManage.h"
#import "dsbridge.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLBridgeManage (Common)
/**
 * app回到后台时调用dsbridge
 * @param arg 传入的参数
 * @param completionHandler 从dsbridge返回的数据
 */
-(void)appWillBackgroundArg:(NSDictionary * _Nullable)arg completionHandler:(void (^)(id  _Nullable value))completionHandler;

/**
 * app回到前台时调用dsbridge
 * @param arg 传入的参数
 * @param completionHandler 从dsbridge返回的数据
 */
-(void)appWillEnterForegroundArg:(NSDictionary * _Nullable)arg completionHandler:(void (^)(id  _Nullable value))completionHandler;

/**
 * 网络发送变化时调用dsbridge
 * @param arg 传入的参数（0：有网，1：无网）
 * @param completionHandler 从dsbridge返回的数据
 */
-(void)netWorkStatusArg:(NSInteger)arg completionHandler:(void (^)(id  _Nullable value))completionHandler;

/**
 * 推送信息 app主动调dsbridge
 * @param arg 传入的参数
 * @param completionHandler 从dsbridge返回的数据
 */
-(void)apnsRemoteNotificationArg:(NSDictionary * _Nullable)arg completionHandler:(void (^)(id  _Nullable value))completionHandler;

@end

#define kH5pushSettingViewNotification @"kH5pushSettingViewNotification"

typedef void (^kisHiddenBlock)(NSInteger isHidden);

@interface SLJSCommonApi : NSObject

@property (nonatomic, copy) kisHiddenBlock isHiddenBlock;
@property (nonatomic, copy) void(^hanlder)(id value,BOOL isComplete);
@property (nonatomic, copy) void(^dismissH5Block)(NSDictionary *arg);

///**
// * 获取device信息（同步）
// * @param arg 传入的参数
// */
//-(id)getDeviceInfo:(id)arg;
-(void)getH5IsHideNavBar:(void (^)(NSInteger isHidden))isHiddenBlock;
-(void)callProgress:(CGFloat)progress;

@end
NS_ASSUME_NONNULL_END
