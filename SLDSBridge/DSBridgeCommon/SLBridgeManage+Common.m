//
//  SLBridgeManage+Common.m
//  SLDSBridge
//
//  Created by 王玉松 on 2024/8/13.
//

#import "SLBridgeManage+Common.h"
#import "NSString+dwebToots.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <PhotosUI/PhotosUI.h>
#import "UIWindow+DSUIKit.h"
#import <CoreBluetooth/CoreBluetooth.h>




#define kNameSpace         @"Common"
#define kappWillBackground @"appWillBackground"//app回到前台时调用dsbridge
#define kappWillEnterForeground   @"appWillEnterForeground" //app回到后台时调用dsbridge
#define knetWorkStatus       @"netWorkStatus" //网络发送变化时调用dsbridge

@implementation SLBridgeManage (Common)

/**
 * app回到后台时调用dsbridge
 * @param arg 传入的参数
 * @param completionHandler 从dsbridge返回的数据
 */
-(void)appWillBackgroundArg:(NSDictionary * _Nullable)arg completionHandler:(void (^)(id  _Nullable value))completionHandler{
    
    NSString *handler = [NSString stringWithFormat:@"%@.%@",kNameSpace,kappWillBackground];
    NSArray *array;
    if (arg) {
        array = @[arg];
    }
    [self.dwebview callHandler:handler arguments:array completionHandler:^(id _Nullable value) {
        NSLog(@"Namespace Common.appWillBackground: %@",value);
        if (completionHandler) {
            completionHandler(value);
        }
    }];
}

/**
 * app回到前台时调用dsbridge
 * @param arg 传入的参数
 * @param completionHandler 从dsbridge返回的数据
 */
-(void)appWillEnterForegroundArg:(NSDictionary * _Nullable)arg completionHandler:(void (^)(id  _Nullable value))completionHandler{
    NSArray *array;
    if (arg) {
        array = @[arg];
    }
    NSString *handler = [NSString stringWithFormat:@"%@.%@",kNameSpace,kappWillEnterForeground];
    [self.dwebview callHandler:handler arguments:array completionHandler:^(id _Nullable value) {
         NSLog(@"Namespace Common.appWillEnterForeground: %@",value);
        if (completionHandler) {
            completionHandler(value);
        }
    }];
}

/**
 * 网络发送变化时调用dsbridge
 * @param arg 传入的参数（0：有网，1：无网）
 * @param completionHandler 从dsbridge返回的数据
 */
-(void)netWorkStatusArg:(NSInteger)arg completionHandler:(void (^)(id  _Nullable value))completionHandler{
    NSArray *array = @[@(arg)];
    NSString *handler = [NSString stringWithFormat:@"%@.%@",kNameSpace,knetWorkStatus];
    [self.dwebview callHandler:handler arguments:array completionHandler:^(id _Nullable value) {
         NSLog(@"Namespace Common.netWorkStatus: %@",value);
        if (completionHandler) {
            completionHandler(value);
        }
    }];
}


/**
 * 推送信息 app主动调dsbridge
 * @param arg 传入的参数
 * @param completionHandler 从dsbridge返回的数据
 */
-(void)apnsRemoteNotificationArg:(NSDictionary * _Nullable)arg completionHandler:(void (^)(id  _Nullable value))completionHandler{
    NSArray *array = @[arg];
    NSString *handler = [NSString stringWithFormat:@"%@.%@",kNameSpace,knetWorkStatus];
    [self.dwebview callHandler:handler arguments:array completionHandler:^(id _Nullable value) {
         NSLog(@"Namespace Common.netWorkStatus: %@",value);
        if (completionHandler) {
            completionHandler(value);
        }
    }];
}


@end

@interface SLJSCommonApi()<CBCentralManagerDelegate>
@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, copy) JSCallback bluetoothBlock;


@end

@implementation SLJSCommonApi

/**
 * 获取APP信息（同步）
 * @param arg 传入的参数
 */
-(id)getAppInfo:(NSDictionary *)arg{
 
    SLBridgeResponse * response = [SLBridgeResponse new];
    NSMutableDictionary *dict = [NSString getCommonParam];
    response.data = dict;
    NSString *jsonString = [response toJsonString];
    return jsonString;
}

/**
 * 获取相机权限
* @param arg 传入的参数
 */
