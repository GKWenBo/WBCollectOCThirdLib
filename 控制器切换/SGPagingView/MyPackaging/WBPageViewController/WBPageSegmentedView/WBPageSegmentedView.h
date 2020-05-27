//
//  WB_PageSegmentedView.h
//  WB_PageViewControllerDemo1
//
//  Created by WMB on 2017/8/13.
//  Copyright © 2017年 文波. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WBPageSegmentedView;

typedef NS_ENUM(NSInteger,WBIndicatorLengthStyle) {
    WBIndicatorLengthDefaultStyle,/**  < 指示器长度等于按钮宽度 >  */
    WBIndicatorLengthEqualStyle,   /**  < 指示器长度等于按钮文字宽度 >  */
    WBIndicatorLengthSpecialStyle  /**  < 标题不可滚动时, 指示器长度样式不想设为 Default、Equal 时, 便可设为 Special 样式；标题可滚动时，不起作用 >  */
};

typedef NS_ENUM(NSInteger,WB_IndicatorScrollStyle) {
    WBIndicatorScrollDefaultStyle,/**  < 指示器位置跟随内容滚动而改变 >  */
    WBIndicatorScrollHalfStyle,    /**  < 内容滚动一半时指示器位置改变 >  */
    WBIndicatorScrollEndStyle      /**  < 内容滚动结束时指示器位置改变 >  */
};

@protocol WB_PageSegmentedViewDelegate <NSObject>

- (void)pageTitleView:(WBPageSegmentedView *)pageTitleView selectedIndex:(NSInteger)selectedIndex;

@end

@interface WBPageSegmentedView : UIView

#pragma mark --------  Property  --------
#pragma mark
/**  < 是否需要弹性效果，默认为 YES >  */
@property (nonatomic,assign) BOOL isNeedBounces;
/**  < 普通状态下标题按钮文字的颜色，默认为黑色 >  */
@property (nonatomic,strong) UIColor * titleColorStateNormal;
/**  < 选中状态下标题按钮文字的颜色，默认为红色 >  */
@property (nonatomic,strong) UIColor * titleColorStateSelected;
/**  < 指示器颜色，默认为红色 >  */
@property (nonatomic,strong) UIColor * indicatorColor;
/**  < 指示器高度，默认为 2.0f >  */
@property (nonatomic,assign) CGFloat indicatorHeight;
/**  < 指示器动画时间，默认为 0.1f，取值范围 >  */
@property (nonatomic,assign) CGFloat indicatorAnimationTime;
/**  < 选中标题按钮下标，默认为 0 >  */
@property (nonatomic,assign) NSInteger selectedIndex;
/**  < 重置选中标题按钮下标（用于子控制器内的点击事件改变标题的选中下标 >  */
@property (nonatomic,assign) NSInteger resetSelectedIndex;
/**  < 指示器长度样式，默认为WB_IndicatorLengthDefaultStyle >  */
@property (nonatomic,assign) WBIndicatorLengthStyle indicatorLengthStyle;
/**  < 指示器滚动位置改变样式，默认为WB_IndicatorScrollDefaultStyle >  */
@property (nonatomic,assign) WB_IndicatorScrollStyle indicatorScrollStyle;
/**  < 是否让标题按钮文字有渐变效果，默认为 YES >  */
@property (nonatomic,assign) BOOL isTitleGradientEffect;
/**  < 是否开启标题按钮文字缩放效果，默认为 NO >  */
@property (nonatomic,assign) BOOL isOpenTitleTextZoom;
/**  < 标题文字缩放比，默认为 0.1f，取值范围 0 ～ 0.3f >  */
@property (nonatomic,assign) CGFloat titleTextScaling;
/**  < 是否显示指示器，默认为 YES >  */
@property (nonatomic,assign) BOOL isShowIndicator;
/**  < 是否显示底部分割线，默认为 YES >  */
@property (nonatomic,assign) BOOL isShowBottomSeparator;

/**
 给外界提供的方法

 @param progress 滚动进度比例
 @param originalIndex 原下标
 @param targetIndex 目标下标
 */
- (void)setPageTitleViewWithProgress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex;

/**
 根据下标修改标题文字

 @param index 下标
 @param title 标题
 */
- (void)resetTitleWithIndex:(NSInteger)index newTitle:(NSString *)title;


/**
 对象方法创建WB_PageSegmentedView

 @param frame 位置大小
 @param delegate 代理
 @param titleArray 标题数组
 @return WB_PageSegmentedView
 */
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<WB_PageSegmentedViewDelegate>)delegate titleArray:(NSArray <NSString *>*)titleArray;

/**
 类方法创建WB_PageSegmentedView

 @param frame 位置大小
 @param delegate 代理
 @param titleArray 标题数组
 @return WB_PageSegmentedView
 */
+ (instancetype)pageTitleViewWithFrame:(CGRect)frame delegate:(id<WB_PageSegmentedViewDelegate>)delegate titleArray:(NSArray <NSString *>*)titleArray;

@end
