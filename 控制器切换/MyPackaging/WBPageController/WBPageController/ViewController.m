//
//  ViewController.m
//  WBPageController
//
//  Created by wenbo on 2018/5/9.
//  Copyright © 2018年 wenbo. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (instancetype)init
{

    self = [super initWithSegmentTitles:@[@"你好",@"111",@"222"] childVcs:@[[TestViewController <WBPageChildVcDelegate>new],[TestViewController <WBPageChildVcDelegate>new],[TestViewController <WBPageChildVcDelegate>new]] position:WBSegmentPositionSubStyle];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
