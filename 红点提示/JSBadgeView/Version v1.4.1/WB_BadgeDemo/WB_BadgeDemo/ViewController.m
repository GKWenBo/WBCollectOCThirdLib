//
//  ViewController.m
//  WB_BadgeDemo
//
//  Created by Admin on 2017/9/14.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "ViewController.h"
#import "JSBadgeView.h"

@interface ViewController ()
{
    JSBadgeView *badgeView;
}
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    badgeView = [[JSBadgeView alloc]initWithParentView:_button alignment:JSBadgeViewAlignmentTopRight];
    badgeView.badgeText = @"2";
    
    
}
- (IBAction)buttonAction:(id)sender {
    badgeView.badgeText = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
