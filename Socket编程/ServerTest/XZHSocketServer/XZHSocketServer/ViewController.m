//
//  ViewController.m
//  XZHSocketServer
//
//  Created by gonghuiiOS on 17/3/22.
//  Copyright © 2017年 熊志华. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"


@interface ViewController () <GCDAsyncSocketDelegate>

@property(strong)  GCDAsyncSocket *socket;
@property(strong)  GCDAsyncSocket *cSocket;//链接的socket
@property (weak) IBOutlet NSTextField *portTF;

@property (unsafe_unretained) IBOutlet NSTextView *textView;

@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (IBAction)listen:(id)sender {
    if (_portTF.stringValue.length < 1) {
        return;
    }
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *err = nil;
    if(![_socket acceptOnPort:[_portTF.stringValue integerValue] error:&err])
    {
        [self textViewAddText:err.description];
    }else
    {
        [self textViewAddText:[NSString stringWithFormat:@"开始监听%@端口.",_portTF.stringValue]];
    }
    
    
}

- (void)textViewAddText:(NSString *)text {
    //加上换行
    self.textView.string = [_textView.string stringByAppendingFormat:@"%@\n",text];
}
/**
 当套接字接受连接时调用。
 *另一个套接字自动生成处理它。
 *
 *如果你想处理连接就必须保留newsocket。
 *否则newsocket实例将被释放，产生的连接将被关闭。
 *
 *默认情况下，新的socket都有相同的delegate和delegatequeue。
 
 */

- (void)socket:(GCDAsyncSocket *)sender didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    // The "sender" parameter is the listenSocket we created.
    // The "newSocket" is a new instance of GCDAsyncSocket.
    // It represents the accepted incoming client connection.
    
    // Do server stuff with newSocket...
    [self textViewAddText:[NSString stringWithFormat:@"建立与%@的连接",newSocket.connectedHost]];
    
    self.cSocket = newSocket;
    _cSocket.delegate = self;
    [_cSocket readDataWithTimeout:-1 tag:0];
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *receive = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self textViewAddText:[NSString stringWithFormat:@"%@:%@",sock.connectedHost,receive]];
    
    NSString *reply = [NSString stringWithFormat:@"收到:%@",receive];
    
    [_cSocket writeData:[reply dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [_cSocket readDataWithTimeout:-1 tag:0];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
