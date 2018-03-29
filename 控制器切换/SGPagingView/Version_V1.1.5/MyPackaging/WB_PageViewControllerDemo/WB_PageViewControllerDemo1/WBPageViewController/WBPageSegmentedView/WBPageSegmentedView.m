//
//  WB_PageSegmentedView.m
//  WB_PageViewControllerDemo1
//
//  Created by WMB on 2017/8/13.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "WBPageSegmentedView.h"
#import "WBPageSegmentButton.h"
#import "UIView+WBFrame.h"

#define kWB_PageSegmentedView_Height self.frame.size.height
#define kWB_PageSegmentedView_Width self.frame.size.width
#define BTN_TAG 9999

/**  < 按钮之间的间距 >  */
static CGFloat const WB_PageSegmentedViewMargin = 20;
static CGFloat const WB_IndicatorTypeSpecialMultipleLength = 20;
//static CGFloat const WB_PageSegmentedViewTitleFont = 16;

@interface WBPageSegmentedView ()

@property (nonatomic,assign) id <WB_PageSegmentedViewDelegate> delegatePageSegmentedView;
/**  < 保存外界传递过来的标题数组 >  */
@property (nonatomic,strong) NSArray * titleArr;
/**  < 标题滚动视图 >  */
@property (nonatomic,strong) UIScrollView * scrollView;
/**  < 指示器 >  */
@property (nonatomic,strong) UIView * indicatorView;
/**  < 底部分割线 >  */
@property (nonatomic,strong) UIView * bottomSeparator;
/**  < 存储标题按钮的数组 >  */
@property (nonatomic,strong) NSMutableArray * btnMArr;
/**  < tempBtn >  */
@property (nonatomic,strong) UIButton * tempBtn;
/**  < 记录所有按钮文字宽度 >  */
@property (nonatomic,assign) CGFloat allBtnTextWidth;
/**  < 记录所有子控件的宽度 >  */
@property (nonatomic,assign) CGFloat allBtnWidth;
/**  < 开始颜色, 取值范围 0~1 >  */
@property (nonatomic, assign) CGFloat startR;
@property (nonatomic, assign) CGFloat startG;
@property (nonatomic, assign) CGFloat startB;
/**  < 完成颜色, 取值范围 0~1 >  */
@property (nonatomic, assign) CGFloat endR;
@property (nonatomic, assign) CGFloat endG;
@property (nonatomic, assign) CGFloat endB;
@end

@implementation WBPageSegmentedView

#pragma mark --------  初始化  --------
#pragma mark
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<WB_PageSegmentedViewDelegate>)delegate titleArray:(NSArray<NSString *> *)titleArray {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.77];
        self.delegatePageSegmentedView = delegate;
        self.titleArr = titleArray;
        [self defaultConfig];
        [self setupUI];
    }
    return self;
}

+ (instancetype)pageTitleViewWithFrame:(CGRect)frame delegate:(id<WB_PageSegmentedViewDelegate>)delegate titleArray:(NSArray<NSString *> *)titleArray {
    return [[self alloc]initWithFrame:frame delegate:delegate titleArray:titleArray];
}

#pragma mark --------  默认配置  --------
#pragma mark
- (void)defaultConfig {
    _isTitleGradientEffect = YES;
    _isOpenTitleTextZoom = NO;
    _isShowIndicator = YES;
    _isNeedBounces = YES;
    _isShowBottomSeparator = YES;
    _indicatorScrollStyle = WBIndicatorScrollDefaultStyle;
    
    _selectedIndex = 0;
    _titleTextScaling = 0.1;
    _indicatorAnimationTime = 0.1;
    _indicatorHeight = 2;
    _fontSize = 14.f;
}

- (void)setupUI {
    [self addSubview:self.scrollView];
    [self addTitleButtons];
    [self addSubview:self.bottomSeparator];
    self.indicatorLengthStyle = WBIndicatorLengthDefaultStyle;
}

#pragma mark --------  Layout  --------
#pragma mark
- (void)layoutSubviews {
    [super layoutSubviews];
    UIButton *lastBtn = self.btnMArr.lastObject;
    if (lastBtn.tag - BTN_TAG >= self.selectedIndex && self.selectedIndex >= 0) {
        [self buttonClicked:self.btnMArr[self.selectedIndex]];
        self.selectedIndex = - 1;/**  < 说明：这里的 -1；随便设或者大于 lastBtn 的 tag 值也可 >  */
    }else {
        return;
    }
}


