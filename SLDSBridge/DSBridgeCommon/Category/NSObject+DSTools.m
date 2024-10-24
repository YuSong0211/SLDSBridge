//
//  NSObject+DSTools.m
//  HeyLumi
//
//  Created by 王玉松 on 2024/8/15.
//

#import "NSObject+DSTools.h"
#import "NetworkConfig.h"

@implementation NSObject (DSTools)
/**
 * 获取H5的公参（白名单内的才会添加公参）
 * @param webUrl 请求的url
 */
+ (NSDictionary *)getHtmlCustomHeaderField:(NSString *)webUrl{
    if (![self inWhiteList:webUrl]) {
        return [[NetworkConfig shareNetworkConfig] getCommonHeader];
    }
    return nil;
}

+ (BOOL)inWhiteList:(NSString *)webUrl{
    if (webUrl.length == 0) {
        return NO;
    }
    //符合Url规则
    NSURL *url = [[NSURL alloc] initWithString:webUrl];
    if (!url) {
        return NO;
    }
    NSArray * customHeaderArray = [NSArray arrayWithObjects:SLBaseH5Url,SLBaseAPIUrl, nil];
    for (NSString * kurl in customHeaderArray) {
        //白名单
        if ([webUrl containsString:kurl]) {
            return YES;
            break;
        }
    }
    return NO;
}
@end
