//
//  NSString+dwebToots.m
//  HeyLumi
//
//  Created by 王玉松 on 2024/8/14.
//

#import "NSString+dwebToots.h"
#import <sys/utsname.h>
#import "UIWindow+DSUIKit.h"

#define kLumiDeviceIdKey @"kLumiDeviceIdKey"

@implementation NSString (dwebToots)


+ (NSMutableDictionary *)getCommonParam{
    //配置公共header
    NSMutableDictionary *headerParams = [NSMutableDictionary dictionaryWithCapacity:0];
    //临时Host
    [headerParams setObject:@"http://qa.heylumi.ai" forKey:@"Host"];
    //设备唯一标识，使用uuid生成并存储在钥匙串中
    [headerParams setObject:[NSString getDeviceId] forKey:@"X-DeviceId"];
    //产品编号
    [headerParams setObject:[NSString getMachineId] forKey:@"X-MachineId"];
    //平台
    [headerParams setObject:@"1" forKey:@"X-Platform"];
    //平台版本号
    [headerParams setObject:[NSString convertNull:[UIDevice currentDevice].systemVersion] forKey:@"X-PlatformVersion"];
    //App版本号
    [headerParams setObject:[NSString convertNull:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]] forKey:@"X-AppVersion"];
    //当前系统时区
    [headerParams setObject:[NSString getTimeZoneName] forKey:@"X-Time-Zone"];
    //国家
    [headerParams setObject:[NSString getCountryCode] forKey:@"X-Country"];
    //logId
    [headerParams setObject:[NSString convertNull:@""] forKey:@"X-LogId"];
    //渠道号
    [headerParams setObject:@"App Store" forKey:@"X-ChannelId"];
    //pushId
    NSString *pushId = [[NSUserDefaults standardUserDefaults] objectForKey:kSavePushIdKey];
    [headerParams setObject:[NSString convertNull:pushId] forKey:@"X-PushId"];
    //分辨率
    NSString *pixel = [NSString stringWithFormat:@"%.0f*%.0f",[[UIScreen mainScreen] bounds].size.width * [UIScreen mainScreen].scale, [[UIScreen mainScreen] bounds].size.height * [UIScreen mainScreen].scale];
    [headerParams setObject:[NSString convertNull:pixel] forKey:@"X-ScreenResolution"];
    //当前系统语言
    [headerParams setObject:[NSString getLanguageCode] forKey:@"X-Language"];
    /// 是否为刘海屏
    [headerParams setObject:@([NSString hasNotch]) forKey:@"X-hasNotch"];

    return headerParams;
}


/**
 * 获取当前设备唯一标识
 */
+ (NSString *)getDeviceId{
    UICKeyChainStore *keyChain = [UICKeyChainStore keyChainStoreWithService:[UICKeyChainStore defaultService]];
    NSString *deviceId = [keyChain stringForKey:kLumiDeviceIdKey];
    if (deviceId.length > 0) {
        return deviceId;
    }
    CFUUIDRef uuid = CFUUIDCreate(nil);
    NSString *uuidString = CFBridgingRelease(CFUUIDCreateString(nil, uuid));
    deviceId = [uuidString mutableCopy];
    CFRelease(uuid);
    if (deviceId.length > 0) {
        UICKeyChainStore *keyChain = [UICKeyChainStore keyChainStoreWithService:[UICKeyChainStore defaultService]];
        [keyChain setString:deviceId forKey:kLumiDeviceIdKey];
    }
    return [self convertNull:deviceId];
}

/**
 * 设备machine编号
 */
+ (NSString *)getMachineId;{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *machine = [NSString stringWithCString:systemInfo.machine
                                            encoding:NSUTF8StringEncoding];
    return [self convertNull:machine];
}

/**
 * 获取当前系统语言
 */
+ (NSString *)getLanguageCode{
    //全部语言
    NSString *languageCode = [NSLocale preferredLanguages][0];// 返回的也是国际通用语言Code+国际通用国家地区代码
    NSString *countryCode = [NSString stringWithFormat:@"-%@", [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode]];
    if (languageCode) {
        languageCode = [languageCode stringByReplacingOccurrencesOfString:countryCode withString:@""];
    }
    return [self convertNull:languageCode];
}

/**
 * 当前时区
 */
+ (NSString *)getTimeZoneName{
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    return [self convertNull:timeZone.name];
}

/**
 * 当前系统国家
 */
+ (NSString *)getCountryCode{
    NSString *countryCode = [NSString stringWithFormat:@"%@", [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode]];
    return [self convertNull:countryCode];
}


+ (NSString *)convertNull:(id)object{
    // 转换空串
    if ([object isEqual:[NSNull null]]){
        return @"";
    }
    else if ([object isKindOfClass:[NSNull class]]){
        return @"";
    }else if (object==nil){
        return @"";
    }
    return object;
    
}

/// 是否为刘海屏
+ (BOOL)hasNotch {
    static BOOL _hasNotch = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
            _hasNotch = NO;
            return;
        }
        
        if (@available(iOS 13, *)) {
            NSArray<UIWindow *> *windows = [[UIApplication sharedApplication] windows];
            for (UIWindow *window in windows) {
                if (window.isKeyWindow) {
                    if ([window ds_layoutInsets].bottom > 0) {
                        _hasNotch = YES;
                    }
                }
            }
        }else {
            if ([[UIApplication sharedApplication].keyWindow ds_layoutInsets].bottom > 0) {
                _hasNotch = YES;
            }        }
        
    });
    return _hasNotch;
}


// 获得Info.plist数据字典
+ (NSDictionary *)tz_getInfoDictionary {
    NSDictionary *infoDict = [NSBundle mainBundle].localizedInfoDictionary;
    if (!infoDict || !infoDict.count) {
        infoDict = [NSBundle mainBundle].infoDictionary;
    }
    if (!infoDict || !infoDict.count) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        infoDict = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return infoDict ? infoDict : @{};
}

@end
