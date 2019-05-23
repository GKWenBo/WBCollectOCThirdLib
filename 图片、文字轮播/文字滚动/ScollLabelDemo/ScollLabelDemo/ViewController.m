//
//  ViewController.m
//  ScollLabelDemo
//
//  Created by 曾洪磊 on 2019/5/13.
//  Copyright © 2019 曾洪磊. All rights reserved.
//

#import "ViewController.h"
#import "CYBScrollLabel.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CYBScrollLabel *label = [[CYBScrollLabel alloc]initWithFrame:CGRectMake(50, 50, 200, 40)];
    label.textColor = [UIColor redColor];
    label.backgroundColor = [UIColor blueColor];
    label.text = @"我是一只狼11111";
    [self.view addSubview:label];
    [label startScoll];
}


@end