#pragma mark --------  Add TitleButton  --------
#pragma mark
- (void)addTitleButtons {
    /**  < 移除子视图 重新布局 >  */
    [self.btnMArr removeAllObjects];
    for (UIView *view in self.scrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    [self.titleArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat tempWidth = [self wb_calculateStringWidthWithString:obj font:[UIFont systemFontOfSize:_fontSize]];
        self.allBtnTextWidth += tempWidth;
    }];
    /**  < 所有按钮文字宽度 ＋ 按钮之间的间隔 >  */
    self.allBtnWidth = WB_PageSegmentedViewMargin * (self.titleArr.count + 1) + self.allBtnTextWidth;
    self.allBtnWidth = ceilf(self.allBtnWidth);
    if (self.allBtnWidth <= self.width) {
        __block CGFloat btn_x = 0;
        CGFloat btn_y = 0;
        CGFloat btn_w = kWB_PageSegmentedView_Width / self.titleArr.count;
        CGFloat btn_h = kWB_PageSegmentedView_Height - self.indicatorHeight;
        [self.titleArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WBPageSegmentButton *button = [[WBPageSegmentButton alloc]init];
            btn_x = btn_w * idx;
            button.frame = CGRectMake(btn_x, btn_y, btn_w, btn_h);
            button.tag = idx + BTN_TAG;
            button.titleLabel.font = [UIFont systemFontOfSize:_fontSize];
            [button setTitle:obj forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.btnMArr addObject:button];
            [self.scrollView addSubview:button];
        }];
        self.scrollView.contentSize = CGSizeMake(kWB_PageSegmentedView_Width, 0);
    }else {
        /**  < 可滚动 >  */
        __block CGFloat btn_x = 0;
        CGFloat btn_y = 0;
        CGFloat btn_h = kWB_PageSegmentedView_Height - self.indicatorHeight;
        __block CGFloat btn_w = 0;
        [self.titleArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WBPageSegmentButton *button = [WBPageSegmentButton buttonWithType:UIButtonTypeCustom];
            btn_w = [self wb_calculateStringWidthWithString:obj font:[UIFont systemFontOfSize:_fontSize]] + WB_PageSegmentedViewMargin;
            button.frame = CGRectMake(btn_x, btn_y, btn_w, btn_h);
            btn_x += btn_w;
            button.tag = idx + BTN_TAG;
            button.titleLabel.font = [UIFont systemFontOfSize:_fontSize];
            [button setTitle:obj forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.btnMArr addObject:button];
            [self.scrollView addSubview:button];
        }];
        CGFloat contentWidth = CGRectGetMaxX(self.scrollView.subviews.lastObject.frame);
        self.scrollView.contentSize = CGSizeMake(contentWidth, 0);
    }
}

#pragma mark --------  Event Response  --------
#pragma mark
- (void)buttonClicked:(UIButton *)sender {
    /**  < 改变按钮的选择状态 >  */
    [self changeSelectedButton:sender];
    /**  < 滚动标题选中居中 >  */
    if (self.allBtnWidth > kWB_PageSegmentedView_Width) {
        [self selectedBtnCenter:sender];
    }
    /**  < 改变指示器的位置 >  */
    [self changeIndicatorViewLocationWithButton:sender];
    if (_delegatePageSegmentedView && [_delegatePageSegmentedView respondsToSelector:@selector(pageTitleView:selectedIndex:)]) {
        [_delegatePageSegmentedView pageTitleView:self selectedIndex:sender.tag - BTN_TAG];
    }
}

#pragma mark --------  Public Method  --------
#pragma mark
/**
 根据下标修改标题文字
 
 @param index 下标
 @param title 标题
 */
- (void)resetTitleWithIndex:(NSInteger)index newTitle:(NSString *)title {
    if (index < self.btnMArr.count) {
        UIButton * button = self.btnMArr[index];
        [button setTitle:title forState:UIControlStateNormal];
        [self setIndicatorLengthStyle:self.indicatorLengthStyle];
    }
}

/**
 给外界提供的方法
 
 @param progress 滚动进度比例
 @param originalIndex 原下标
 @param targetIndex 目标下标
 */
