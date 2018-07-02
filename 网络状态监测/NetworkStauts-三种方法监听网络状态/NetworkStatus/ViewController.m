//
//  ViewController.m
//  NetworkStatus
//
//  Created by mdd on 16/3/16.
//  Copyright © 2016年 com.personal. All rights reserved.
//

#import "ViewController.h"

#import "Reachability.h"
#import "AFNetworkReachabilityManager.h"
#import "NetworkTools.h"
#import <arpa/inet.h>

@interface ViewController ()
@property (nonatomic, strong) Reachability *routerReachability;
@property (nonatomic, strong) Reachability *hostReachability;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 苹果提供的方法
    [self appleReachabilityTest];
    // afn直接使用
    [self afnReachabilityTest];
    // afn网络中间类
    [NetworkTools sharedManager];
    // socket编程，建立链接时，如果网络不好会阻塞程序，因此不要在主线程调用
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self socketReachabilityTest];
    });
    
}
#pragma mark - 苹果提供的方法
/// 当检测到网络断开时会间隔15s再次检测，如果还是断开则弹窗提醒，防止过于频繁操作
- (void)appleReachabilityTest {
    /// Reachability使用了通知，当网络状态发生变化时发送通知kReachabilityChangedNotification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appReachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    // 被通知函数运行的线程应该由startNotifier函数执行的线程决定
    typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *remoteHostName = @"www.bing.com";
        weakSelf.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
        [weakSelf.hostReachability startNotifier];
        
        weakSelf.routerReachability = [Reachability reachabilityForInternetConnection];
        [weakSelf.routerReachability startNotifier];
        // 开启当前线程消息循环
        [[NSRunLoop currentRunLoop] run];
    });
}

/// 当网络状态发生变化时调用
- (void)appReachabilityChanged:(NSNotification *)notification{
    Reachability *reach = [notification object];
    if([reach isKindOfClass:[Reachability class]]){
        NetworkStatus status = [reach currentReachabilityStatus];
        // 两种检测:路由与服务器是否可达  三种状态:手机流量联网、WiFi联网、没有联网
        if (reach == self.routerReachability) {
            if (status == NotReachable) {
//                NSLog(@"routerReachability NotReachable");
                // 15秒后再次检测
                [self performSelector:@selector(appReachabilityChangedConfirm) withObject:nil afterDelay:15];
            } else if (status == ReachableViaWiFi) {
                NSLog(@"routerReachability ReachableViaWiFi");
            } else if (status == ReachableViaWWAN) {
                NSLog(@"routerReachability ReachableViaWWAN");
            }
        }
        if (reach == self.hostReachability) {
            if (status == NotReachable) {
                NSLog(@"hostReachability failed");
            } else if (status == ReachableViaWiFi) {
                NSLog(@"hostReachability ReachableViaWiFi");
            } else if (status == ReachableViaWWAN) {
                NSLog(@"hostReachability ReachableViaWWAN");
            }
        }
        
    }
}
/// 再次检测网络，如果还是断开，则视为网络已经断开
- (void)appReachabilityChangedConfirm {
    if([self.routerReachability isKindOfClass:[Reachability class]]){
        if ([self.routerReachability currentReachabilityStatus] == NotReachable) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"网络中断" message:@"请检查网络" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *okBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:cancelBtn];
                [alert addAction:okBtn];
                [self presentViewController:alert animated:YES completion:nil];
            });
        }
    }
}
#pragma mark - AFN提供的方法
- (void)afnReachabilityTest {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"%@",[NSThread currentThread]);
        // 一共有四种状态
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"AFNetworkReachability Not Reachable");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"AFNetworkReachability Reachable via WWAN");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"AFNetworkReachability Reachable via WiFi");
                break;
            case AFNetworkReachabilityStatusUnknown:
            default:
                NSLog(@"AFNetworkReachability Unknown");
                break;
        }
    }];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[NSRunLoop currentRunLoop] run];
    });
}

#pragma mark - socket相关
/// 服务器可达返回true
- (BOOL)socketReachabilityTest {
    // 客户端 AF_INET:ipv4  SOCK_STREAM:TCP链接
    int socketNumber = socket(AF_INET, SOCK_STREAM, 0);
    
    // 配置服务器端套接字
    struct sockaddr_in serverAddress;
    // 设置服务器ipv4
    serverAddress.sin_family = AF_INET;
    // 百度的ip
    serverAddress.sin_addr.s_addr = inet_addr("202.108.22.5");
    // 设置端口号，HTTP默认80端口
    serverAddress.sin_port = htons(80);
    if (connect(socketNumber, (const struct sockaddr *)&serverAddress, sizeof(serverAddress)) == 0) {
        close(socketNumber);
        return true;
    }
    close(socketNumber);;
    return false;
}
/// 取消通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

@end
