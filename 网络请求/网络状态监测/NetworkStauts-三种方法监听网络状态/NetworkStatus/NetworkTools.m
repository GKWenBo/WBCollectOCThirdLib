//
//  NetworkTools.m
//  NetworkStatus
//
//  Created by mdd on 16/3/21.
//  Copyright © 2016年 com.personal. All rights reserved.
//

#import "NetworkTools.h"

@implementation NetworkTools
+ (instancetype)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        //#warning 基地址
        //        instance = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.bing.com"]];
        instance = [[self alloc] init];
    });
    return instance;
}
- (instancetype)init {
    if ((self = [super init])) {
        // 设置超时时间，afn默认是60s
        self.requestSerializer.timeoutInterval = 30;
        // 响应格式添加text/plain
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", nil];

        // 监听网络状态,每当网络状态发生变化就会调用此block
        [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusNotReachable:     // 无连线
                    NSLog(@"AFNetworkReachability Not Reachable");
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                    NSLog(@"AFNetworkReachability Reachable via WWAN");
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi: // WiFi
                    NSLog(@"AFNetworkReachability Reachable via WiFi");
                    break;
                case AFNetworkReachabilityStatusUnknown:          // 未知网络
                default:
                    NSLog(@"AFNetworkReachability Unknown");
                    break;
            }
        }];
        // 开始监听
        [self.reachabilityManager startMonitoring];
    }
    return self;
}
@end
