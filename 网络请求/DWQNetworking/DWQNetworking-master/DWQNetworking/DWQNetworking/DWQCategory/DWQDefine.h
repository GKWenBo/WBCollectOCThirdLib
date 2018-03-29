//
//  DWQDefine.h
//  DWQTools
//
//  Created by 杜文全 on 16/9/28.
//  Copyright © 2016年 杜文全. All rights reserved.
//  

//
//  DWQDefine.h
//  PortableTreasure
//
//  Created by HeDong on 15/03/20.
//  Copyright © 2015年 hedong. All rights reserved.
//

//// 判断是真机还是模拟器
//#if TARGET_OS_IPHONE
//// iPhone Device
//#endif
//
//#if TARGET_IPHONE_SIMULATOR
//// iPhone Simulator
//#endif

// 由角度获取弧度
#define DWQDegreesToRadian(x) (M_PI * (x) / 180.0)
// 由弧度获取角度
#define DWQRadianToDegrees(radian) (radian * 180.0) / (M_PI)

#define DWQUserDefaults [NSUserDefaults standardUserDefaults]
#define DWQKeyWindow [UIApplication sharedApplication].keyWindow
#define DWQRootViewController DWQKeyWindow.rootViewController

/** APP版本号 */
#define DWQAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
/** APP BUILD 版本号 */
#define DWQAppBuildVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
/** APP名字 */
#define DWQAppDisplayName [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]
/** 当前语言 */
#define DWQLocalLanguage [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode]
/** 当前国家 */
#define DWQLocalCountry [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode]


/******* RGB颜色 *******/
#define DWQColor(r, g, b) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0  blue:(b) / 255.0  alpha:1.0]
/******* RGB颜色 *******/


/******* 屏幕尺寸 *******/
#define DWQMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define DWQMainScreenHeight [UIScreen mainScreen].bounds.size.height
#define DWQMainScreenBounds [UIScreen mainScreen].bounds
/******* 屏幕尺寸 *******/


/******* 设备型号和系统 *******/
/** 检查系统版本 */
#define DWQSYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define DWQSYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define DWQSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define DWQSYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define DWQSYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
/** 系统和版本号 */
#define DWQDevice [UIDevice currentDevice]
#define DWQDeviceName DWQDevice.name                           // 设备名称
#define DWQDeviceModel DWQDevice.model                         // 设备类型
#define DWQDeviceLocalizedModel DWQDevice.localizedModel       // 本地化模式
#define DWQDeviceSystemName DWQDevice.systemName               // 系统名字
#define DWQDeviceSystemVersion DWQDevice.systemVersion         // 系统版本
#define DWQDeviceOrientation DWQDevice.orientation             // 设备朝向
#define DWQDeviceUUID DWQDevice.identifierForVendor.UUIDString // UUID
#define DWQiOS8 ([DWQDeviceSystemVersion floatValue] >= 8.0)   // iOS8以上
#define DWQiPhone ([DWQDeviceModel rangeOfString:@"iPhone"].length > 0)
#define DWQiPod ([DWQDeviceModel rangeOfString:@"iPod"].length > 0)
#define DWQiPad (DWQDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad)
/******* 设备型号和系统 *******/


/******* 日志打印替换 *******/
#ifdef DEBUG
// Debug
#define DWQLog(FORMAT, ...) fprintf(stderr, "%s [%d lines] %s\n", __PRETTY_FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
// Release
#define DWQLog(FORMAT, ...) nil
#endif
/******* 日志打印替换 *******/