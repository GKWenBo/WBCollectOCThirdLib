//
//  WB_ReuseSegmentedView.m
//  HMSegmentedControl封装
//
//  Created by WMB on 2017/8/12.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "WBReuseSegmentedView.h"

@interface WBReuseSegmentedView ()
{
    NSArray <NSString *>*_titleArray;
    NSArray <UIImage *>*_imageNormalArray;
    NSArray <UIImage *>*_selectedImageArray;
    HMSegmentedControlType type;
}
@end

@implementation WBReuseSegmentedView

#pragma mark --------  初始化  --------
#pragma mark
- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray<NSString *>*)titleArray {
    self = [super initWithFrame:frame];
    if (self) {
        NSAssert(titleArray.count > 0, @"标题个数要大于0");
        type = HMSegmentedControlTypeText;
        _titleArray = titleArray;
        [self defaultConfig];
        [self addSubview:self.segmentedControl];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame imageNormalArray:(NSArray<UIImage *>*)imageNormalArray selectedImageArray:(NSArray <UIImage *> *)selectedImageArray {
    self = [super initWithFrame:frame];
    if (self) {
        NSAssert(imageNormalArray.count > 0, @"图片数组个数要大于0");
        NSAssert(imageNormalArray.count == selectedImageArray.count, @"图片张数不相等");
        type = HMSegmentedControlTypeImages;
        _imageNormalArray = imageNormalArray;
        _selectedImageArray = selectedImageArray;
        [self defaultConfig];
        [self addSubview:self.segmentedControl];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame imageNormalArray:(NSArray<UIImage *>*)imageNormalArray selectedImageArray:(NSArray <UIImage *> *)selectedImageArray titleArray:(NSArray<NSString *>*)titleArray {
    self = [super initWithFrame:frame];
    if (self) {
        NSAssert(titleArray.count > 0, @"标题个数要大于0");
        NSAssert(imageNormalArray.count > 0, @"图片数组个数要大于0");
        NSAssert(selectedImageArray.count == imageNormalArray.count, @"图片张数不相等");
        NSAssert(selectedImageArray.count == titleArray.count, @"图片张数标题个数不相等");
        type = HMSegmentedControlTypeTextImages;
        _imageNormalArray = imageNormalArray;
        _selectedImageArray = selectedImageArray;
        _titleArray = titleArray;
        [self defaultConfig];
        [self addSubview:self.segmentedControl];
    }
    return self;
}

#pragma mark --------  Default Config  --------
#pragma mark
- (void)defaultConfig {
    self.backgroundColor = [UIColor clearColor];
    _font = [UIFont systemFontOfSize:14.f];
    _normalColor = [UIColor whiteColor];
    _selectedColor = [UIColor  whiteColor];
    _selectionIndicatorHeight = 2.f;
    _selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    _segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    _segmentEdgeInset = UIEdgeInsetsMake(0, 5, 0, 5);
    _userDraggable = NO;
}

#pragma mark --------  selectedIndexChanged  --------
#pragma mark
- (void)selectedIndexChanged:(HMSegmentedControl *)segmentControl {
    if (_delegate && [_delegate respondsToSelector:@selector(wb_reuseSegmentedView:selectedIndex:)]) {
        [_delegate wb_reuseSegmentedView:self selectedIndex:segmentControl.selectedSegmentIndex];
    }
}

#pragma mark --------  getter and setter  --------
#pragma mark
- (HMSegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        switch (type) {
            case HMSegmentedControlTypeText:
                /**  < 纯文字 >  */
                _segmentedControl = [[HMSegmentedControl alloc]initWithSectionTitles:_titleArray];
                break;
            case HMSegmentedControlTypeImages:
                /**  < 纯图片 >  */
                _segmentedControl = [[HMSegmentedControl alloc]initWithSectionImages:_imageNormalArray sectionSelectedImages:_selectedImageArray];
                break;
            case HMSegmentedControlTypeTextImages:
                _segmentedControl = [[HMSegmentedControl alloc]initWithSectionImages:_imageNormalArray sectionSelectedImages:_selectedImageArray titlesForSections:_titleArray];
                break;
            default:
                break;
        }
        _segmentedControl.frame = self.bounds;
        _segmentedControl.backgroundColor = [UIColor clearColor];
        _segmentedControl.titleTextAttributes = @{NSFontAttributeName : self.font,NSForegroundColorAttributeName: self.normalColor};
        _segmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName : self.font,NSForegroundColorAttributeName : self.selectedColor};
        _segmentedControl.selectionIndicatorColor = self.selectedColor;
        _segmentedControl.selectionStyle = self.selectionStyle;
        _segmentedControl.selectionIndicatorHeight = self.selectionIndicatorHeight;
        _segmentedControl.selectionIndicatorLocation = self.selectionIndicatorLocation;
        _segmentedControl.segmentWidthStyle = self.segmentWidthStyle;
        _segmentedControl.segmentEdgeInset  = self.segmentEdgeInset;
        _segmentedControl.userDraggable = self.userDraggable;
        [_segmentedControl addTarget:self action:@selector(selectedIndexChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.segmentedControl.titleTextAttributes = @{NSFontAttributeName : font,NSForegroundColorAttributeName: self.normalColor};
    self.segmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName : font,NSForegroundColorAttributeName : self.selectedColor};
}

- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    self.segmentedControl.titleTextAttributes = @{NSFontAttributeName : self.font,NSForegroundColorAttributeName: normalColor};
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    self.segmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName : self.font,NSForegroundColorAttributeName : selectedColor};
    self.segmentedControl.selectionIndicatorColor = selectedColor;
}


- (void)setSelectionIndicatorHeight:(CGFloat)selectionIndicatorHeight {
    _selectionIndicatorHeight = selectionIndicatorHeight;
    self.segmentedControl.selectionIndicatorHeight = selectionIndicatorHeight;
}

- (void)setSegmentWidthStyle:(HMSegmentedControlSegmentWidthStyle)segmentWidthStyle {
    _segmentWidthStyle = segmentWidthStyle;
    self.segmentedControl.segmentWidthStyle = segmentWidthStyle;
}

- (void)setSelectionIndicatorLocation:(HMSegmentedControlSelectionIndicatorLocation)selectionIndicatorLocation {
    _selectionIndicatorLocation = selectionIndicatorLocation;
    self.segmentedControl.selectionIndicatorLocation = selectionIndicatorLocation;
}

- (void)setSelectionStyle:(HMSegmentedControlSelectionStyle)selectionStyle {
    _selectionStyle = selectionStyle;
    self.segmentedControl.selectionStyle = selectionStyle;
}

- (void)setSegmentEdgeInset:(UIEdgeInsets)segmentEdgeInset {
    _segmentEdgeInset = segmentEdgeInset;
    self.segmentedControl.segmentEdgeInset = segmentEdgeInset;
}

- (void)setUserDraggable:(BOOL)userDraggable {
    _userDraggable = userDraggable;
    self.segmentedControl.userDraggable = userDraggable;
}

@end