- (void)setPageTitleViewWithProgress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    /**  < 取出 originalBtn／targetBtn >  */
    UIButton *originBtn = self.btnMArr[originalIndex];
    UIButton *targetBtn = self.btnMArr[targetIndex];
    /**  < 滚动标题选中居中 >  */
    [self selectedBtnCenter:targetBtn];
    /**  < 处理指示器的逻辑 >  */
    if (self.allBtnWidth <= self.width) {
        switch (self.indicatorScrollStyle) {
            case WBIndicatorScrollDefaultStyle:
                [self smallIndicatorScrollStyleDefaultWithProgress:progress originalBtn:originBtn targetBtn:targetBtn];
                break;
            case WBIndicatorScrollHalfStyle:
                [self smallIndicatorScrollStyleHalfEndWithProgress:progress originalBtn:originBtn targetBtn:targetBtn];
                break;
            case WBIndicatorScrollEndStyle:
                [self smallIndicatorScrollStyleHalfEndWithProgress:progress originalBtn:originBtn targetBtn:targetBtn];
                break;
            default:
                break;
        }
    }else {
        switch (self.indicatorScrollStyle) {
            case WBIndicatorScrollDefaultStyle:
                [self indicatorScrollStyleDefaultWithProgress:progress originalBtn:originBtn targetBtn:targetBtn];
                break;
            case WBIndicatorScrollHalfStyle:
                [self indicatorScrollStyleHalfEndWithProgress:progress originalBtn:originBtn targetBtn:targetBtn];
                break;
            case WBIndicatorScrollEndStyle:
                [self indicatorScrollStyleHalfEndWithProgress:progress originalBtn:originBtn targetBtn:targetBtn];
                break;
            default:
                break;
        }
    }
    
    /**  < 颜色的渐变(复杂) >  */
    if (self.isTitleGradientEffect) {
        [self isTitleGradientEffectWithProgress:progress originalBtn:originBtn targetBtn:targetBtn];
    }
    
    /**  < 标题文字缩放属性 >  */
    if (self.isOpenTitleTextZoom) {
        // 左边缩放
        originBtn.transform = CGAffineTransformMakeScale((1 - progress) * self.titleTextScaling + 1, (1 - progress) * self.titleTextScaling + 1);
        // 右边缩放
        targetBtn.transform = CGAffineTransformMakeScale(progress * self.titleTextScaling + 1, progress * self.titleTextScaling + 1);
    }
}

#pragma mark --------  Private Method  --------
#pragma mark
- (CGFloat)wb_calculateStringWidthWithString:(NSString *)string font:(UIFont *)font {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [string boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
}

- (void)changeSelectedButton:(UIButton *)button {
    if (self.tempBtn == nil) {
        button.selected = YES;
        self.tempBtn = button;
    }else if (self.tempBtn != nil && self.tempBtn == button) {
        button.selected = YES;
    }else if (self.tempBtn != nil && self.tempBtn != button) {
        self.tempBtn.selected = NO;
        button.selected = YES;
        self.tempBtn = button;
    }
    /**  < 文字缩放属性 >  */
    if (self.isOpenTitleTextZoom) {
        [self.btnMArr enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.transform = CGAffineTransformMakeScale(1, 1);
        }];
        button.transform = CGAffineTransformMakeScale(1 + self.titleTextScaling, 1 + self.titleTextScaling);
    }
}

