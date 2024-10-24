//
//  SLBridgeResponse.m
//  SLDSBridge
//
//  Created by 王玉松 on 2024/8/13.
//

#import "SLBridgeResponse.h"

@implementation SLBridgeResponse

- (NSDictionary *)toDictionary {
    return @{
        @"data": self.data ? self.data : @"",
        @"code": @(self.code),
        @"message":self.message ? self.message : @"",
    };
}

- (NSString *)toJsonString{
    // 将字典转换为 JSON 数据
    NSError *error;
     NSString *jsonString =@"";
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self toDictionary]
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"转换为 JSON 时出错: %@", error.localizedDescription);
        self.message = [NSString stringWithFormat:@"转换为 JSON 时出错: %@", error.localizedDescription];
        self.code = 1001;
    } else {
        // 将 JSON 数据转换为字符串
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"JSON 字符串: %@", jsonString);
    }
    return jsonString;
}
@end
