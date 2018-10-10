# LSLaunchAD
一行代码实现启动广告页

#新增pod 导入
##pod 'LSLaunchAD'
<br/>
#实用方法

-(BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
 {
 
     [LSLaunchAD showWithWindow:self.window
                   countTime:5
       showCountTimeOfButton:YES
              showSkipButton:YES
              isFullScreenAD:NO
              localAdImgName:nil
              imageURL:@"http://img4q.duitang.com/uploads/item/201204/01/20120401222504_xMBAS.thumb.224_0.jpeg"
                  canClickAD:YES
                     aDBlock:^(BOOL clickAD) {
                       if (clickAD) {
                         NSLog(@"点击了广告");
                         UINavigationController *nav =
                             (UINavigationController *)
                                 self.window.rootViewController;
                         UIViewController *vc = [[UIViewController alloc] init];
                         vc.view.backgroundColor = [UIColor whiteColor];
                         vc.title = @"广告";
                         [nav pushViewController:vc animated:YES];
                       } else {
                         NSLog(@"完成倒计时或点击了跳转按钮");
                       }
                     }];
                    return YES;          
}

![image](https://github.com/lsmakethebest/LSLaunchAD/blob/master/images/ad.gif)