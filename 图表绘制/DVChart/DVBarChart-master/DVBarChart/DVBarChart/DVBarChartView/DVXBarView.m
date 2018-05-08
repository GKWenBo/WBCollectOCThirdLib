//
//  DVXBarView.m
//  xxxxx
//
//  Created by Fire on 15/11/11.
//  Copyright © 2015年 DuoLaiDian. All rights reserved.
//

#import "DVXBarView.h"
#import "UIView+Extension.h"
//#import "UIButton+Extension.h"

@interface DVXBarView ()
/**
 *  图表顶部留白区域
 */
@property (assign, nonatomic) CGFloat topMargin;
/**
 *  记录图表区域的高度
 */
@property (assign, nonatomic) CGFloat chartHeight;
/**
 *  记录坐标轴Label的高度
 */
@property (assign, nonatomic) CGFloat textHeight;
/**
 *  存放坐标轴的label（底部的）
 */
@property (strong, nonatomic) NSMutableArray *titleButtonArray;

/**
 *  存放柱子顶部的label
 */
@property (strong, nonatomic) NSMutableArray *barTopButtonArray;
/**
 *  记录点按钮的集合
 */
@property (strong, nonatomic) NSMutableArray *barButtonArray;
/**
 *  选中的点
 */
@property (strong, nonatomic) UIButton *selectedBarButton;

/**
 *  选中的柱子顶部的label
 */
@property (strong, nonatomic) UIButton *selectedBarTopButton;
/**
 *  选中的坐标轴的label
 */
@property (strong, nonatomic) UIButton *selectedTitleButton;
@end


@implementation DVXBarView

- (NSMutableArray *)titleButtonArray {
    
    if (_titleButtonArray == nil) {
        _titleButtonArray = [NSMutableArray array];
    }
    return _titleButtonArray;
}

- (NSMutableArray *)barTopButtonArray {
    
    if (_barTopButtonArray == nil) {
        _barTopButtonArray = [NSMutableArray array];
    }
    return _barTopButtonArray;
}

- (NSMutableArray *)barButtonArray {
    
    if (_barButtonArray == nil) {
        _barButtonArray = [NSMutableArray array];
    }
    return _barButtonArray;
}

