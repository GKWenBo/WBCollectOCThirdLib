//
//  WB_ReuseSegmentedView.h
//  HMSegmentedControl封装
//
//  Created by WMB on 2017/8/12.
//  Copyright © 2017年 文波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

@class WBReuseSegmentedView;
@protocol WBReuseSegmentedViewDelegate <NSObject>

- (void)wb_reuseSegmentedView:(WBReuseSegmentedView *)wb_reuseSegmentedView selectedIndex:(NSInteger)selectedIndex;

@end

@interface WBReuseSegmentedView : UIView
/**  < 标题字体大小 默认系统14pt >  */
@property (nonatomic,strong) UIFont *font;
/**  < 未选中颜色 默认白色 >  */
@property (nonatomic,strong) UIColor *normalColor;
/**  < 选中颜色 默认白色 >  */
@property (nonatomic,strong) UIColor *selectedColor;
/**  < 指示器高度 默认2.f >  */
@property (nonatomic,assign) CGFloat selectionIndicatorHeight;
/**  < 指示器位置 默认在下 >  */
@property (nonatomic,assign) HMSegmentedControlSelectionIndicatorLocation selectionIndicatorLocation;
/**  < 选中样式 默认HMSegmentedControlSelectionStyleTextWidthStripe >  */
@property (nonatomic,assign) HMSegmentedControlSelectionStyle selectionStyle;
/**  < 宽度样式 默认HMSegmentedControlSegmentWidthStyleFixed >  */
@property (nonatomic,assign) HMSegmentedControlSegmentWidthStyle segmentWidthStyle;
/**
 Inset left and right edges of segments.
 
 Default is UIEdgeInsetsMake(0, 5, 0, 5)
 */
@property (nonatomic, readwrite) UIEdgeInsets segmentEdgeInset;
/**  < 是否能拖动 默认NO >  */
@property (nonatomic,assign) BOOL userDraggable;


/**  < 分段控件 >  */
@property (nonatomic,strong) HMSegmentedControl * segmentedControl;
@property (nonatomic,assign) id <WBReuseSegmentedViewDelegate> delegate;


/**  < 初始化方法 文字类型 >  */
- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray<NSString *>*)titleArray;
/**  < 初始化方法 图片类型 >  */
- (instancetype)initWithFrame:(CGRect)frame imageNormalArray:(NSArray<UIImage *>*)imageNormalArray selectedImageArray:(NSArray <UIImage *> *)selectedImageArray;
/**  < 图片文字类型 >  */
- (instancetype)initWithFrame:(CGRect)frame imageNormalArray:(NSArray<UIImage *>*)imageNormalArray selectedImageArray:(NSArray <UIImage *> *)selectedImageArray titleArray:(NSArray<NSString *>*)titleArray;
@end
