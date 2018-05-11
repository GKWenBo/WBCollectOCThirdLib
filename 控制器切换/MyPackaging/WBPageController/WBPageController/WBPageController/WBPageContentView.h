//
//  WBPageContentView.h
//  WBPageController
//
//  Created by wenbo on 2018/5/10.
//  Copyright © 2018年 wenbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+WBPageViewController.h"

@class WBPageContentView;

@protocol WBPageContentViewDelegate <NSObject>

- (NSInteger)numberOfChildViewControllers:(WBPageContentView *)pageContentView;

- (__kindof UIViewController *)pageContentView:(WBPageContentView *)pageContentView reuseViewController:(UIViewController *)reuseViewController viewControllerAtIndex:(NSInteger)index;

- (void)pageContentView:(WBPageContentView *)pageContentView didScrollToIndex:(NSInteger)index;

@end

@interface WBPageContentView : UIView

/** < 代理属性 >  */
@property (nonatomic, assign) id <WBPageContentViewDelegate> delegate;
/** < 当前控制器 >  */
@property (nonatomic, strong, readonly) UIViewController *currentChildVc;
/** < 选中控制器下标 >  */
@property (nonatomic, assign) NSInteger selectedIndex;
/** < 是否需要弹簧效果 默认：NO >  */
@property (nonatomic, assign) BOOL isNeedBounce;

/**
 初始化方法

 @param frame 位置大小
 @param parentViewController 父控制器
 @param delegate 代理
 @return WBPageContentView
 */
- (instancetype)initWithFrame:(CGRect)frame
         parentViewController:(UIViewController *)parentViewController
                     delegate:(id<WBPageContentViewDelegate>)delegate;

/** 给外界 重新加载内容的方法 */
- (void)reload;
/** < 给外界选中下标方法 >  */
- (void)setContentOffSet:(CGPoint)offset animated:(BOOL)animated;

@end
