//
//  ViewController.m
//  HMSegmentedControl封装
//
//  Created by WMB on 2017/8/12.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "ViewController.h"
#import "WBReuseSegmentedView.h"
@interface ViewController () <WBReuseSegmentedViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *titles = @[@"音乐",@"电音",@"小说",@"音乐",@"电音",@"小说",@"音乐",@"电音",@"小说"];
    
    WBReuseSegmentedView * segementView = [[WBReuseSegmentedView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), 40) titleArray:titles];
    segementView.font = [UIFont systemFontOfSize:20];
    segementView.selectedColor = [UIColor orangeColor];
    segementView.selectionIndicatorHeight = 1.f;
    segementView.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationUp;
    segementView.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segementView.segmentEdgeInset = UIEdgeInsetsMake(0, 30, 0, 30);
    segementView.delegate = self;
    [self.view addSubview:segementView];
}

#pragma mark --------  WB_ReuseSegmentedViewDelegate  --------
#pragma mark
-(void)wb_reuseSegmentedView:(WBReuseSegmentedView *)wb_reuseSegmentedView selectedIndex:(NSInteger)selectedIndex {
    NSLog(@"%ld",(long)selectedIndex);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