- (void)draw {
    
    self.backgroundColor = self.backColor;
    
    // 移除先前存在的所有视图
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    // 移除数组内所有的Label元素
    [self.titleButtonArray removeAllObjects];
    [self.barTopButtonArray removeAllObjects];
    [self.barButtonArray removeAllObjects];
    
    CGSize labelSize = CGSizeMake(self.barWidth, 29);
    
    
    // 添加坐标轴Label
    for (int i = 0; i < self.xAxisTitleArray.count; i++) {
        NSString *title = self.xAxisTitleArray[i];
        
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = self.textFont;
        [button setTitleColor:self.textColor forState:UIControlStateNormal];
        [button setTitleColor:self.barSelectedColor forState:UIControlStateSelected];
        button.tag = 100 + i;
        
        [button addTarget:self action:@selector(barDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        button.titleLabel.numberOfLines = 0;
        
        button.x = (i + 1) * self.barGap + i * labelSize.width;
        button.y = self.height - labelSize.height;
        button.width = labelSize.width;
        button.height = labelSize.height;
        
        [self.titleButtonArray addObject:button];
        [self addSubview:button];
    }
    
    // 添加坐标轴
    self.textHeight = labelSize.height;
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = self.axisColor;
    view.height = 1;
    view.width = self.width + 200;
    view.x = -200;
    view.y = self.height - labelSize.height - self.xAxisTextGap;
    [self addSubview:view];
    
    self.topMargin = 50;
    self.chartHeight = self.height - labelSize.height - self.xAxisTextGap - self.topMargin;
    
    
    for (int i = 0; i < self.xValues.count; i++) {
        
        NSNumber *value = self.xValues[i];
        NSString *title = [self decimalwithFormat:@"0" floatV:value.floatValue];
        
        if (value.floatValue < 0) {
            value = @(0);
        }
        
        CGPoint center = CGPointMake((i+1)*self.barGap + i*self.barWidth, self.chartHeight - value.floatValue/self.yAxisMaxValue * self.chartHeight + self.topMargin);
        
        if (self.yAxisMaxValue * self.chartHeight == 0) {
            center = CGPointMake((i+1)*self.barGap + i*self.barWidth, self.chartHeight + self.topMargin);
        }
        
        // 添加point处的Label
        if (self.isShowPointLabel) {
            
            [self addLabelWithTitle:title atLocation:center andTag:i];
            
        }
        
        UIButton *button = [[UIButton alloc] init];
        button.tag = i;
//        [button setBackgroundColor:self.barColor forState:UIControlStateNormal];
//        [button setBackgroundColor:self.barSelectedColor forState:UIControlStateSelected];
        [button setBackgroundImage:[self imageWithColor:self.barColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[self imageWithColor:self.barSelectedColor] forState:UIControlStateSelected];
        
        CGSize buttonSize = CGSizeMake(self.barWidth, value.floatValue/self.yAxisMaxValue * self.chartHeight);
        
        if (self.yAxisMaxValue == 0) {
            
            button.size = CGSizeMake(self.barWidth, 0);
        }else{
            button.size = buttonSize;
        }
        
        button.x = center.x;
        button.y = center.y;
        
        button.userInteractionEnabled = self.isBarUserInteractionEnabled;
        
        [button addTarget:self action:@selector(barDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.barButtonArray addObject:button];
        if (button.userInteractionEnabled) {
            if (self.index < 0) {
                if (i == 0) {
                    [self barDidClicked:button];
                }
            }else{
                if (i == self.index) {
                    [self barDidClicked:button];
                }
            }
        }
        [self addSubview:button];
    }
    
    [self setNeedsDisplay];
}


- (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setPositiveFormat:format];
    
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}

// 添加pointLabel的方法
- (void)addLabelWithTitle:(NSString *)title atLocation:(CGPoint)location andTag:(NSInteger)tag {
    
    UIButton *button = [[UIButton alloc] init];
    
    if (self.isPercent) {
        [button setTitle:[NSString stringWithFormat:@"%@%%", title] forState:UIControlStateNormal];
        
    }else{
        [button setTitle:title forState:UIControlStateNormal];
    }
    
    [button setTitleColor:self.textColor forState:UIControlStateNormal];
    [button setTitleColor:self.barSelectedColor forState:UIControlStateSelected];
    button.titleLabel.font = self.textFont;
    button.layer.backgroundColor = self.backColor.CGColor;
    
//    NSDictionary *attr = @{NSFontAttributeName : self.textFont};
//    CGSize labelSize = [label.text sizeWithAttributes:attr];
    
    CGSize labelSize = CGSizeMake(self.barWidth, 12);
    
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.width = labelSize.width;
    button.height = labelSize.height;
    button.x = location.x;   // - label.width / 2;
    button.y = location.y - button.height - 3;
    button.tag = 200+tag;
    [button addTarget:self action:@selector(barDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.barTopButtonArray addObject:button];
    [self addSubview:button];
}

- (void)barDidClicked:(UIButton *)button {
    
    NSInteger index = 0;
    
    if (button.tag >= 100 && button.tag < 200) {
        index = button.tag - 100;
    } else if (button.tag >= 200) {
        index = button.tag - 200;
    } else {
        index = button.tag;
    }
    
    self.selectedBarButton.selected = NO;
    self.selectedBarTopButton.selected = NO;
    self.selectedTitleButton.selected = NO;
    
    UIButton *barButton = self.barButtonArray[index];
    UIButton *barTopButton = self.barTopButtonArray[index];
    UIButton *titleButton = self.titleButtonArray[index];
    
    barButton.selected = YES;
    barTopButton.selected = YES;
    titleButton.selected = YES;
    
    self.selectedBarButton = barButton;
    self.selectedBarTopButton = barTopButton;
    self.selectedTitleButton = titleButton;
    
    if ([self.delegate respondsToSelector:@selector(xBarView:didClickButtonAtIndex:)]) {
        [self.delegate xBarView:self didClickButtonAtIndex:index];
    }
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
