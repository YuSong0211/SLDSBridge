//
//  SLDWKWebViewController.h
//  SLDSBridge
//
//  Created by 王玉松 on 2024/8/13.
//

#import <UIKit/UIKit.h>
#import "SLBaseViewController.h"
#import "DWKWebView.h"
#import "SLBridgeManage.h"
#import "DSBridgeCommon.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLDWKWebViewController : SLBaseViewController <WKNavigationDelegate>

@property (nonatomic, strong) DWKWebView *dwebview;
@property (nonatomic, strong)  SLBridgeManage *dwebManage;
- (void)loadWebPageWithURL:(NSString *)urlString;
//- (void)injectJavaScriptParameters;

@end

NS_ASSUME_NONNULL_END
