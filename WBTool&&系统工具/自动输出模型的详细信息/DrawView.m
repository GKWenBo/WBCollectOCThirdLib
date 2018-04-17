//
//  DrawView.m
//  L13-AFN
//
//  Created by sunrise on 16/5/8.
//  Copyright © 2016年 xlzhang. All rights reserved.
//

#import "DrawView.h"

@implementation DrawView


- (void)drawRect:(CGRect)rect {
    // 获得绘制上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 拼接下载进度路径
    CGContextAddArc(ctx, 180, 300, 100, -M_PI_2, _angle*M_PI*2 - M_PI_2, NO);
    
    // 设置线条属性
    CGContextSetLineWidth(ctx, 10);
    [[UIColor orangeColor] set];
    // 渲染
    CGContextStrokePath(ctx);
    
    // 绘制文字
    // 获得文字
    NSString *str = [NSString stringWithFormat:@"%.2lf%%",_angle * 100];
    // 设置绘制区域
    CGRect drawRect = CGRectMake(130, 278, 100, 44);
    // 设置绘制字体大小
    UIFont *font = [UIFont systemFontOfSize:25];
    // 设置绘制颜色
    UIColor *coler = [UIColor redColor];
    // 设置段落模式
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    
    // 绘制
    [str drawInRect:drawRect withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:coler,NSParagraphStyleAttributeName:style}];

}



@end