-(id)getPhotoAuthorizationStatus:(NSDictionary *)arg{
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied:
        {
            //无权限
            NSDictionary *infoDict = [NSString tz_getInfoDictionary];
            NSString *appName = [infoDict valueForKey:@"CFBundleDisplayName"];
            if (!appName){
                appName = [infoDict valueForKey:@"CFBundleName"];
            }
            NSString *message = [NSString stringWithFormat:@"%@",kLocalizedString(@"请前往\"设置\"->\"隐私\"->\"相机\"授予Lumi相机使用权限吧")];
            SLAlertViewController *alertController = [SLAlertViewController alertControllerWithTitle:NSLocalizedString(@"无法访问您的相机", nil) message:message];
            //取消
            [alertController addAction:[SLAlertActionButton actionWithTitle:kLocalizedString(@"取消") style:SLAlertActionStyleDefault handler:^(SLAlertActionButton * _Nonnull action) {
                
            }]];
            //设置
            [alertController addAction:[SLAlertActionButton actionWithTitle:kLocalizedString(@"去设置") style:SLAlertActionStyleConfirm handler:^(SLAlertActionButton * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
                    
                }];
            }]];
            [alertController show];
        }
        break;
        case AVAuthorizationStatusNotDetermined:
        {
            //防止用户首次拍照拒绝授权时相机页黑屏
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                     completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_main_async_safe(^{
                        [self pushImagePickerController:UIImagePickerControllerCameraDeviceRear];
                    });
                }
            }];
        }break;
        case AVAuthorizationStatusAuthorized:
        {
            dispatch_main_async_safe(^{
                [self pushImagePickerController:UIImagePickerControllerCameraDeviceRear];
            });
        }break;
          default:
            break;
    }
    /*
     AVAuthorizationStatusNotDetermined：用户尚未对此应用程序进行授权选择。
     AVAuthorizationStatusRestricted：应用程序没有权限访问媒体类型，且用户无法更改此应用的状态。
     AVAuthorizationStatusDenied：用户明确拒绝了此应用程序访问媒体类型的请求。
     AVAuthorizationStatusAuthorized：用户已授权此应用程序访问媒体类型。
     */
    SLBridgeResponse * response = [SLBridgeResponse new];
    response.data = @{@"isPermissions ":@(status)};
    NSString *jsonString = [response toJsonString];
    return jsonString;
}

- (void)pushImagePickerController:(UIImagePickerControllerCameraDevice)cameraDevice{
    if ([UIImagePickerController isCameraDeviceAvailable:cameraDevice]) {
        // 使用UIImagePickerControllerSourceTypePhotoLibrary 会造成内存泄漏
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//        imagePicker.delegate = self;
        imagePicker.allowsEditing = NO;
    //    imagePicker.allowsEditing = !self.hideEditView;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.cameraDevice = cameraDevice;
        [[UIWindow ds_getKeyWindow].ds_rootViewController presentViewController:imagePicker
                                   animated:YES
                                 completion:nil];
    }else{
        DLog(@"不支持当前硬件设备");
        SLAlertViewController *alertController = [SLAlertViewController alertControllerWithTitle:NSLocalizedString(@"设备故障", nil)
                                                                                 message:NSLocalizedString(@"无法使用您的相机硬件", nil)];
        //我知道了
        [alertController addAction:[SLAlertActionButton actionWithTitle:NSLocalizedString(@"我知道了", nil) style:SLAlertActionStyleConfirm handler:^(SLAlertActionButton * _Nonnull action) {
            
        }]];
        [alertController show];
    }

    
}

/**
 * 储存相册
 */
- (id)getTakePhotoFromLibrary:(NSDictionary *)arg{
    //权限判定
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusNotDetermined:
        {
        }break;
        case PHAuthorizationStatusDenied:
        {
            //无权限
            NSDictionary *infoDict = [NSString tz_getInfoDictionary];
            NSString *appName = [infoDict valueForKey:@"CFBundleDisplayName"];
            if (!appName){
                appName = [infoDict valueForKey:@"CFBundleName"];
            }
            NSString *message = [NSString stringWithFormat:@"%@",NSLocalizedString(@"请前往\"设置\"->\"隐私\"->\"相册\"授予Lumi相册使用权限吧！", nil)];
            SLAlertViewController *alertController = [SLAlertViewController alertControllerWithTitle:NSLocalizedString(@"无法访问您的相册", nil)
                                                                                             message:message];
            //取消
            [alertController addAction:[SLAlertActionButton actionWithTitle:NSLocalizedString(@"取消", nil) style:SLAlertActionStyleDefault handler:^(SLAlertActionButton * _Nonnull action) {
                
            }]];
            //设置
            [alertController addAction:[SLAlertActionButton actionWithTitle:NSLocalizedString(@"去设置", nil) style:SLAlertActionStyleConfirm handler:^(SLAlertActionButton * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
                    
                }];
            }]];
            [alertController show];
        }break;
        case PHAuthorizationStatusLimited:
        case PHAuthorizationStatusAuthorized:
        {
        }break;
        default:
            break;
    }
    SLBridgeResponse * response = [SLBridgeResponse new];
    response.data = @{@"isPermissions ":@(status)};
    NSString *jsonString = [response toJsonString];
    return jsonString;
}

/**
 * 麦克风
 */