- (void)selectedBtnCenter:(UIButton *)centerBtn {
    /**  < 计算偏移量 >  */
    CGFloat offsetX = centerBtn.center.x - kWB_PageSegmentedView_Width * 0.5;
    if (offsetX < 0) offsetX = 0;
    /**  < 获取最大滚动范围 >  */
    CGFloat maxOffsetX = self.scrollView.contentSize.width - kWB_PageSegmentedView_Width;
    if (offsetX > maxOffsetX) offsetX = maxOffsetX;
    /**  < 滚动标题滚动条 >  */
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

- (void)changeIndicatorViewLocationWithButton:(UIButton *)button {
    if (self.allBtnWidth <= self.width) {
        [UIView animateWithDuration:self.indicatorAnimationTime animations:^{
            switch (self.indicatorLengthStyle) {
                case WBIndicatorLengthEqualStyle:
                    self.indicatorView.width = [self wb_calculateStringWidthWithString:button.currentTitle font:[UIFont systemFontOfSize:_fontSize]];
                    break;
                case WBIndicatorLengthDefaultStyle:
                    self.indicatorView.width = button.width;
                    break;
                case WBIndicatorLengthSpecialStyle:
                    self.indicatorView.width = [self wb_calculateStringWidthWithString:button.currentTitle font:[UIFont systemFontOfSize:_fontSize]] + WB_IndicatorTypeSpecialMultipleLength;
                    break;
                default:
                    break;
            }
            self.indicatorView.centerX = button.centerX;
        }];
    }else {
        /**  < 可滚动 >  */
        [UIView animateWithDuration:self.indicatorAnimationTime animations:^{
            switch (self.indicatorLengthStyle) {
                case WBIndicatorLengthEqualStyle:
                    self.indicatorView.width = button.width - WB_PageSegmentedViewMargin;
                    break;
                default:
                    self.indicatorView.width = button.width;
                    break;
            }
            self.indicatorView.centerX = button.centerX;
        }];
    }
}

/**  < 可滚动 >  */
- (void)indicatorScrollStyleDefaultWithProgress:(CGFloat)progress originalBtn:(UIButton *)originalBtn targetBtn:(UIButton *)targetBtn {
    /**  < 改变按钮的选择状态 此处取 >= 0.8 而不是 1.0 为的是防止用户滚动过快而按钮的选中状态并没有改变 >  */
    if (progress >= 0.8) {
        [self changeSelectedButton:targetBtn];
    }
    /**  < 计算 targetBtn／originalBtn 之间的距离 >  */
    CGFloat totalOffsetX = targetBtn.left - originalBtn.left;
    /**  < 计算 targetBtn／originalBtn 宽度的差值 >  */
    CGFloat totalDistance = targetBtn.right - originalBtn.right;
    /**  < 计算 indicatorView 滚动时 X 的偏移量 >  */
    CGFloat offsetX;
    /**  < 计算 indicatorView 滚动时宽度的偏移量 >  */
    CGFloat distance;
    switch (self.indicatorLengthStyle) {
        case WBIndicatorLengthEqualStyle:
            offsetX = totalOffsetX * progress + 0.5 * WB_PageSegmentedViewMargin;
            distance = progress * (totalDistance - totalOffsetX) - WB_PageSegmentedViewMargin;
            break;
        default:
            offsetX = totalOffsetX * progress;
            distance = progress * (totalDistance - totalOffsetX);
            break;
    }
    /**  < 计算 indicatorView 新的 frame >  */
    self.indicatorView.left = originalBtn.left + offsetX;
    self.indicatorView.width = originalBtn.width + distance;
}

/**  < 不可滚动 >  */
- (void)smallIndicatorScrollStyleHalfEndWithProgress:(CGFloat)progress originalBtn:(UIButton *)originalBtn targetBtn:(UIButton *)targetBtn {
    switch (self.indicatorScrollStyle) {
        case WBIndicatorScrollHalfStyle:
        {
            if (progress >= 0.5) {
                [UIView animateWithDuration:self.indicatorAnimationTime animations:^{
                    switch (self.indicatorLengthStyle) {
                        case WBIndicatorLengthEqualStyle:
                            self.indicatorView.width = [self wb_calculateStringWidthWithString:targetBtn.currentTitle font:[UIFont systemFontOfSize:_fontSize]];
                            break;
                        case WBIndicatorLengthSpecialStyle:
                            self.indicatorView.width = [self wb_calculateStringWidthWithString:targetBtn.currentTitle font:[UIFont systemFontOfSize:_fontSize]] + WB_IndicatorTypeSpecialMultipleLength;
                            break;
                        default:
                            self.indicatorView.width = targetBtn.width;
                            break;
                    }
                    self.indicatorView.centerX = targetBtn.centerX;
                }];
                [self changeSelectedButton:targetBtn];
            }else {
                [UIView animateWithDuration:self.indicatorAnimationTime animations:^{
                    switch (self.indicatorLengthStyle) {
                        case WBIndicatorLengthEqualStyle:
                            self.indicatorView.width = [self wb_calculateStringWidthWithString:originalBtn.currentTitle font:[UIFont systemFontOfSize:_fontSize]];
                            break;
                        case WBIndicatorLengthSpecialStyle:
                            self.indicatorView.width = [self wb_calculateStringWidthWithString:originalBtn.currentTitle font:[UIFont systemFontOfSize:_fontSize]] + WB_IndicatorTypeSpecialMultipleLength;
                            break;
                        default:
                            self.indicatorView.width = originalBtn.width;
                            break;
                    }
                    self.indicatorView.centerX = originalBtn.centerX;
                }];
                [self changeSelectedButton:originalBtn];
            }
        }
            break;
        default:
        {
            if (progress == 1.0) {
                [UIView animateWithDuration:self.indicatorAnimationTime animations:^{
                    switch (self.indicatorLengthStyle) {
                        case WBIndicatorLengthEqualStyle:
                            self.indicatorView.width = [self wb_calculateStringWidthWithString:targetBtn.currentTitle font:[UIFont systemFontOfSize:_fontSize]];
                            break;
                        case WBIndicatorLengthSpecialStyle:
                            self.indicatorView.width = [self wb_calculateStringWidthWithString:targetBtn.currentTitle font:[UIFont systemFontOfSize:_fontSize]] + WB_IndicatorTypeSpecialMultipleLength;
                            break;
                        default:
                            self.indicatorView.width = targetBtn.width;
                            break;
                    }
                    self.indicatorView.centerX = targetBtn.centerX;
                }];
                [self changeSelectedButton:targetBtn];
            }else {
                [UIView animateWithDuration:self.indicatorAnimationTime animations:^{
                    switch (self.indicatorLengthStyle) {
                        case WBIndicatorLengthEqualStyle:
                            self.indicatorView.width = [self wb_calculateStringWidthWithString:originalBtn.currentTitle font:[UIFont systemFontOfSize:_fontSize]];
                            break;
                        case WBIndicatorLengthSpecialStyle:
                            self.indicatorView.width = [self wb_calculateStringWidthWithString:originalBtn.currentTitle font:[UIFont systemFontOfSize:_fontSize]] + WB_IndicatorTypeSpecialMultipleLength;
                            break;
                        default:
                            self.indicatorView.width = originalBtn.width;
                            break;
                    }
                    self.indicatorView.centerX = originalBtn.centerX;
                }];
                [self changeSelectedButton:originalBtn];
            }
        }
            break;
    }
}

/**  < 不可滚动 >  */
- (void)smallIndicatorScrollStyleDefaultWithProgress:(CGFloat)progress originalBtn:(UIButton *)originalBtn targetBtn:(UIButton *)targetBtn {
    /**  < 改变按钮的选择状态 此处取 >= 0.8 而不是 1.0 为的是防止用户滚动过快而按钮的选中状态并没有改变 >  */
    if (progress >= 0.8) {
        [self changeSelectedButton:targetBtn];
    }
    switch (self.indicatorLengthStyle) {
        case WBIndicatorLengthEqualStyle:
        {
            CGFloat targetBtnX = CGRectGetMaxX(targetBtn.frame) - [self wb_calculateStringWidthWithString:targetBtn.currentTitle font:[UIFont systemFontOfSize:_fontSize]] - 0.5 * (self.width / self.titleArr.count - [self wb_calculateStringWidthWithString:targetBtn.currentTitle font:[UIFont systemFontOfSize:_fontSize]]);
            CGFloat originalBtnX = CGRectGetMaxX(originalBtn.frame) - [self wb_calculateStringWidthWithString:originalBtn.currentTitle font:[UIFont systemFontOfSize:_fontSize]] - 0.5 * (self.width / self.titleArr.count - [self wb_calculateStringWidthWithString:originalBtn.currentTitle font:[UIFont systemFontOfSize:_fontSize]]);
            CGFloat totalOffsetX = targetBtnX - originalBtnX;
            
            /// 计算 targetBtn／originalBtn 宽度的差值
            CGFloat targetBtnDistance = (CGRectGetMaxX(targetBtn.frame) - 0.5 * (self.width / self.titleArr.count - [self wb_calculateStringWidthWithString:targetBtn.currentTitle font:[UIFont systemFontOfSize:_fontSize]]));
            CGFloat originalBtnDistance = (CGRectGetMaxX(originalBtn.frame) - 0.5 * (self.width / self.titleArr.count - [self wb_calculateStringWidthWithString:originalBtn.currentTitle font:[UIFont systemFontOfSize:_fontSize]]));
            CGFloat totalDistance = targetBtnDistance - originalBtnDistance;
            /// 计算 indicatorView 滚动时 X 的偏移量
            CGFloat offsetX;
            /// 计算 indicatorView 滚动时宽度的偏移量
            CGFloat distance;
            offsetX = totalOffsetX * progress;
            distance = progress * (totalDistance - totalOffsetX);
            /// 计算 indicatorView 新的 frame
            self.indicatorView.left = originalBtnX + offsetX;
            self.indicatorView.width = [self wb_calculateStringWidthWithString:originalBtn.currentTitle font:[UIFont systemFontOfSize:_fontSize]] + distance;
        }
            break;
        case WBIndicatorLengthSpecialStyle:
        {
            CGFloat targetBtnX = CGRectGetMaxX(targetBtn.frame) - [self wb_calculateStringWidthWithString:targetBtn.currentTitle font:[UIFont systemFontOfSize:_fontSize]] - 0.5 * (self.width / self.titleArr.count - [self wb_calculateStringWidthWithString:targetBtn.currentTitle font:[UIFont systemFontOfSize:_fontSize]] + WB_IndicatorTypeSpecialMultipleLength);
            CGFloat originalBtnX = CGRectGetMaxX(originalBtn.frame) - [self wb_calculateStringWidthWithString:originalBtn.currentTitle font:[UIFont systemFontOfSize:_fontSize]] - 0.5 * (self.width / self.titleArr.count - [self wb_calculateStringWidthWithString:originalBtn.currentTitle font:[UIFont systemFontOfSize:_fontSize]] + WB_IndicatorTypeSpecialMultipleLength);
            CGFloat totalOffsetX = targetBtnX - originalBtnX;
            
            /// 计算 targetBtn／originalBtn 宽度的差值
            CGFloat targetBtnDistance = (CGRectGetMaxX(targetBtn.frame) - 0.5 * (self.width / self.titleArr.count - [self wb_calculateStringWidthWithString:targetBtn.currentTitle font:[UIFont systemFontOfSize:_fontSize]]));
            CGFloat originalBtnDistance = (CGRectGetMaxX(originalBtn.frame) - 0.5 * (self.width / self.titleArr.count - [self wb_calculateStringWidthWithString:originalBtn.currentTitle font:[UIFont systemFontOfSize:_fontSize]]));
            CGFloat totalDistance = targetBtnDistance - originalBtnDistance;
            /// 计算 indicatorView 滚动时 X 的偏移量
            CGFloat offsetX;
            /// 计算 indicatorView 滚动时宽度的偏移量
            CGFloat distance;
            offsetX = totalOffsetX * progress;
            distance = progress * (totalDistance - totalOffsetX);
            /// 计算 indicatorView 新的 frame
            self.indicatorView.left = originalBtnX + offsetX;
            self.indicatorView.width = [self wb_calculateStringWidthWithString:originalBtn.currentTitle font:[UIFont systemFontOfSize:_fontSize]] + distance + WB_IndicatorTypeSpecialMultipleLength;
        }
            break;
        default:
        {
            CGFloat moveTotalX = targetBtn.left - originalBtn.left;
            CGFloat moveX = moveTotalX * progress;
            self.indicatorView.centerX = originalBtn.centerX + moveX;
        }
            break;
    }
}

/**  < 可滚动 >  */
- (void)indicatorScrollStyleHalfEndWithProgress:(CGFloat)progress originalBtn:(UIButton *)originalBtn targetBtn:(UIButton *)targetBtn {
    switch (self.indicatorScrollStyle) {
        case WBIndicatorScrollHalfStyle:
            if (progress >= 0.5) {
               [UIView animateWithDuration:self.indicatorAnimationTime animations:^{
                   switch (self.indicatorLengthStyle) {
                       case WBIndicatorLengthEqualStyle:
                           self.indicatorView.width = targetBtn.width - WB_PageSegmentedViewMargin;
                           break;
                       default:
                           self.indicatorView.width = targetBtn.width;
                           break;
                   }
                   self.indicatorView.centerX = targetBtn.centerX;
               }];
                [self changeSelectedButton:targetBtn];
            }else {
                [UIView animateWithDuration:self.indicatorAnimationTime animations:^{
                    switch (self.indicatorLengthStyle) {
                        case WBIndicatorLengthEqualStyle:
                            self.indicatorView.width = originalBtn.width - WB_PageSegmentedViewMargin;
                            break;
                        default:
                            self.indicatorView.width = originalBtn.width;
                            break;
                    }
                    self.indicatorView.centerX = originalBtn.centerX;
                }];
                [self changeSelectedButton:originalBtn];
            }
            break;
        default:
        {
            if (progress == 1.0) {
                [UIView animateWithDuration:self.indicatorAnimationTime animations:^{
                    switch (self.indicatorLengthStyle) {
                        case WBIndicatorLengthEqualStyle:
                            self.indicatorView.width = targetBtn.width - WB_PageSegmentedViewMargin;
                            break;
                        default:
                            self.indicatorView.width = targetBtn.width;
                            break;
                    }
                    self.indicatorView.centerX = targetBtn.centerX;
                }];
                [self changeSelectedButton:targetBtn];
            }else {
                [UIView animateWithDuration:self.indicatorAnimationTime animations:^{
                    switch (self.indicatorLengthStyle) {
                        case WBIndicatorLengthEqualStyle:
                            self.indicatorView.width = originalBtn.width - WB_PageSegmentedViewMargin;
                            break;
                        default:
                            self.indicatorView.width = originalBtn.width;
                            break;
                    }
                    self.indicatorView.centerX = originalBtn.centerX;
                }];
                [self changeSelectedButton:originalBtn];
            }
        }
            break;
    }
}

- (void)isTitleGradientEffectWithProgress:(CGFloat)progress originalBtn:(UIButton *)originalBtn targetBtn:(UIButton *)targetBtn {
    if (self.titleColorStateSelected) {
        // 获取 targetProgress
        CGFloat targetProgress = progress;
        // 获取 originalProgress
        CGFloat originalProgress = 1 - targetProgress;
        
        CGFloat r = self.endR - self.startR;
        CGFloat g = self.endG - self.startG;
        CGFloat b = self.endB - self.startB;
        UIColor *originalColor = [UIColor colorWithRed:self.startR +  r * originalProgress  green:self.startG +  g * originalProgress  blue:self.startB +  b * originalProgress alpha:1];
        UIColor *targetColor = [UIColor colorWithRed:self.startR + r * targetProgress green:self.startG + g * targetProgress blue:self.startB + b * targetProgress alpha:1];
        
        // 设置文字颜色渐变
        originalBtn.titleLabel.textColor = originalColor;
        targetBtn.titleLabel.textColor = targetColor;
        
    } else {
        originalBtn.titleLabel.textColor = [UIColor colorWithRed:1 - progress green:0 blue:0 alpha:1];
        targetBtn.titleLabel.textColor = [UIColor colorWithRed:progress green:0 blue:0 alpha:1];
    }
}

#pragma mark --------  颜色设置判断  --------
#pragma mark
/**  < 开始颜色设置 >  */
- (void)setupStartColor:(UIColor *)color {
    CGFloat components[3];
    [self getRGBComponents:components forColor:color];
    self.startR = components[0];
    self.startG = components[1];
    self.startB = components[2];
}

/**  < 结束颜色设置 >  */
- (void)setupEndColor:(UIColor *)color {
    CGFloat components[3];
    [self getRGBComponents:components forColor:color];
    self.endR = components[0];
    self.endG = components[1];
    self.endB = components[2];
}

/**
 *  指定颜色，获取颜色的RGB值
 *
 *  @param components RGB数组
 *  @param color      颜色
 */
- (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel, 1, 1, 8, 4, rgbColorSpace, 1);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
}

