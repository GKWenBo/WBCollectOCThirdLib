//
//  SocketSever.m
//  socket服务器端
//
//  Created by baiqiang on 15/12/11.
//  Copyright © 2015年 baiqiang. All rights reserved.
//

#import "SocketSever.h"
#import "GCDAsyncSocket.h"

@interface SocketSever()<GCDAsyncSocketDelegate>
@property (nonatomic, strong) GCDAsyncSocket  *severSocket;
@property (nonatomic, strong) NSMutableArray *clientSockets;
@property (nonatomic, strong) NSMutableDictionary *clientNames;
@end

@implementation SocketSever


- (instancetype)init
{
    self = [super init];
    if (self) {
        _severSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        _clientSockets = [NSMutableArray array];
        _clientNames = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)startSever {
    NSError *error = nil;
    //监听某个端口号
    [_severSocket acceptOnPort:12345 error:&error];
    if (error == nil) {
        NSLog(@"服务器开启");
    }
}

#pragma mark - GCDAsyncSocketDelegate Method

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
    if(![_clientSockets containsObject:newSocket]){
        [_clientSockets addObject:newSocket];
        NSLog(@"%@链接主机成功",newSocket);
        [newSocket readDataWithTimeout:-1 tag:0];
    }
}
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    //单聊：需要存入字典

    NSUInteger index = [_clientSockets indexOfObject:sock];
    NSString *key = [NSString stringWithFormat:@"%lu",index];
    //获得接受字符
    NSString *recverStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //对字符串尾部回车做处理
    while ([recverStr hasSuffix:@"\n"] || [recverStr hasSuffix:@"\r"]) {
        recverStr = [recverStr substringToIndex:recverStr.length - 2];
    }
    
    
    if ([recverStr hasPrefix:@"iam:"] && _clientNames[key] == nil) {
        recverStr = [recverStr componentsSeparatedByString:@":"][1];
        _clientNames[key] = [recverStr stringByAppendingString:@":"];
        recverStr = [recverStr stringByAppendingString:@" has join!"];
        NSLog(@"%@",recverStr);
        for (GCDAsyncSocket *client in self.clientSockets) {
            [client writeData:[recverStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
        }
    }else if([recverStr hasPrefix:@"msg:"]){
        recverStr = [recverStr componentsSeparatedByString:@":"][1];
        NSString *name = _clientNames[key];
        recverStr = [name stringByAppendingString:recverStr];
        NSLog(@"%@",recverStr);
        for (GCDAsyncSocket *client in self.clientSockets) {
            [client writeData:[recverStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
        }
    }else if ([recverStr isEqualToString:@"quit"]) {
        //断开连接
        [sock setDelegate:nil];
        [sock disconnect];
        
        [_clientNames removeObjectForKey:key];
        [_clientSockets removeObject:sock];
    }
    [sock readDataWithTimeout:-1 tag:0];
}

@end
