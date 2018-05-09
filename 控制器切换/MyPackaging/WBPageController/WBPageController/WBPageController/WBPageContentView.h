//
//  WBScrollPageView.h
//  WBPageController
//
//  Created by wenbo on 2018/5/9.
//  Copyright © 2018年 wenbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBCollectionView.h"
#import "UIViewController+WBPageViewController.h"
#import "WBPageChildVcDelegate.h"

@class WBPageContentView;

@protocol WBPageContentViewDelegate <NSObject>

/**
 内容视图滚动回调

 @param wbPageContentView WBPageContentView
 @param currentIndex 当前前下标
 */
- (void)wbPageContentView:(WBPageContentView *)wbPageContentView didScrollToCurrentIndex:(NSInteger)currentIndex;

@end

@interface WBPageContentView : UIView

/** < 属性代理 >  */
@property (nonatomic, assign) id <WBPageContentViewDelegate> delegate;
/** < 控制器容器视图 >  */
@property (nonatomic, strong, readonly) WBCollectionView *collectionView;
/** < 当前控制器 >  */
@property (nonatomic, strong, readonly) UIViewController <WBPageChildVcDelegate> *currentChildVc;

/**
 初始化方法

 @param frame 坐标位置
 @param parentViewController 父控制器
 @param childVcs 子控制器数组
 @return WBPageContentView
 */
- (instancetype)initWithFrame:(CGRect)frame
         parentViewController:(UIViewController *)parentViewController
                     childVcs:(NSArray <UIViewController<WBPageChildVcDelegate> *>*)childVcs;

/** 给外界可以设置ContentOffSet的方法 */
- (void)setContentOffSet:(CGPoint)offset
                animated:(BOOL)animated;
/** 给外界 重新加载内容的方法 */
- (void)reload;

@end
