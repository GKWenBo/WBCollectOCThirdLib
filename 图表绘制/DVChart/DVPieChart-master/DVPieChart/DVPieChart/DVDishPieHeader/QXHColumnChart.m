//
//  QXChart.m
//  QXChart
//
//  Created by qxliu on 2018/2/25.
//  Copyright © 2018年 e3info. All rights reserved.
//

#import "QXHColumnChart.h"

@interface QXHColumnChart ()

@end

@implementation QXHColumnChart

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
-(void)drawRect:(CGRect)rect
{
    [self setUI];
}
-(void)setUI{
    CGFloat chartW = self.frame.size.width;
    CGFloat chartH = self.frame.size.height;
    
    //纵坐标
    for (int i = 0; i<_dataArray.count; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 10+i*(chartH-50)/(_dataArray.count), 40, (chartH-30)/(_dataArray.count*2))];
        label.text = [NSString stringWithFormat:@"第%d个",i];
        label.font = [UIFont systemFontOfSize:8];
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = [UIColor grayColor];
        [self addSubview:label];
    }
//    //竖线
//    for (int i = 0; i<11; i++) {
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50+i*(chartW -100)/10, 0, 1, chartH-20)];
//        label.backgroundColor = [UIColor groupTableViewBackgroundColor];
//        [self addSubview:label];
//
//        //横坐标
//        UILabel *percentage = [[UILabel alloc]initWithFrame:CGRectMake(40+i*(chartW -100)/10, chartH-20, (chartW-50)/11, 20)];
//        percentage.font = [UIFont systemFontOfSize:6];
//        percentage.textColor = [UIColor grayColor];
//        percentage.text = [NSString stringWithFormat:@"%d.0%%",i*10];
//        [self addSubview:percentage];
//    }
    
    
    for (int i = 0; i<_dataArray.count; i++) {
        
        
        CAShapeLayer *backLayer = [CAShapeLayer layer];
        backLayer.frame =self.bounds;
        backLayer.lineWidth = (chartH-30)/(_dataArray.count*2);
        backLayer.strokeColor = [UIColor orangeColor].CGColor;
        backLayer.fillColor =[UIColor clearColor].CGColor;
        [self.layer addSublayer:backLayer];
        
        UIBezierPath *backPath =[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 0, 0)];
        [backPath moveToPoint:CGPointMake(50, 14.f+i*(chartH-50)/(_dataArray.count))];
        [backPath addLineToPoint:CGPointMake(50+(chartW -100)*[_dataArray[i]intValue]/100,14.f+i*(chartH-50)/(_dataArray.count))];
        backLayer.path = backPath.CGPath;
        
        CABasicAnimation*backAnimation=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        backAnimation.duration=1.5;
        backAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        backAnimation.fromValue=[NSNumber numberWithFloat:0];
        backAnimation.toValue=[NSNumber numberWithFloat:1.0];
        [backLayer addAnimation:backAnimation forKey:@"strokeEndAnimation"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(52+(chartW -100)*[_dataArray[i]floatValue]/100, 10+i*(chartH-50)/(_dataArray.count), 40, (chartH-30)/(_dataArray.count*2))];
            rightLabel.text = [NSString stringWithFormat:@"%@",_dataArray[i]];
            rightLabel.font = [UIFont systemFontOfSize:8];
            rightLabel.textColor = [UIColor grayColor];
            [self addSubview:rightLabel];
        });
        
    }
}


@end
