//
//  NSString+dwebToots.h
//  HeyLumi
//
//  Created by 王玉松 on 2024/8/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (dwebToots)

+ (NSMutableDictionary *)getCommonParam;

+ (NSString *)convertNull:(id)object;
/**
 * 获取当前设备唯一标识
 */
+ (NSString *)getDeviceId;

/**
 * 设备machine编号
 */
+ (NSString *)getMachineId;

/**
 * 获取当前系统语言
 */
+ (NSString *)getLanguageCode;

/**
 * 当前系统时区
 */
+ (NSString *)getTimeZoneName;

/**
 * 当前系统国家
 */
+ (NSString *)getCountryCode;

// 获得Info.plist数据字典
+ (NSDictionary *)tz_getInfoDictionary;
@end

NS_ASSUME_NONNULL_END
