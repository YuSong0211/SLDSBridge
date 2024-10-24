//
//  SLBridgeManage+Remark.m
//  HeyLumi
//
//  Created by 王玉松 on 2024/9/4.
//

#import "SLBridgeManage+Remark.h"
#define kNameSpace         @"Remark"
#define kpostRemarkInfoArg @"postRemarkInfoArg"//app回到前台时调用dsbridge
#define kgetRemarkInfoArg  @"kgetRemarkInfoArg"
@implementation SLBridgeManage (Remark)

/**
 * app传给js备注信息，调用dsbridge
 * @param arg 传入备注信息{title:@"",content:""}
 * @param completionHandler 从dsbridge返回的数据
 */

-(void)postJSRemarkInfoArg:(NSDictionary * _Nullable)arg completionHandler:(void (^)(id  _Nullable value))completionHandler{
    NSArray *array;
    if (arg) {
        array = @[arg];
    }
    NSString *handler = [NSString stringWithFormat:@"%@.%@",kNameSpace,kpostRemarkInfoArg];
    [self.dwebview callHandler:handler arguments:array completionHandler:^(id _Nullable value) {
         NSLog(@"Namespace Remark.postJSRemarkInfoArg: %@",value);
        if (completionHandler) {
            completionHandler(value);
        }
    }];
    
}


/**
 * 获取js的备注信息，调用dsbridge
 * @param arg 可选
 * @param completionHandler 从dsbridge返回的数据
 */

-(void)getJSRemarkInfoArg:(NSDictionary * _Nullable)arg completionHandler:(void (^)(id  _Nullable value))completionHandler{
    NSArray *array;
    if (arg) {
        array = @[arg];
    }
    NSString *handler = [NSString stringWithFormat:@"%@.%@",kNameSpace,kgetRemarkInfoArg];
    [self.dwebview callHandler:handler arguments:array completionHandler:^(id _Nullable value) {
         NSLog(@"Namespace Remark.getRemarkInfoArg: %@",value);
        if (completionHandler) {
            completionHandler(value);
        }
    }];
    
}

@end


@implementation SLJSRemarkApi

/**
 * js传给app备注信息（同步）
 * @param arg 传入备注信息{title:@"",content:""}
 */
- (id)postAPPRemarkInfoArg:(NSDictionary *)arg{
    if (self.getRemarkInfoBlock) {
        self.getRemarkInfoBlock(arg);
    }
    SLBridgeResponse * response = [SLBridgeResponse new];
    NSString *jsonString = [response toJsonString];
    return jsonString;
}



@end
