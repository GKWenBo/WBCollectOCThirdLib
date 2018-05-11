//
//  WBSegmentView.h
//  WBPageController
//
//  Created by wenbo on 2018/5/9.
//  Copyright © 2018年 wenbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

@class WBSegmentView;

@protocol WBSegmentViewDelegate <NSObject>

/**
 分段控件选中下标回调
 
 @param wbSegmentView WBSegmentView
 @param index 选中下标
 */
- (void)wbSegmentView:(WBSegmentView *)wbSegmentView
     didSelectedIndex:(NSInteger)index;

@end

@interface WBSegmentView : UIView

@property (nonatomic, assign) id<WBSegmentViewDelegate> delegate;
/** < 分段控件 >  */
@property (nonatomic, strong) HMSegmentedControl *segmentControl;
/**  < 标题字体大小 默认系统14pt >  */
@property (nonatomic, strong) UIFont *normalFont;
/** < 选中字体大小 default: 14pt >  */
@property (nonatomic, strong) UIFont *selectedFont;
/**  < 未选中颜色 默认白色 >  */
@property (nonatomic, strong) UIColor *normalColor;
/**  < 选中颜色 默认白色 >  */
@property (nonatomic, strong) UIColor *selectedColor;
/**  < 指示器高度 默认2.f >  */
@property (nonatomic,assign) CGFloat selectionIndicatorHeight;
/**  < 指示器位置 默认在下 >  */
@property (nonatomic, assign) HMSegmentedControlSelectionIndicatorLocation selectionIndicatorLocation;
/**  < 选中样式 默认HMSegmentedControlSelectionStyleTextWidthStripe >  */
@property (nonatomic, assign) HMSegmentedControlSelectionStyle selectionStyle;
/**  < 宽度样式 默认HMSegmentedControlSegmentWidthStyleFixed >  */
@property (nonatomic, assign) HMSegmentedControlSegmentWidthStyle segmentWidthStyle;

/**  < 初始化方法 文字类型 >  */
- (instancetype)initWithFrame:(CGRect)frame
                   titleArray:(NSArray<NSString *>*)titleArray;

/**
 提供给外界选中方法

 @param index 选中下标
 @param animated 是否动画
 */
- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated;

/**
 重设位置大小

 @param frame CGRect
 */
- (void)wb_resetFrame:(CGRect)frame;

@end
