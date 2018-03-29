//
//  WBPagesReuseSegmentView.h
//  WBPagesManagerController
//
//  Created by WMB on 2017/3/27.
//  Copyright © 2017年 文波. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HMSegmentedControl.h"
@interface WBPagesReuseSegmentView : UIView

@property (nonatomic,strong) HMSegmentedControl * segmentControl;

@property (nonatomic,strong) UIColor * unSelectedColor;/**  未选中颜色 默认黑色  */
@property (nonatomic,strong) UIColor * selectedColor;/**  选中颜色 默认红色  */
@property (nonatomic,assign) CGFloat fontSize;/**  字体大小  */
@property (nonatomic,assign) BOOL haveIndicator;/**  默认有  */



- (instancetype)initWithFrame:(CGRect)frame
                   titleArray:(NSArray *)titleArray;


@end
