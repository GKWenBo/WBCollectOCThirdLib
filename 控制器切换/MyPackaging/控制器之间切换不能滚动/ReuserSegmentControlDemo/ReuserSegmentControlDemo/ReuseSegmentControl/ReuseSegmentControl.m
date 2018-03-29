//
//  ReuseSegmentControl.m
//  ReuserSegmentControlDemo
//
//  Created by Admin on 2017/2/15.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "ReuseSegmentControl.h"

@interface ReuseSegmentControl ()
{
    NSArray * titleArr;
}
@end

@implementation ReuseSegmentControl

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles {
    self = [super initWithFrame:frame];
    if (self) {
        NSAssert(titles.count > 0, @"segment titles 不能为空");
    }
    self.backgroundColor = [UIColor orangeColor];
    

    titleArr = titles;
    [self setSegmentView];
    
    return self;
}

- (void)setSegmentView {
    _segmentControl = [[HMSegmentedControl alloc] initWithSectionTitles:titleArr];
    _segmentControl.backgroundColor = [UIColor clearColor];
    _segmentControl.selectedSegmentIndex = 0;
    _segmentControl.selectedTitleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:12], NSForegroundColorAttributeName : [UIColor whiteColor]};
    _segmentControl.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:12], NSForegroundColorAttributeName : [UIColor whiteColor]};
    _segmentControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    _segmentControl.selectionIndicatorColor = [UIColor whiteColor];
    _segmentControl.selectionIndicatorHeight = 1;
    _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    _segmentControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, -3, 0);
    [self addSubview:_segmentControl];
    
    [_segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];

}

@end
