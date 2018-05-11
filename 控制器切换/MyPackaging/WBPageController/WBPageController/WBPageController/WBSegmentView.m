//
//  WBSegmentView.m
//  WBPageController
//
//  Created by wenbo on 2018/5/9.
//  Copyright © 2018年 wenbo. All rights reserved.
//

#import "WBSegmentView.h"

@interface WBSegmentView ()
{
    NSArray *_titleArray;
}
@end

@implementation WBSegmentView

#pragma mark < 初始化 >
- (instancetype)initWithFrame:(CGRect)frame
                   titleArray:(NSArray<NSString *>*)titleArray {
    if (self = [super initWithFrame:frame]) {
        _titleArray = titleArray;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _normalFont = [UIFont systemFontOfSize:14.f];
    _selectedFont = [UIFont systemFontOfSize:14.f];
    _normalColor = [UIColor blackColor];
    _selectedColor = [UIColor  orangeColor];
    _selectionIndicatorHeight = 2.f;
    _selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    _segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    [self addSubview:self.segmentControl];
}

#pragma mark < Public Method >
- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated {
    [self.segmentControl setSelectedSegmentIndex:index animated:animated];
}

- (void)wb_resetFrame:(CGRect)frame {
    self.segmentControl.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

#pragma mark < Getter >
- (HMSegmentedControl *)segmentControl {
    if (!_segmentControl) {
        _segmentControl = [[HMSegmentedControl alloc]initWithSectionTitles:_titleArray];
        _segmentControl.frame = self.bounds;
        _segmentControl.backgroundColor = [UIColor clearColor];
        _segmentControl.titleTextAttributes = @{NSFontAttributeName : self.normalFont,NSForegroundColorAttributeName: self.normalColor};
        _segmentControl.selectedTitleTextAttributes = @{NSFontAttributeName : self.normalFont,NSForegroundColorAttributeName : self.selectedColor};
        _segmentControl.selectionIndicatorColor = self.selectedColor;
        _segmentControl.selectionStyle = self.selectionStyle;
        _segmentControl.selectionIndicatorHeight = self.selectionIndicatorHeight;
        _segmentControl.selectionIndicatorLocation = self.selectionIndicatorLocation;
        _segmentControl.segmentWidthStyle = self.segmentWidthStyle;
        [_segmentControl addTarget:self action:@selector(selectedIndexChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentControl;
}

#pragma mark < Event Response >
- (void)selectedIndexChanged:(HMSegmentedControl *)segmentControl {
    if (_delegate && [_delegate respondsToSelector:@selector(wbSegmentView:didSelectedIndex:)]) {
        [_delegate wbSegmentView:self didSelectedIndex:segmentControl.selectedSegmentIndex];
    }
}

- (void)setNormalFont:(UIFont *)normalFont {
    _normalFont = normalFont;
    self.segmentControl.titleTextAttributes = @{NSFontAttributeName : normalFont};
}

- (void)setSelectedFont:(UIFont *)selectedFont {
    _selectedFont = selectedFont;
    self.segmentControl.selectedTitleTextAttributes = @{NSFontAttributeName : selectedFont};
}

- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    self.segmentControl.titleTextAttributes = @{NSForegroundColorAttributeName : normalColor};
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    self.segmentControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : selectedColor};
}

- (void)setSelectionIndicatorHeight:(CGFloat)selectionIndicatorHeight {
    _selectionIndicatorHeight = selectionIndicatorHeight;
    self.segmentControl.selectionIndicatorHeight = selectionIndicatorHeight;
}

- (void)setSelectionIndicatorLocation:(HMSegmentedControlSelectionIndicatorLocation)selectionIndicatorLocation {
    _selectionIndicatorLocation = selectionIndicatorLocation;
    self.segmentControl.selectionIndicatorLocation = selectionIndicatorLocation;
}

- (void)setSelectionStyle:(HMSegmentedControlSelectionStyle)selectionStyle {
    _selectionStyle = selectionStyle;
    self.segmentControl.selectionStyle = selectionStyle;
}

- (void)setSegmentWidthStyle:(HMSegmentedControlSegmentWidthStyle)segmentWidthStyle {
    _segmentWidthStyle = segmentWidthStyle;
    self.segmentControl.segmentWidthStyle = segmentWidthStyle;
}

@end
