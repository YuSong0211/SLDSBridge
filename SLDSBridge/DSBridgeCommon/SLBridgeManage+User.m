//
//  SLBridgeManage+User.m
//  SLDSBridge
//
//  Created by 王玉松 on 2024/8/13.
//

#import "SLBridgeManage+User.h"
#import "UserInfoModuleCompent.h"
@implementation SLBridgeManage (User)

@end


@implementation SLJSUserApi
/**
 * 获取用户信息（同步）
 * @param arg 传入的参数
 */
- (id)getUserInfo:(NSDictionary *)arg{
    
    SLBridgeResponse * response = [SLBridgeResponse new];
    SLUserInfoModel *userInfo = [[CTMediator sharedInstance] queryCurrentUserInfo];
    response.data = [userInfo toDictionary];
    NSString *jsonString = [response toJsonString];
    return jsonString;
}

/**
 * 获取用户信息  (异步)
 * @param arg 传入的参数
 * @param completionHandler 从dsbridge返回的数据
 */
- (void)getUserInfo: (NSDictionary *)arg completion:(JSCallback)completionHandler{
    SLBridgeResponse * response = [SLBridgeResponse new];
    SLUserInfoModel *userInfo = [[CTMediator sharedInstance] queryCurrentUserInfo];
    response.data = [userInfo toDictionary];
    NSString *jsonString = [response toJsonString];
    dispatch_async(dispatch_get_main_queue(), ^{
        completionHandler(jsonString,YES);
    });    
}


/**
 * 是否登录  (异步)
 * @param arg 传入的参数
 * @param completionHandler 从dsbridge返回的数据
 */
- (void)getIsLogin:(NSDictionary *)arg completion:(JSCallback)completionHandler{
    SLBridgeResponse * response = [SLBridgeResponse new];
    SLUserInfoModel *userInfo = [[CTMediator sharedInstance] queryCurrentUserInfo];
    if (userInfo.token.length > 0 ) {
        response.data = @{@"login":@(1),};;
    }else{
        response.data = @{@"login":@(0),};;
    }
    NSString *jsonString = [response toJsonString];
    completionHandler(jsonString,YES);
}

@end
