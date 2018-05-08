//
//  DVBarChartView.m
//  xxxxx
//
//  Created by Fire on 15/11/11.
//  Copyright © 2015年 DuoLaiDian. All rights reserved.
//

#import "DVBarChartView.h"
#import "DVXBarView.h"
#import "DVYBarView.h"
#import "UIColor+Hex.h"
#import "UIView+Extension.h"

@interface DVBarChartView () <DVXBarViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) DVXBarView *xBarView;
@property (strong, nonatomic) DVYBarView *yBarView;
@property (assign, nonatomic) CGFloat gap;

@end

@implementation DVBarChartView

- (void)draw {
    
    
    if (self.xValues.count == 0) return;
    
    // 设置y轴视图的尺寸
    self.yBarView.width = self.yAxisViewWidth;
    self.yBarView.x = 0;
    self.yBarView.height = self.height;
    self.yBarView.y = 0;
    
    // 设置scrollView的尺寸
    self.scrollView.x = self.yBarView.width;
    self.scrollView.y = 0;
    self.scrollView.width = self.width - self.scrollView.x;
    self.scrollView.height = self.height;
    
    // 设置x轴视图的尺寸
    self.xBarView.x = 0;
    self.xBarView.y = 0;
    self.xBarView.height = self.scrollView.height;
    self.xBarView.width = self.xAxisTitleArray.count * (self.barGap + self.barWidth) + 150;
    
    self.scrollView.contentSize = self.xBarView.frame.size;
    
    // 给y轴视图传递参数
    self.yBarView.xAxisTextGap = self.xAxisTextGap;
    self.yBarView.yAxisTextGap = self.yAxisTextGap;
    self.yBarView.textColor = self.textColor;
    self.yBarView.textFont = self.textFont;
    self.yBarView.percent = self.isPercent;
    self.yBarView.axisColor = self.axisColor;
    self.yBarView.numberOfYAxisElements = self.numberOfYAxisElements;
    self.yBarView.yAxisMaxValue = self.yAxisMaxValue;
    self.yBarView.backColor = self.backColor;
    self.yBarView.barWidth = self.barWidth;
    [self.yBarView draw];
    
    self.xBarView.xAxisTitleArray = self.xAxisTitleArray;
    self.xBarView.barGap = self.barGap;
    self.xBarView.xAxisTextGap = self.xAxisTextGap;
    self.xBarView.axisColor = self.axisColor;
    self.xBarView.numberOfYAxisElements = self.numberOfYAxisElements;
    self.xBarView.xValues = self.xValues;
    self.xBarView.yAxisMaxValue = self.yAxisMaxValue;
    self.xBarView.showPointLabel = self.isShowPointLabel;
    self.xBarView.backColor = self.backColor;
    self.xBarView.textFont = self.textFont;
    self.xBarView.textColor = self.textColor;
    self.xBarView.percent = self.isPercent;
    self.xBarView.barUserInteractionEnabled = self.isBarUserInteractionEnabled;
    self.xBarView.barWidth = self.barWidth;
    self.xBarView.barColor = self.barColor;
    self.xBarView.barSelectedColor = self.barSelectedColor;
    self.xBarView.index = self.index;
    [self.xBarView draw];
    
    if (self.index >= 0) {
        
        if (self.index * (self.barGap + self.barWidth) > self.scrollView.width * 0.5) {
            [self.scrollView setContentOffset:CGPointMake(self.index * (self.barGap + self.barWidth) - self.scrollView.width * 0.5, 0) animated:YES];
        }else{
            
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
    
//else if (self.index * (self.barGap + self.barWidth) < self.scrollView.width &&
//         self.index * (self.barGap + self.barWidth) > self.scrollView.width * 0.5) {
//    [self.scrollView setContentOffset:CGPointMake(self.index * (self.barGap + self.barWidth) - self.scrollView.width * 0.5, 0) animated:NO];
//}else
}

- (void)commonInit {
    
    // 初始化某些属性值
    self.xAxisTextGap = 10;
    self.yAxisTextGap = 10;
    self.barGap = 1;
    self.axisColor = [UIColor colorWithHexString:@"67707c"];
    self.textColor = [UIColor colorWithHexString:@"9aafc1"];
    self.textFont = [UIFont systemFontOfSize:12];
    self.numberOfYAxisElements = 5;
    self.percent = NO;
    self.showPointLabel = YES;
    self.backColor = [UIColor colorWithHexString:@"3e4a59"];
    self.barUserInteractionEnabled = YES;
    self.barColor = [UIColor colorWithRed:39/255.0 green:171/255.0 blue:204/255.0 alpha:1];
    self.barSelectedColor = [UIColor colorWithHexString:@"fdb302"];
    self.barWidth = 57;
    self.index = -1;
    
    // 添加x轴与y轴视图
    DVYBarView *yBarView = [[DVYBarView alloc] init];
    
    [self addSubview:yBarView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    
    DVXBarView *xBarView = [[DVXBarView alloc] init];
    
    [scrollView addSubview:xBarView];
    
    [self addSubview:scrollView];
    
    self.scrollView = scrollView;
    self.xBarView = xBarView;
    self.xBarView.delegate = self;
    self.yBarView = yBarView;
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    
}
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self == [super initWithFrame:frame]) {
        
        [self commonInit];
        
    }
    return self;
}

- (void)awakeFromNib {
    
    [self commonInit];
}

+ (instancetype)barChartView {
    return [[self alloc] init];
}

- (void)xBarView:(DVXBarView *)xBarView didClickButtonAtIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(barChartView:didSelectedBarAtIndex:)]) {
        [self.delegate barChartView:self didSelectedBarAtIndex:index];
    }
}
@end
