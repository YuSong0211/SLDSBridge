//
//  SLBridgeManage.m
//  SLDSBridge
//
//  Created by 王玉松 on 2024/8/13.
//

#import "SLBridgeManage.h"
#import "SLBridgeManage+User.h"
#import "SLBridgeManage+Common.h"
#import "SLBridgeManage+Remark.h"



@interface SLBridgeManage()

@end

@implementation SLBridgeManage

-(instancetype)initDwebview:(DWKWebView *)dwebview{
    if (self = [super init]) {
        self.dwebview = dwebview;
        [self setupConfig];
    }
    return self;
}

-(void)setupConfig{
    
    [self.dwebview addJavascriptObject:[[SLJSUserApi alloc] init] namespace:@"User"];
    [self.dwebview addJavascriptObject:[[SLJSCommonApi alloc] init] namespace:@"Common"];
    [self.dwebview addJavascriptObject:[[SLJSRemarkApi alloc] init] namespace:@"Remark"];
}


@end
