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
    _font = [UIFont systemFontOfSize:14.f];
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

#pragma mark < Getter >
- (HMSegmentedControl *)segmentControl {
    if (!_segmentControl) {
        _segmentControl = [[HMSegmentedControl alloc]initWithSectionTitles:_titleArray];
        _segmentControl.frame = self.bounds;
        _segmentControl.backgroundColor = [UIColor clearColor];
        _segmentControl.titleTextAttributes = @{NSFontAttributeName : self.font,NSForegroundColorAttributeName: self.normalColor};
        _segmentControl.selectedTitleTextAttributes = @{NSFontAttributeName : self.font,NSForegroundColorAttributeName : self.selectedColor};
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
@end
