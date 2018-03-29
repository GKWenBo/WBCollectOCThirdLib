//
//  ViewController.m
//  WB_PageViewController
//
//  Created by WMB on 2017/8/12.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "ViewController.h"
#import "OneViewController.h"
#import "TwoViewController.h"
#import "ThreeViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)initializeDataSource {
    self.titleArray = @[@"音乐",@"电音",@"快乐"];
    self.childViewControllers = @[[OneViewController new],
                        [TwoViewController new],
                        [ThreeViewController new]];
    self.segmentLocation = WBSegmentLocationNavigationBarStyle;
}


- (void)initializeUserInterface {
//    self.segmentLocation = WB_SegmentLocationNavigationBarStyle;
//    self.segmentHeight = 50;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
