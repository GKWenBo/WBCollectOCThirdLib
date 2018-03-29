//
//  ViewController.m
//  WBPagesManagerController
//
//  Created by WMB on 2017/3/27.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "ViewController.h"

#import "ChildOneViewController.h"
#import "ChildTwoViewController.h"
#import "ChildThreeViewController.h"
@interface ViewController ()

@end

@implementation ViewController

#pragma mark -- LifeCycle
#pragma mark
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initializeUserInterface];
    
}

#pragma mark -- 初始化
#pragma mark
- (void)initDataSource {
    self.segmentTitles = @[@"音乐",@"视屏",@"乒乓球"];
    self.classNames = @[@"ChildOneViewController",@"ChildTwoViewController",@"ChildThreeViewController"];
}

- (void)initializeUserInterface {
    self.segmentView.haveIndicator = NO;
}



@end