#pragma mark --------  Getter And Setter  --------
#pragma mark
- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = [NSArray array];
    }
    return _titleArr;
}

- (NSMutableArray *)btnMArr {
    if (!_btnMArr) {
        _btnMArr = @[].mutableCopy;
    }
    return _btnMArr;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.frame = CGRectMake(0, 0, kWB_PageSegmentedView_Width, kWB_PageSegmentedView_Height);
    }
    return _scrollView;
}

- (UIView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [UIView new];
        _indicatorView.backgroundColor = [UIColor redColor];
    }
    return _indicatorView;
}

- (UIView *)bottomSeparator {
    if (!_bottomSeparator) {
        _bottomSeparator = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 0.5, self.width, 0.5)];
        _bottomSeparator.backgroundColor = [UIColor lightGrayColor];
        
    }
    return _bottomSeparator;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    if (selectedIndex) {
        _selectedIndex = selectedIndex;
    }
}

- (void)setIndicatorLengthStyle:(WBIndicatorLengthStyle)indicatorLengthStyle {
    _indicatorLengthStyle = indicatorLengthStyle;
    UIButton *firstButton = self.btnMArr.firstObject;
    if (firstButton == nil) {
        return;
    }
    [self.scrollView addSubview:self.indicatorView];
    CGFloat X = 0;
    CGFloat Y = self.height - self.indicatorHeight;
    CGFloat W = 0;
    CGFloat H = self.indicatorHeight;
    switch (indicatorLengthStyle) {
        case WBIndicatorLengthEqualStyle:
        {
            CGFloat firstBtnTextWidth = [self wb_calculateStringWidthWithString:firstButton.currentTitle font:[UIFont systemFontOfSize:_fontSize]];
            W = firstBtnTextWidth;
            X = 0.5 * (firstButton.width - firstBtnTextWidth);
        }
            break;
        case WBIndicatorLengthSpecialStyle:
        {
            CGFloat firstBtnIndicatorWidth = [self wb_calculateStringWidthWithString:firstButton.currentTitle font:[UIFont systemFontOfSize:_fontSize]] + WB_IndicatorTypeSpecialMultipleLength;
            W = firstBtnIndicatorWidth;
            X = 0.5 * (firstButton.width - firstBtnIndicatorWidth);
        }
            break;
        case WBIndicatorLengthDefaultStyle:
        {
            W = firstButton.width;
            X = firstButton.left;
        }
            break;
        default:
            break;
    }
    _indicatorView.frame = CGRectMake(X, Y, W, H);
}

