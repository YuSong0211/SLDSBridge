//
//  SLBridgeManage.h
//  SLDSBridge
//
//  Created by 王玉松 on 2024/8/13.
//

#import <Foundation/Foundation.h>
#import "dsbridge.h"
#import "SLBridgeResponse.h"
NS_ASSUME_NONNULL_BEGIN

@interface SLBridgeManage : NSObject
@property (nonatomic, strong) DWKWebView *dwebview;

-(instancetype)initDwebview:(DWKWebView *)dwebview;
@end

NS_ASSUME_NONNULL_END
