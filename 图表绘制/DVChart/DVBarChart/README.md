# DVBarChart
A Simple BarChartView For Simple data statistics

![img](http://d.pr/i/1awxO+ "img")

简单描述
---------------------
柱状图图表，设置好数据就能显示，可以滚动，点击

一些基本的属性就不进行介绍了，在Demo中都有注释

####x轴数据<DVBarChartView.h>

```
/**
 *  x轴的文字集合
 */
@property (strong, nonatomic) NSArray *xAxisTitleArray;


```
* x轴的数据就是从上面的数组属性中取出的

####y轴数据<DVBarChartView.h>

```
/**
 *  y轴的最大值
 */
@property (assign, nonatomic) CGFloat yAxisMaxValue;
/**
 *  y轴分为几段
 */
@property (assign, nonatomic) int numberOfYAxisElements;


```
* y轴的数据是由y轴的一个最大值和y轴需要分为几段来确定的

####柱形图数据<DVBarChartView.h>

```
/**
 *  存放y轴数值的数组
 */
@property (strong, nonatomic) NSArray *xValues;


```
* 柱状图是通过上面这个数组中的数据来画出来的

####设置图表背景颜色

```

/**
 *  视图的背景颜色
 */
@property (strong, nonatomic) UIColor *backColor;


```
####是否显示柱形图上方的文字

```

/**
 *  是否显示点Label
 */
@property (assign, nonatomic, getter=isShowPointLabel) BOOL showPointLabel;
```

####y轴和屏幕左侧的距离

```

/**
 *  y轴与左侧的间距
 */
@property (assign, nonatomic) CGFloat yAxisViewWidth;
```
####如果数值是百分比数值

```
/**
 *  y轴数值是否添加百分号
 */
@property (assign, nonatomic, getter=isPercent) BOOL percent;
```
* 当传入的数值是百分比数值时，通过这个属性来添加百分号
####柱形图是否添加点击事件

```

/**
 *  点是否允许点击
 */
@property (assign, nonatomic, getter=isBarUserInteractionEnabled) BOOL barUserInteractionEnabled;


@property (weak, nonatomic) id<DVBarChartViewDelegate> delegate;


@protocol DVBarChartViewDelegate <NSObject>

@optional
- (void)barChartView:(DVBarChartView *)barChartView didSelectedBarAtIndex:(NSInteger)index;

@end

```
####我们可以通过一个索引值来对图表进行定位

```
/**
 *  定位时的索引值
 */
@property (assign, nonatomic) NSInteger index;
```
* 当 index<0 时，无法进行定位

####我们可以通过一个索引值来对图表进行定位

```
/**
 *  定位时的索引值
 */
@property (assign, nonatomic) NSInteger index;
```
* 当 index<0 时，无法进行定位
