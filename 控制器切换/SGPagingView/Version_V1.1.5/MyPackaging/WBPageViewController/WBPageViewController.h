//
//  WB_PageViewController.h
//  WB_PageViewControllerDemo1
//
//  Created by WMB on 2017/8/13.
//  Copyright © 2017年 文波. All rights reserved.
//

/**  < 控制器分页控件封装 >  */

#import <UIKit/UIKit.h>
#import "WBPageContentView.h"
#import "WBPageSegmentedView.h"

typedef NS_ENUM(NSInteger,WBSegmentPositonStyle) {
    WBSegmentPositonNavigationBarStyle,    /**  < 位置在导航栏 >  */
    WBSegmentPositonSubViewStyle           /**  < 在子视图 >  */
};

@interface WBPageViewController : UIViewController
/**  < 控制器容器视图 >  */
@property (nonatomic, strong) WBPageContentView *pageContentView;
/**  < 自定义分段控件 >  */
@property (nonatomic, strong) WBPageSegmentedView *segmentedView;

/**
 对象初始化方法

 @param childVcs 子控制器数组
 @param titleArray 标题数组
 @return WB_PageViewController
 */
- (instancetype)initWithChildVcs:(NSArray *)childVcs titleArray:(NSArray *)titleArray positionStyle:(WBSegmentPositonStyle)positionStyle;

/**
 类初始化方法

 @param childVcs 子控制器数组
 @param titleArray 标题数组
 @return WB_PageViewController
 */
+ (instancetype)pageViewControllerWithChildVcs:(NSArray *)childVcs titleArray:(NSArray <NSString *>*)titleArray positionStyle:(WBSegmentPositonStyle)positionStyle;


@end
