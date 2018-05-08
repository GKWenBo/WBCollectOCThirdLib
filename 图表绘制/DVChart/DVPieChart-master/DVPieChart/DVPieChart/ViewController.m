//
//  ViewController.m
//  DVPieChart
//
//  Created by Fire on 2018/3/22.
//  Copyright © 2018年 Fire. All rights reserved.
//

#import "ViewController.h"
#import "DVPieChart.h"
#import "DVFoodPieModel.h"
#import "QXHColumnChart.h"

@interface ViewController ()
@property (nonatomic, strong) UIView *circelBgView;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, assign ) CGFloat totaltime;
@end

@implementation ViewController


-(void)setDataArr:(NSArray *)dataArr
{
    
    _dataArr = dataArr;
    //    float total =0 ;
    //    for (int i=0; i<self.dataArr.count; i++) {
    //
    //        total += [dataArr[i] floatValue];
    //    }
    NSArray *colorArr = @[[UIColor redColor],[UIColor yellowColor]];
    CGFloat start =0 ;
    CGFloat end ;
    
    for (int i=0; i<self.dataArr.count; i++) {
        
        end = [self.dataArr[i] floatValue]/self.totaltime+start;
        
        CAShapeLayer *circleLayer = [CAShapeLayer layer];
        circleLayer.strokeStart = start;
        circleLayer.strokeEnd = end;
        circleLayer.zPosition = 0.25;
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(44, 44) radius:30 startAngle:-M_PI_2 endAngle:M_PI + M_PI_2 clockwise:YES];
        
        circleLayer.path = circlePath.CGPath;
        
        circleLayer.fillColor = [UIColor clearColor].CGColor;
        circleLayer.lineWidth = 30.0f;
        //        circleLayer.strokeColor = [UIColor colorWithRed:arc4random()%100/100.0 green:arc4random()%100/100.0 blue:arc4random()%100/100 alpha:1].CGColor;
        //        [circlePath moveToPoint:CGPointMake(60, 0)];
        UIColor *color =  [colorArr objectAtIndex:i];
        circleLayer.strokeColor = color.CGColor;
        [ self.circelBgView.layer addSublayer:circleLayer];
        
        CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnima.fromValue = @(start); //开始动画位置
        pathAnima.toValue = @(end); //结束动画位置
        pathAnima.autoreverses = NO;
        pathAnima.duration = 0.25;
        pathAnima.removedOnCompletion=NO;
        [circleLayer addAnimation:pathAnima forKey:@"strokeEnd"];
        
        start = end;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    DVPieChart *chart = [[DVPieChart alloc] initWithFrame:CGRectMake(0, 30, width, 320)];
    
    [self.view addSubview:chart];
    
    
    DVFoodPieModel *model1 = [[DVFoodPieModel alloc] init];
    
    model1.rate = 0.2261;
    model1.name = @"哈哈哈哈哈哈";
    model1.value = 423651.23;
    
    
    DVFoodPieModel *model2 = [[DVFoodPieModel alloc] init];
    
    model2.rate = 0.168;
    model2.name = @"哈哈哈哈哈哈";
    model2.value = 423651.23;
    
    
    DVFoodPieModel *model3 = [[DVFoodPieModel alloc] init];
    
    model3.rate = 0.168;
    model3.name = @"哈哈";
    model3.value = 423651.23;
    
    
    DVFoodPieModel *model4 = [[DVFoodPieModel alloc] init];
    
    model4.rate = 0.2594;
    model4.name = @"哈哈哈哈哈哈";
    model4.value = 423651.23;
    
    
    DVFoodPieModel *model5 = [[DVFoodPieModel alloc] init];
    
    model5.rate = 0.1393;
    model5.name = @"哈哈";
    model5.value = 423651.23;
    
    
    DVFoodPieModel *model6 = [[DVFoodPieModel alloc] init];
    
    model6.rate = 0.0391;
    model6.name = @"哈哈哈哈哈哈哈哈哈哈哈哈";
    model6.value = 423651.23;
    
    
    NSArray *dataArray = @[model1, model2, model3, model4, model5, model6];
    
    chart.dataArray = dataArray;
    
    chart.title = @"金额";
    
    [chart draw];
    
    
    QXHColumnChart *chart1 = [[QXHColumnChart alloc]initWithFrame:CGRectMake(0, 400, self.view.frame.size.width,300)];
    chart1.dataArray = @[@50,@50,@30,@50,@40,@100,@40,@50,@30,@50,@40];
    [self.view addSubview:chart1];
    
//
//    DVPieChart *chart1 = [[DVPieChart alloc] initWithFrame:CGRectMake(0, 330, width, 300)];
//
//    [self.view addSubview:chart1];
//
//
//    DVFoodPieModel *model7 = [[DVFoodPieModel alloc] init];
//
//    model7.rate = 0.11;
//    model7.name = @"哈哈";
//    model7.value = 423651.23;
//
//
//    DVFoodPieModel *model8 = [[DVFoodPieModel alloc] init];
//
//    model8.rate = 0.21;
//    model8.name = @"哈哈哈哈哈哈";
//    model8.value = 423651.23;
//
//
//    DVFoodPieModel *model9 = [[DVFoodPieModel alloc] init];
//
//    model9.rate = 0.31;
//    model9.name = @"哈哈";
//    model9.value = 423651.23;
//
//
//    DVFoodPieModel *model10 = [[DVFoodPieModel alloc] init];
//
//    model10.rate = 0.11;
//    model10.name = @"哈哈哈哈哈哈";
//    model10.value = 423651.23;
//
//
//    DVFoodPieModel *model11 = [[DVFoodPieModel alloc] init];
//
//    model11.rate = 0.01;
//    model11.name = @"哈哈哈哈哈哈";
//    model11.value = 423651.23;
//
//
//    DVFoodPieModel *model12 = [[DVFoodPieModel alloc] init];
//
//    model12.rate = 0.25;
//    model12.name = @"哈哈哈哈哈哈哈哈哈哈哈哈";
//    model12.value = 423651.23;
//
//
//    NSArray *dataArray1 = @[model7, model8, model9, model10, model11, model12];
//
//    chart1.dataArray = dataArray1;
//
//    chart1.title = @"金额";
//
//    [chart1 draw];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