- (void)setIsNeedBounces:(BOOL)isNeedBounces {
    _isNeedBounces = isNeedBounces;
    if (isNeedBounces == NO) {
        self.scrollView.bounces = NO;
    }
}

- (void)setTitleColorStateNormal:(UIColor *)titleColorStateNormal {
    _titleColorStateNormal = titleColorStateNormal;
    [self.btnMArr enumerateObjectsUsingBlock:^(UIButton * button, NSUInteger idx, BOOL * _Nonnull stop) {
        [button setTitleColor:titleColorStateNormal forState:UIControlStateNormal];
    }];
    [self setupStartColor:titleColorStateNormal];
}

- (void)setTitleColorStateSelected:(UIColor *)titleColorStateSelected {
    _titleColorStateSelected = titleColorStateSelected;
    [self.btnMArr enumerateObjectsUsingBlock:^(UIButton * button, NSUInteger idx, BOOL * _Nonnull stop) {
        [button setTitleColor:titleColorStateSelected forState:UIControlStateSelected];
    }];
    [self setupEndColor:titleColorStateSelected];
}

- (void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorColor = indicatorColor;
    self.indicatorView.backgroundColor = indicatorColor;
}

- (void)setIndicatorHeight:(CGFloat)indicatorHeight {
    _indicatorHeight = indicatorHeight;
    if (indicatorHeight) {
        _indicatorHeight = indicatorHeight;
        self.indicatorView.height = indicatorHeight;
        self.indicatorView.top = self.height - indicatorHeight;
    }
}

