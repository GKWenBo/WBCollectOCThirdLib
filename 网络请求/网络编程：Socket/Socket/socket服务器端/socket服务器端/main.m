//
//  main.m
//  socket服务器端
//
//  Created by baiqiang on 15/12/11.
//  Copyright © 2015年 baiqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketSever.h"
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        
        SocketSever *socket = [[SocketSever alloc] init];
        [socket startSever];
        
        //开启消息循环池
        [[NSRunLoop currentRunLoop] run];
    }
    return 0;
}
