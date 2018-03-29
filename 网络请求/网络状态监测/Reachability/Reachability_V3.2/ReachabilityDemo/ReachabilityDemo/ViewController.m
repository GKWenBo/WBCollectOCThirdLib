//
//  ViewController.m
//  ReachabilityDemo
//
//  Created by Admin on 2017/1/21.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,strong) Reachability * reachability;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /** 监听网络状态 */
    _isReachable = YES;
    _reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    _isReachable = [_reachability isReachable];
}


#pragma mark -- 网络状态改变
#pragma mark
- (void)reachabilityChanged:(NSNotification *)info {
    Reachability * currentReach = [info object];
    NSParameterAssert([currentReach isKindOfClass:[Reachability class]]);
    
    NetworkStatus status = [currentReach currentReachabilityStatus];
    
    if (status == NotReachable) {
        /** 没用网络 */
        self.isReachable = NO;
        NSLog(@"%@",currentReach.currentReachabilityString);
    }else if (status == ReachableViaWiFi) {
        /** wifi */
        self.isReachable = YES;
        NSLog(@"%@",currentReach.currentReachabilityString);
    }else if (status == ReachableViaWWAN) {
        //2G 3G 4G
        self.isReachable = YES;
        NSLog(@"%@",currentReach.currentReachabilityString);
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //添加观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    /** 开启网络监测 */
    [_reachability startNotifier];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    /** 停止网络监测 */
    [_reachability stopNotifier];
}


@end
