//
//  DVBarChartView.h
//  xxxxx
//
//  Created by Fire on 15/11/11.
//  Copyright © 2015年 DuoLaiDian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DVBarChartView;

@protocol DVBarChartViewDelegate <NSObject>

@optional
- (void)barChartView:(DVBarChartView *)barChartView didSelectedBarAtIndex:(NSInteger)index;

@end

@interface DVBarChartView : UIView

@property (weak, nonatomic) id<DVBarChartViewDelegate> delegate;
/**
 *  文字大小
 */
@property (strong, nonatomic) UIFont *textFont;
/**
 *  文字颜色
 */
@property (strong, nonatomic) UIColor *textColor;
/**
 *  x轴文字与坐标轴间隙(The distance from x axis text to x axis line, default is 10)
 */
@property (assign, nonatomic) CGFloat xAxisTextGap;
/**
 *  坐标轴颜色
 */
@property (strong, nonatomic) UIColor *axisColor;
/**
 *  x轴的文字集合
 */
@property (strong, nonatomic) NSArray *xAxisTitleArray;
/**
 *  柱与柱之间的间距
 */
@property (assign, nonatomic) CGFloat barGap;
/**
 *  柱的宽度
 */
@property (assign, nonatomic) CGFloat barWidth;
/**
 *  柱的颜色
 */
@property (strong, nonatomic) UIColor *barColor;
/**
 *  柱的选中的颜色
 */
@property (strong, nonatomic) UIColor *barSelectedColor;
/**
 *  存放y轴数值的数组(The data array used to display)
 */
@property (strong, nonatomic) NSArray *xValues;


/**
 *  y轴文字与坐标轴间隙
 */
@property (assign, nonatomic) CGFloat yAxisTextGap;
/**
 *  y轴的最大值
 */
@property (assign, nonatomic) CGFloat yAxisMaxValue;
/**
 *  y轴分为几段
 */
@property (assign, nonatomic) int numberOfYAxisElements;
/**
 *  y轴与左侧的间距
 */
@property (assign, nonatomic) CGFloat yAxisViewWidth;
/**
 *  y轴数值是否添加百分号
 */
@property (assign, nonatomic, getter=isPercent) BOOL percent;
/**
 *  是否显示点Label
 */
@property (assign, nonatomic, getter=isShowPointLabel) BOOL showPointLabel;

/**
 *  视图的背景颜色
 */
@property (strong, nonatomic) UIColor *backColor;
/**
 *  点是否允许点击
 */
@property (assign, nonatomic, getter=isBarUserInteractionEnabled) BOOL barUserInteractionEnabled;

/**
 *  标记选中哪一个柱子
 */
@property (assign, nonatomic) NSInteger index;

/**
 *  快速创建方法
 */
+ (instancetype)barChartView;

- (void)draw;
@end
