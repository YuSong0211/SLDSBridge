//
//  TESTKWebViewController.m
//  HeyLumi
//
//  Created by 王玉松 on 2024/8/14.
//

#import "TESTKWebViewController.h"

@interface TESTKWebViewController ()

@end

@implementation TESTKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // load test.html
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"test"
                                                          ofType:@"html"];
    NSString * htmlContent = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
//    [self.dwebview loadHTMLString:htmlContent baseURL:baseURL];
    
    [self loadWebPageWithURL:@"https://test-static.heylumi.ai/dsbridge/index.html"];
    
    
    
 
   
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
    [self.dwebManage appWillBackgroundArg:@{@"name":@"yusong"} completionHandler:^(id  _Nullable value) {
        NSLog(@"%@",value);
    }];
    
    [self.dwebManage appWillEnterForegroundArg:nil completionHandler:^(id  _Nullable value) {
        NSLog(@"%@",value);
    }];
}

@end
