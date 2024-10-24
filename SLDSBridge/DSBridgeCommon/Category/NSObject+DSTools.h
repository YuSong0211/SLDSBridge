//
//  NSObject+DSTools.h
//  HeyLumi
//
//  Created by 王玉松 on 2024/8/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (DSTools)
/**
 * 获取H5的公参（白名单内的才会添加公参）
 * @param webUrl 请求的url
 */
+ (NSDictionary *)getHtmlCustomHeaderField:(NSString *)webUrl;
@end

NS_ASSUME_NONNULL_END
