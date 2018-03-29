//
//  WB_PageViewController.h
//  WB_PageViewController
//
//  Created by WMB on 2017/8/12.
//  Copyright © 2017年 文波. All rights reserved.
//

/**  < 分页控制器 子类继承使用 >  */

#import <UIKit/UIKit.h>
#import "WBReuseSegmentedView.h"

typedef NS_ENUM(NSInteger,WBSegmentLocationStyle) {
    WBSegmentLocationNavigationBarStyle, /**  < 分段控件位置导航栏 >  */
    WBSegmentLocationSubViewStyle /**  < 子视图 >  */
};

@interface WBPageViewController : UIViewController <WBReuseSegmentedViewDelegate>

/**  < 分段控件 >  */
@property (nonatomic,strong) WBReuseSegmentedView * segmentView;
/**  < 主滚动视图 >  */
@property (nonatomic,strong) UIScrollView * mainScrollView;
/**  < 当前显示的vc >  */
@property (nonatomic,strong,readonly) UIViewController * currentDisplayController;
/**  < 当前下标 >  */
@property (nonatomic,assign,readonly) NSInteger currentIndex;
/**  < 所有子控制器 >  */
@property (nonatomic,strong) NSArray * childViewControllers;
/**  < 标题 >  */
@property (nonatomic,strong) NSArray * titleArray;
/**  < 分段控件位置 默认WB_SegmentLocationSubViewStyle >  */
@property (nonatomic,assign) WBSegmentLocationStyle segmentLocation;
/**  < 分段控件高度 默认40.f >  */
@property (nonatomic,assign) CGFloat segmentHeight;
/**  < 是否可拖动 默认YES>  */
@property (nonatomic,assign) BOOL srollEnabled;

/**  < 配置数据 titleArray、childViewControllers 在这个方法 >  */
- (void)initializeDataSource;
/**  < 设置界面 配置高度样式 >  */
- (void)initializeUserInterface;

@end
