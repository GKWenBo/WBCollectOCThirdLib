//
//  ViewController.m
//  WB_MMPopupViewManager
//
//  Created by WMB on 2017/6/11.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "ViewController.h"

#import "WBMMPopupViewManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}
- (IBAction)show:(id)sender {
    
//    [WB_MMPopupViewManager wb_showAlertViewWithTitle:@"温馨提示" message:@"详情" actionTitle:@"好的" blurEffectStyle:UIBlurEffectStyleExtraLight];
//    [WB_MMPopupViewManager wb_showAlertViewWithTitle:@"温馨提示" message:@"详情" itemHandlerBlock:^(NSInteger index) {
//        NSLog(@"点击了%ld",index);
//    }];
//    [WB_MMPopupViewManager wb_showTwoActionAlertViewWithTitle:@"温馨提示" message:@"详情" leftTitle:@"取消" rightTitle:@"确定" blurEffectStyle:UIBlurEffectStyleExtraLight itemHandlerBlock:^(NSInteger index) {
//        
//        NSLog(@"点击了%ld",index);
//    }];
//    [WB_MMPopupViewManager wb_showTwoActionAlertViewWithTitle:@"温馨提示" message:nil itemHandlerBlock:^(NSInteger index) {
//        NSLog(@"点击了%ld",index);
//    }];
//    [WB_MMPopupViewManager wb_showAlertViewWithTitle:@"温馨提示" message:nil actionTitles:@[@"拍照",@"相册",@"取消"] actionStyles:@[@0,@0,@1] itemHandlerBlock:^(NSInteger index) {
//        
//        NSLog(@"点击了%ld",index);
//    }];
    [WBMMPopupViewManager wb_showActionSheetWithTitle:nil actionTitles:@[@"拍照",@"从相册选择"] actionStyles:@[@0,@0] itemHandlerBlock:^(NSInteger index) {
        NSLog(@"点击了%ld",index);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
