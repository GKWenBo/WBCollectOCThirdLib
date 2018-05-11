//
//  WBPageChildVcDelegate.h
//  WBPageController
//
//  Created by wenbo on 2018/5/9.
//  Copyright © 2018年 wenbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WBPageViewController;
@class WBCollectionView;
@class WBSegmentView;

@protocol WBPageViewControllerDelegate <NSObject>

@optional
/**
 有多少个子控制器

 @param pageController 父控制器
 @return 子控制器个数
 */
- (NSInteger)wb_numberChildViewControllrs:(WBPageViewController *)pageController;

/**
 标题数组

 @param pageController 父控制器
 @return 标题数组
 */
- (NSArray <NSString *>*)wb_numberOfTitlesInPageController:(WBPageViewController *)pageController;

/**
 每页对应控制器

 @param pageController 父控制器
 @param index 下标
 @param reuseViewController 重用控制器
 @return 实例化控制器
 */
- (__kindof UIViewController *)wb_pageController:(WBPageViewController *)pageController reuseViewController:(UIViewController *)reuseViewController viewControllerAtIndex:(NSInteger)index;

/**
 控制器视图大小位置

 @param pageController 父控制器
 @param contentView 集合视图
 @return CGRect
 */
- (CGRect)pageController:(WBPageViewController *)pageController preferredFrameForContentView:(WBCollectionView *)contentView;


/**
 分段控件大小位置

 @param pageController 父控制器
 @param menuView 分段控件
 @return CGRect
 */
- (CGRect)pageController:(WBPageViewController *)pageController preferredFrameForMenuView:(WBSegmentView *)menuView;

@end