- (void)setIndicatorAnimationTime:(CGFloat)indicatorAnimationTime {
    _indicatorAnimationTime = indicatorAnimationTime;
    if (indicatorAnimationTime) {
        if (indicatorAnimationTime >= 0.3) {
            _indicatorAnimationTime = 0.3;
        }else {
            _indicatorAnimationTime = indicatorAnimationTime;
        }
    }
}

- (void)setResetSelectedIndex:(NSInteger)resetSelectedIndex {
    _resetSelectedIndex = resetSelectedIndex;
    [self buttonClicked:self.btnMArr[resetSelectedIndex]];
}

- (void)setIndicatorScrollStyle:(WB_IndicatorScrollStyle)indicatorScrollStyle {
    _indicatorScrollStyle = indicatorScrollStyle;
}

- (void)setIsTitleGradientEffect:(BOOL)isTitleGradientEffect {
    _isTitleGradientEffect = isTitleGradientEffect;
}

- (void)setIsOpenTitleTextZoom:(BOOL)isOpenTitleTextZoom {
    _isOpenTitleTextZoom = isOpenTitleTextZoom;
}

- (void)setTitleTextScaling:(CGFloat)titleTextScaling {
    _titleTextScaling = titleTextScaling;
    if (titleTextScaling) {
        if (titleTextScaling >= 0.3) {
            _titleTextScaling = 0.3;
        }else {
            _titleTextScaling = 0.1;
        }
    }
}

