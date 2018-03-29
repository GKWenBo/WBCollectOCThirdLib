//
//  ViewController.m
//  TestSocket
//
//  Created by rimi on 15/12/21.
//  Copyright © 2015年 yangkai. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSStreamDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSInputStream *_inputStream;
    NSOutputStream *_outputStream;
}
@property (strong, nonatomic)NSMutableArray*dataSoureArr;
@property (weak, nonatomic) IBOutlet UITableView *cutomTableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottomConstraint;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(kbWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
 }


#pragma marke --NSStreamDelegate--
-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    /*
     NSStreamEventOpenCompleted = 1UL << 0,
     NSStreamEventHasBytesAvailable = 1UL << 1,
     NSStreamEventHasSpaceAvailable = 1UL << 2,
     NSStreamEventErrorOccurred = 1UL << 3,
     NSStreamEventEndEncountered = 1UL << 4
     */
    NSLog(@"steam:%@",aStream);
    switch (eventCode) {
        case NSStreamEventOpenCompleted:
            NSLog(@"输入输出流打开完成");
            break;
        case NSStreamEventHasBytesAvailable:
            [self readNewBytes];
            NSLog(@"有可读数据");
            break;
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"可以输出数据");
            break;
        case NSStreamEventErrorOccurred:
            NSLog(@"数据出现错误");
            break;
        case NSStreamEventEndEncountered:
            NSLog(@"正常断开连接");
            [self closeConnect];
            break;
        default:
            break;
    }
}
#pragma mark --UITextFieldDelegate--
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSString *userName = [NSString stringWithFormat:@"msg:%@",textField.text];
    //字符转data
    NSData *data = [userName dataUsingEncoding:NSUTF8StringEncoding];
    //通过输出了写入数据
    [_outputStream write:data.bytes maxLength:data.length];
    textField.text = nil;
    return YES;
}
#pragma mark --UITableViewDataSource--
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSoureArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.textLabel.text = self.dataSoureArr[indexPath.row];
    return cell;
}
//键盘回收
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
#pragma mark private envent
- (void)kbWillShow:(NSNotification*)noti
{
    //屏幕高
    CGFloat widowH = [UIScreen mainScreen].bounds.size.height;
    //键盘frame
    CGRect rect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat viewH = widowH -rect.origin.y;
    self.viewBottomConstraint.constant = viewH;
}
//连接到主机
- (IBAction)connectHost:(id)sender {
    //主机
    NSString *host = @"127.0.0.1";
    //端口号
    int port = 12345;
    //c 输入流
    CFReadStreamRef readStream;
    //c 输出流
    CFWriteStreamRef writeStream;
    //1、建立连接 （通过C语言创建连接）
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)host, port, &readStream, &writeStream);
    //将C语言输入输出流转化成OC输入输出
    _inputStream = (__bridge NSInputStream*)readStream;
    _outputStream = (__bridge NSOutputStream*)writeStream;
    //放入运行池里面
    [_inputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    //设置代理
    _inputStream.delegate = self;
    _outputStream.delegate =self;
    //打开输入输出流
    [_inputStream open];
    [_outputStream open];

}
- (IBAction)login:(id)sender {
    NSString *userName = @"iam:yangkai";
    //字符转data
    NSData *data = [userName dataUsingEncoding:NSUTF8StringEncoding];
    //通过输出了写入数据
    [_outputStream write:data.bytes maxLength:data.length];
}
//读入数据
- (void)readNewBytes
{
    //建立一个缓冲区用于存放数据，并且存放的大小为1024
    uint8_t buff[1024];
    //返回一个实际大小
    NSInteger len = [_inputStream read:buff maxLength:sizeof(buff)];
    if (len>0) {
        //转化成OC可读数据
        NSData *data = [NSData dataWithBytes:buff length:len];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        [self.dataSoureArr addObject:str];
        [self.cutomTableView reloadData];
    }
}
- (void)closeConnect
{
    //移出循环池
    [_inputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    //关闭输入输出流
    [_inputStream close];
    [_outputStream close];

}
#pragma marke --setting,getting--
-(NSMutableArray *)dataSoureArr{
    if (!_dataSoureArr) {
        _dataSoureArr = [NSMutableArray array];
    }
    return _dataSoureArr;
}
/* 终端模拟对聊
 1、连接服务器
 telnet 127.0.0.1 12345
 2、登录
 iam:username
 3、发送数据
 msg:需要发送的数据
 4、退出
 quit
 */




@end
