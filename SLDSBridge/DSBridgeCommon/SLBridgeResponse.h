//
//  SLBridgeResponse.h
//  SLDSBridge
//
//  Created by 王玉松 on 2024/8/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLBridgeResponse : NSObject
//code 0为OK 非0 取message内容
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, copy) NSString *message;

- (NSDictionary *)toDictionary;

- (NSString *)toJsonString;

@end

NS_ASSUME_NONNULL_END
