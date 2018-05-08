//
//  ViewController.m
//  DVBarChart
//
//  Created by Fire on 16/4/23.
//  Copyright © 2016年 Fire. All rights reserved.
//

#import "ViewController.h"
#import "DVBarChartView.h"

@interface ViewController () <DVBarChartViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    DVBarChartView *chartView = [[DVBarChartView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 300)];
    [self.view addSubview:chartView];
    
    chartView.yAxisViewWidth = 52;
    chartView.numberOfYAxisElements = 5;
    chartView.xAxisTitleArray = @[@"4.1", @"4.2", @"4.3", @"4.4", @"4.5", @"4.6", @"4.7", @"4.8", @"4.9", @"4.10", @"4.11", @"4.12", @"4.13", @"4.14", @"4.15", @"4.16", @"4.17", @"4.18", @"4.19", @"4.20", @"4.21", @"4.22", @"4.23", @"4.24", @"4.25", @"4.26", @"4.27", @"4.28", @"4.29", @"4.30"];
    
    chartView.xValues = @[@300, @550, @700, @200, @370, @890, @760, @430, @210, @30, @300, @550, @700, @200, @370, @890, @760, @430, @210, @30, @300, @550, @700, @200, @370, @890, @760, @430, @210, @30];
    chartView.delegate = self;
    chartView.yAxisMaxValue = 1000;
//    chartView.barUserInteractionEnabled = NO;
    [chartView draw];
}

- (void)barChartView:(DVBarChartView *)barChartView didSelectedBarAtIndex:(NSInteger)index {
    
    NSLog(@"%ld", index);
    
}

@end
