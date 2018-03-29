//
//  WBPagesReuseSegmentView.m
//  WBPagesManagerController
//
//  Created by WMB on 2017/3/27.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "WBPagesReuseSegmentView.h"

#import "Masonry.h"
#define Font(s) [UIFont systemFontOfSize:s]
@interface WBPagesReuseSegmentView ()
{
    NSArray * _titleArray;/**  控制器标题  */
}
@end

@implementation WBPagesReuseSegmentView

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray {
    
    self = [super initWithFrame:frame];
    if (self) {
        NSAssert(titleArray.count > 0, @"分段控件标题不能为空");
        _titleArray = titleArray;
        
        [self addSubview:self.segmentControl];
        
        [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return self;
}

#pragma mark -- getter and setter
#pragma mark
- (HMSegmentedControl *)segmentControl {
    if (!_segmentControl) {
        _segmentControl = [[HMSegmentedControl alloc]initWithSectionTitles:_titleArray];
        _segmentControl.backgroundColor = [UIColor clearColor];
        _segmentControl.selectedSegmentIndex = 0;/**  默认选中  */
        _segmentControl.titleTextAttributes = @{NSFontAttributeName : Font(14.f),NSForegroundColorAttributeName : [UIColor blackColor]};/**  未选中样式  */
        _segmentControl.selectedTitleTextAttributes = @{NSFontAttributeName : Font(14.f),NSForegroundColorAttributeName : [UIColor redColor]};/**  选中样式  */
        _segmentControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        _segmentControl.selectionIndicatorColor = [UIColor redColor];
        _segmentControl.selectionIndicatorHeight = 1.f;
        _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
        _segmentControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, - 2.f, 0);
    }
    return _segmentControl;
}

- (void)setUnSelectedColor:(UIColor *)unSelectedColor {
    _unSelectedColor = unSelectedColor;
     self.segmentControl.titleTextAttributes = @{NSForegroundColorAttributeName : unSelectedColor};/**  未选中样式  */
}
- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    self.segmentControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : selectedColor};/**  选中样式  */
}
- (void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
    self.segmentControl.titleTextAttributes = @{NSFontAttributeName : Font(fontSize)};/**  未选中样式  */
    self.segmentControl.selectedTitleTextAttributes = @{NSFontAttributeName : Font(fontSize)};/**  选中样式  */
}
- (void)setHaveIndicator:(BOOL)haveIndicator {
    _haveIndicator = haveIndicator;
    if (haveIndicator) {
        self.segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    }else {
        self.segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    }
}

@end
