//
//  SLDWKWebViewController.m
//  SLDSBridge
//
//  Created by 王玉松 on 2024/8/13.
//

#import "SLDWKWebViewController.h"
//#import "NetworkConfig.h"
#import "NSObject+DSTools.h"

@interface SLDWKWebViewController ()

@end

/* 注入Cookie js脚本
*  暂时不知道HttpOnly
*  不设置不知道会不会有影响
*/
#define kInjectLocalCookieScript @"function setCookieFromApp(name, value, expires, path, domain, secure)\
{\
var argv = arguments;\
var argc = arguments.length;\
var now = new Date();\
var expires = (argc > 2) ? new Date(new Date().getTime() + parseInt(expires) * 24 * 60 * 60 * 1000) : new Date(now.getFullYear(), now.getMonth() + 1, now.getUTCDate());\
var path = (argc > 3) ? argv[3] : '/';\
var domain = (argc > 4) ? argv[4] :'';\
var secure = (argc > 5) ? argv[5] : false;\
var httpOnly = (argc > 6) ? argv[6] : false;\
document.cookie = name + '=' + value + ((expires == null) ? '' : ('; expires=' + expires.toGMTString())) + ((path == null) ? '' : ('; path=' + path)) + ((domain == null) ? '' : ('; domain=' + domain)) + ((secure == true) ? '; secure' : '');\
};\
"
@implementation SLDWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

     WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
     self.dwebview = [[DWKWebView alloc] initWithFrame:CGRectMake(0, 88, self.view.bounds.size.width, self.view.bounds.size.height - 88) configuration:config];
     self.dwebview.navigationDelegate = self;
     [self.view addSubview:self.dwebview];
    SLBridgeManage *dwebManage = [[SLBridgeManage alloc]initDwebview:self.dwebview];
    self.dwebManage = dwebManage;
 
}

- (void)loadWebPageWithURL:(NSString *)urlString {

    NSDictionary *customHeaderField = [NSObject getHtmlCustomHeaderField:urlString];
    NSMutableString *urlWithParams = [NSMutableString stringWithString:urlString];
    [urlWithParams appendString:@"?"];
    for (NSString *key in customHeaderField) {
        NSString *value = [customHeaderField objectForKey:key];
        NSString *encodedValue = [value stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [urlWithParams appendFormat:@"%@=%@&", key, encodedValue];
    }
    // Remove the last "&"
    [urlWithParams deleteCharactersInRange:NSMakeRange(urlWithParams.length - 1, 1)];
    NSURL *url = [NSURL URLWithString:urlWithParams];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:10.f];
//    for (NSString *httpHeaderField in customHeaderField.allKeys) {
//        NSString *value = [NSString stringWithFormat:@"%@",customHeaderField[httpHeaderField]];
//        if (value) {
//            [request addValue:value forHTTPHeaderField:httpHeaderField];
//        }
//    }
    if (request) {
        //重新添加Cookie WKWebView 不会带上cookie 需要同时在request上添加以及使用脚本添加
        [self injectCookies:request];
        [self.dwebview loadRequest:request];
    }
}

- (void)injectCookies:(NSMutableURLRequest *)request{
    [self resetCookieForHeaderFields:request];
    [self addUserCookieScript:request];
}

// 修改请求头的Cookie
- (void)resetCookieForHeaderFields:(NSMutableURLRequest *)request{
    NSArray *cookies = [self currentCookies:request];
    NSDictionary *requestHeaderFields = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    request.allHTTPHeaderFields = requestHeaderFields;
}

/// 通过脚本出入cookie
- (void)addUserCookieScript:(NSURLRequest *)request{
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    if (!cookies || cookies.count < 1) {
        return;
    }
    NSString *cookieScript = [self injectLocalCookieScript];
    WKUserScript *startScript = [[WKUserScript alloc]initWithSource:cookieScript injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [self.dwebview.configuration.userContentController addUserScript:startScript];
}

- (NSString *)injectLocalCookieScript{
    NSString *jsString = kInjectLocalCookieScript;
    NSMutableString *cookieScript = [NSMutableString stringWithString:jsString];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookies) {
        if ([cookie.name isEqualToString:@"jk"]) {//不添加本地jk，一般页面会写入jk
            continue;
        }
        NSString *name = cookie.name ?: @"";
        NSString *value = cookie.value ?: @"";
        NSString *domain = cookie.domain ?: @"";
        NSString *path = cookie.path ?: @"/";
        NSString *secure = cookie.secure ?@"true": @"false";
        NSInteger days = 1;
        if (cookie.expiresDate) {
            NSTimeInterval seconds = [cookie.expiresDate timeIntervalSinceNow];
            days = seconds/3600/24;
        }
        [cookieScript appendString:[NSString stringWithFormat:@"setCookieFromApp('%@', '%@', %ld, '%@','%@', %@);",name,value,(long)days,path,domain,secure]];
    }
    return cookieScript;
}

// 获取当前域名下的cookie
- (NSArray *)currentCookies:(NSMutableURLRequest *)request{
    NSArray *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
    NSString *validDomain = request.URL.host;
    NSMutableArray *mutableArr = [NSMutableArray array];
    for (NSHTTPCookie *cookie in cookies) {
        if (![validDomain hasSuffix:cookie.domain]) {
            continue;
        }
        [mutableArr addObject:cookie];
    }
    return mutableArr;
}


//- (void)injectJavaScriptParameters {

//    NSDictionary *dict = [[NetworkConfig shareNetworkConfig] getCommonHeader];
//    NSError *error;
//     NSString *jsonString =@"";
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
//                                                       options:NSJSONWritingPrettyPrinted
//                                                         error:&error];
//    if (!jsonData) {
//        NSLog(@"转换为 JSON 时出错: %@", error.localizedDescription);
//        jsonString = [NSString stringWithFormat:@"转换为 JSON 时出错: %@", error.localizedDescription];
//    } else {
//        // 将 JSON 数据转换为字符串
//        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        NSLog(@"JSON 字符串: %@", jsonString);
//    }
//
//     [self.dwebview evaluateJavaScript:jsonString completionHandler:^(id _Nullable result, NSError * _Nullable error) {
//         if (error) {
//             NSLog(@"Error: %@", error.localizedDescription);
//         }
//     }];
//}


// 网页加载完成后注入 JavaScript
//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    [self injectJavaScriptParameters];
//}


@end
