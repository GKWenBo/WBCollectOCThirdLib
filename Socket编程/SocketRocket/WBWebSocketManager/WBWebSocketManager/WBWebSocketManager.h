//
//  WBWebSocketManager.h
//  WBWebSocketManager
//
//  Created by wenbo on 2018/4/23.
//  Copyright © 2018年 wenbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"

extern NSString *const kHost;
extern uint16_t const kPort;

typedef NS_ENUM(NSInteger, DisconnetWebSocketType) {
    DisconnetWebSocketByUser,       /** < 用户主动断开连接 >  */
    DisconnetWebSocketByServerType  /** < 服务器断开连接 >  */
};

@interface WBWebSocketManager : NSObject

/**
 单例管理类

 @return WBWebSocketManager.
 */
+ (instancetype)shareManager;

/**
 The websocket state.
 */
@property (nonatomic, assign, readonly) SRReadyState wb_state;

/**
 Max reconnet count, default is 5.
 */
@property (nonatomic, assign) NSTimeInterval wb_maxReconnetCount;

/**
 Connet to websocket.
 */
- (void)wb_connect;

/**
 Disconnet websocket.
 */
- (void)wb_disConnet;

/**
 Send data.

 @param data data.
 */
- (void)wb_sendData:(id)data;

/**
 Send ping.
 */
- (void)wb_ping;

@end
