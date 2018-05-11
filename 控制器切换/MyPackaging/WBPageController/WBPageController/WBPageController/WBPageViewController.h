//
//  WBPageViewController.h
//  WBPageController
//
//  Created by wenbo on 2018/5/9.
//  Copyright © 2018年 wenbo. All rights reserved.
//

/** <
    分页控制器，继承使用
 >  */

#import <UIKit/UIKit.h>
#import "WBSegmentView.h"
#import "WBPageViewControllerDelegate.h"
#import "UIViewController+WBPageViewController.h"
#import "WBCollectionView.h"

@interface WBPageViewController : UIViewController <WBSegmentViewDelegate,WBPageViewControllerDelegate>

/** < 属性代理 >  */
@property (nonatomic, weak) id <WBPageViewControllerDelegate> delegate;
/** < 分段控件 >  */
@property (nonatomic, strong) WBSegmentView *segementView;
/** < 控制器容器视图 >  */
@property (nonatomic, strong, readonly) WBCollectionView *collectionView;

/** < 当前控制器 >  */
@property (nonatomic, strong, readonly) UIViewController *currentChildVc;
/** < 是否显示在导航栏 默认：NO >  */
@property (nonatomic, assign) BOOL showOnNavigationBar;
/** < 选中下标 default: 0 >  */
@property (nonatomic, assign) NSInteger selectedIndex;
/** < Title color, defaulut: grayColor>  */
@property (nonatomic, strong) UIColor *titleNormalColor;
/** < Title selected color, default: blackColor >  */
@property (nonatomic, strong) UIColor *titleSelectedColor;
/** < Title font, default: 14pt>  */
@property (nonatomic, strong) UIFont *titleNormalFont;
/** < Title selected font, default: 14pt>  */
@property (nonatomic, strong) UIFont *titleSelectedFont;

/** 给外界 重新加载内容的方法 */
- (void)reload;

@end