- (id)getAudioMediaAuthStatus:(NSDictionary *)arg{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (authStatus) {
        //未授权
        case AVAuthorizationStatusNotDetermined:
        {
            NSLog(@"未授权");
        }break;
        //家长控制
        case AVAuthorizationStatusRestricted:
        {
           
                NSLog(@"麦克风未授权，请实现AVAuthorizationStatusRestricted协议,对用户进行授权引导");
        }break;
        //不允许
        case AVAuthorizationStatusDenied:
        {
         
            NSLog(@"麦克风未授权，请实现AVAuthorizationStatusRestricted协议,对用户进行授权引导");
            
        }break;
        //已授权
        case AVAuthorizationStatusAuthorized:
        {
            
        }
        default:
            break;
    }
    SLBridgeResponse * response = [SLBridgeResponse new];
    response.data = @{@"isPermissions ":@(authStatus)};
    NSString *jsonString = [response toJsonString];
    return jsonString;
}

-(void)getH5IsHideNavBar:(void (^)(NSInteger isHidden))isHiddenBlock{
    self.isHiddenBlock = isHiddenBlock;
}

/**
 * 导航栏 隐藏or显示
 */
- (id)getIsHideNavBar:(NSDictionary *)arg{
    NSInteger isHidden = [arg[@"isHidden"] integerValue];
    if (isHidden) {
        NSLog(@"隐藏");
    }else{
        NSLog(@"显示");
    }
    if (self.isHiddenBlock) {
        self.isHiddenBlock(isHidden);
    }
    
    SLBridgeResponse * response = [SLBridgeResponse new];
    response.data = @{@"ishidden ":@(isHidden)};
    NSString *jsonString = [response toJsonString];
    return jsonString;
}

/**
 * 跳转设置页面（同步）
 * @param arg 传入的参数
 */
- (id)pushSettingViewArg:(NSDictionary *)arg{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kH5pushSettingViewNotification object:nil];
    SLBridgeResponse * response = [SLBridgeResponse new];
    response.data = @{};
    NSString *jsonString = [response toJsonString];
    return jsonString;
}

/**
 * 关闭页面 H5调用app
 */
- (id)dismissH5ViewPage:(NSDictionary *)arg{
    
    if (self.dismissH5Block) {
        self.dismissH5Block(arg);
    }
    if ([UIWindow ds_getKeyWindow].ds_rootViewController.navigationController) {
        [[UIWindow ds_getKeyWindow].ds_rootViewController.navigationController popViewControllerAnimated:YES];
    }else{
        [[UIWindow ds_getKeyWindow].ds_rootViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
    SLBridgeResponse * response = [SLBridgeResponse new];
    response.data = @{};
    NSString *jsonString = [response toJsonString];
    return jsonString;
}

/**
 * 获取系统语言 H5调用app
 */
- (id)getLanguageCode:(NSDictionary *)arg{
    
    SLBridgeResponse * response = [SLBridgeResponse new];
    NSString *languages = [NSString getLanguageCode];
    response.data = @{@"languages":languages};
    NSString *jsonString = [response toJsonString];
    return jsonString;
}

/**
 * 获取进度 H5调用app[异步]
 */
- (void)callProgress:(NSDictionary *)args :(JSCallback)completionHandler
{
    self.hanlder = completionHandler;

}

-(void)callProgress:(CGFloat)progress{
    SLBridgeResponse * response = [SLBridgeResponse new];
    response.data = @{@"progress":@(progress)};
    NSString *jsonString = [response toJsonString];
    if (progress < 1) {
        self.hanlder(jsonString,NO);
    }else{
        self.hanlder(jsonString,YES);
    }
}

/**
 * 获取蓝牙的权限
 */
- (void)getBluetoothPermission:(NSDictionary *)args completionHandler:(JSCallback)completionHandler{
    self.bluetoothBlock = completionHandler;
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{CBCentralManagerOptionShowPowerAlertKey: @(YES)}];
  
}

// 实现 CBCentralManagerDelegate 方法
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    switch (central.state) {
        case CBManagerStateUnknown:
            NSLog(@"蓝牙状态未知");
            break;
        case CBManagerStateResetting:
            NSLog(@"蓝牙正在重置");
            break;
        case CBManagerStateUnsupported:
            NSLog(@"该设备不支持蓝牙");
            break;
        case CBManagerStateUnauthorized:
            NSLog(@"蓝牙权限未授权");
            break;
        case CBManagerStatePoweredOff:
            NSLog(@"蓝牙已关闭");
            break;
        case CBManagerStatePoweredOn:
            NSLog(@"蓝牙已打开，可以开始扫描");
            break;
        default:
            break;
    }
    SLBridgeResponse * response = [SLBridgeResponse new];
    response.data = @{@"isPermissions":@(central.state)};
    NSString *jsonString = [response toJsonString];
    
    if (self.bluetoothBlock) {
        self.bluetoothBlock(jsonString, YES);
    }
}



@end