- (void)setIsShowIndicator:(BOOL)isShowIndicator {
    _isShowIndicator = isShowIndicator;
    if (isShowIndicator == NO) {
        [self.indicatorView removeFromSuperview];
        self.indicatorView = nil;
    }
}

- (void)setIsShowBottomSeparator:(BOOL)isShowBottomSeparator {
    _isShowBottomSeparator = isShowBottomSeparator;
    if (isShowBottomSeparator) {
        
    }else {
        [self.bottomSeparator removeFromSuperview];
        self.bottomSeparator = nil;
    }
}

- (void)setFontSize:(CGFloat)fontSize {
    if (_fontSize != fontSize) {
        _fontSize = fontSize;
        /** << 重新布局计算 > */
        [self.titleArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat tempWidth = [self wb_calculateStringWidthWithString:obj font:[UIFont systemFontOfSize:fontSize]];
            self.allBtnTextWidth += tempWidth;
        }];
        /**  < 所有按钮文字宽度 ＋ 按钮之间的间隔 >  */
        self.allBtnWidth = WB_PageSegmentedViewMargin * (self.titleArr.count + 1) + self.allBtnTextWidth;
        self.allBtnWidth = ceilf(self.allBtnWidth);
        if (self.allBtnWidth <= self.width) {
            __block CGFloat btn_x = 0;
            CGFloat btn_y = 0;
            CGFloat btn_w = kWB_PageSegmentedView_Width / self.titleArr.count;
            CGFloat btn_h = kWB_PageSegmentedView_Height - self.indicatorHeight;
            [self.btnMArr enumerateObjectsUsingBlock:^(WBPageSegmentButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
                btn_x = btn_w * idx;
                 button.frame = CGRectMake(btn_x, btn_y, btn_w, btn_h);
                button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
            }];
             self.scrollView.contentSize = CGSizeMake(kWB_PageSegmentedView_Width, 0);
        }else {
            __block CGFloat btn_x = 0;
            CGFloat btn_y = 0;
            CGFloat btn_h = kWB_PageSegmentedView_Height - self.indicatorHeight;
            __block CGFloat btn_w = 0;
            [self.btnMArr enumerateObjectsUsingBlock:^(WBPageSegmentButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
                btn_w = [self wb_calculateStringWidthWithString:button.currentTitle font:[UIFont systemFontOfSize:fontSize]] + WB_PageSegmentedViewMargin;
                button.frame = CGRectMake(btn_x, btn_y, btn_w, btn_h);
                btn_x += btn_w;
                 button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
            }];
            CGFloat contentWidth = CGRectGetMaxX([self.btnMArr.lastObject frame]);
            self.scrollView.contentSize = CGSizeMake(contentWidth, 0);
        }
        [self setIndicatorLengthStyle:self.indicatorLengthStyle];
    }
}


@end
