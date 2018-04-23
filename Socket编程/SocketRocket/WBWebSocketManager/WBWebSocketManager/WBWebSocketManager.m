//
//  WBWebSocketManager.m
//  WBWebSocketManager
//
//  Created by wenbo on 2018/4/23.
//  Copyright © 2018年 wenbo. All rights reserved.
//

#import "WBWebSocketManager.h"

#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

NSString *const kHost = @"";
uint16_t const kPort = 443;

@interface WBWebSocketManager () <SRWebSocketDelegate>

@property (nonatomic, strong) SRWebSocket *webSocket;
@property (nonatomic, strong) NSTimer *heartTimer;
@property (nonatomic, assign) NSTimeInterval reconetTimes;

@end

@implementation WBWebSocketManager

+ (instancetype)shareManager {
    static WBWebSocketManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
    });
    return manager;
}

#pragma mark ------ < 初始化 > ------
- (instancetype)init
{
    self = [super init];
    if (self) {
        _wb_maxReconnetCount = 5;
        [self wb_initSocket];
    }
    return self;
}

#pragma mark ------ < Private Method > ------
- (void)wb_initSocket {
    
    if (self.webSocket) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"ws://%@:%d",kHost,kPort];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    self.webSocket = [[SRWebSocket alloc]initWithURLRequest:urlRequest];
    self.webSocket.delegate = self;
    
    /** < 设置线程队列 >  */
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc]init];
    operationQueue.maxConcurrentOperationCount = 1;
    [self.webSocket setDelegateOperationQueue:operationQueue];
    
    /** < 建立连接 >  */
    [self.webSocket open];
}

- (void)wb_initHeartBeat {
    dispatch_main_async_safe(^{
        [self wb_destroyHeartBeat];
        self.heartTimer = [NSTimer scheduledTimerWithTimeInterval:3 * 60 target:self selector:@selector(heartBeatAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.heartTimer forMode:NSRunLoopCommonModes];
    });
}

- (void)wb_destroyHeartBeat {
    dispatch_main_async_safe(^{
        if (self.heartTimer) {
            [self.heartTimer invalidate];
            self.heartTimer = nil;
        }
    });
}

- (void)wb_reconnet {
    
    [self wb_disConnet];
    
    /** < 超过一分钟就不再重连 所以只会重连5次 2^5 = 64 >  */
    if (_reconetTimes > pow(2, _wb_maxReconnetCount)) {
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_reconetTimes * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.webSocket = nil;
        [self wb_initSocket];
        NSLog(@"***********重连第%.f次***********",self.reconetTimes);
    });
    
    if (_reconetTimes == 0) {
        _reconetTimes = 2;
    }else {
        _reconetTimes *= 2;
    }
}

#pragma mark ------ < Public Method > ------
- (void)wb_connect {
    _reconetTimes = 0;
    [self wb_initSocket];
}

- (void)wb_disConnet {
    if (self.webSocket) {
        [self.webSocket closeWithCode:DisconnetWebSocketByUser reason:@"用户主动断开"];
        self.webSocket = nil;
    }
    [self wb_destroyHeartBeat];
}

- (void)wb_sendData:(id)data {
    switch (self.webSocket.readyState) {
        case SR_OPEN:
            //已连接
            [self.webSocket send:data];
            break;
        case SR_CONNECTING:
            //连接中
            [self wb_reconnet];
            break;
        case SR_CLOSED:
        case SR_CLOSING:
            [self wb_reconnet];
            break;
        default:
            self.webSocket = nil;
            break;
    }
}

- (void)wb_ping {
    [self.webSocket sendPing:nil];
}

#pragma mark ------ < Event Response > ------
- (void)heartBeatAction {
    /** < 心跳包 >  */
    [self.webSocket send:@"heart"];
}

#pragma mark ------ < SRWebSocketDelegate > ------
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"********webSocket连接成功********");
    
    _reconetTimes = 0;
    [self wb_initHeartBeat];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"************************** socket 连接失败************************** ");
    [self wb_reconnet];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    
    switch (code) {
        case DisconnetWebSocketByUser:
            break;
        default:
            NSLog(@"其他原因关闭连接，开始重连...");
            [self wb_reconnet];
            break;
    }
    [self wb_destroyHeartBeat];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    NSLog(@"收到pong回调");
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"服务器返回收到消息:%@",message);
}

@end
