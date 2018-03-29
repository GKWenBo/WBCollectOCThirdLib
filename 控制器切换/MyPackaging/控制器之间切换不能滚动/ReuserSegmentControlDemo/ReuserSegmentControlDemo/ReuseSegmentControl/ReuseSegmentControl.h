//
//  ReuseSegmentControl.h
//  ReuserSegmentControlDemo
//
//  Created by Admin on 2017/2/15.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "Masonry.h"
@interface ReuseSegmentControl : UIView

@property (nonatomic,strong) HMSegmentedControl * segmentControl;

- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titles;

@end
