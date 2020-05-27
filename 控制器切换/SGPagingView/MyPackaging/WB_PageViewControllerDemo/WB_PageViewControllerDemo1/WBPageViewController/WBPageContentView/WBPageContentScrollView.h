//
//  WB_PageContentScrollView.h
//  WB_PageViewControllerDemo1
//
//  Created by WMB on 2017/8/13.
//  Copyright © 2017年 文波. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WBPageContentScrollView;
@protocol WBPageContentScrollViewDelegate <NSObject>

- (void)pageContentScrollView:(WBPageContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex;

@end

@interface WBPageContentScrollView : UIView

/**
 类方法创建 WB_PageContentView
 
 @param frame 位置大小
 @param parentVc 父控制器
 @param childVcs 子控制器
 @return WB_PageContentView
 */
- (instancetype)initWithFrame:(CGRect)frame parentVc:(UIViewController *)parentVc childVcs:(NSArray *)childVcs;

/**
 *  类方法创建 SGPageContentScrollView
 *
 *  @param frame     frame
 *  @param parentVC     当前控制器
 *  @param childVCs     子控制器个数
 */
+ (instancetype)pageContentScrollViewWithFrame:(CGRect)frame parentVC:(UIViewController *)parentVC childVCs:(NSArray *)childVCs;
@property (nonatomic,assign) id <WBPageContentScrollViewDelegate> delegate;

/**  < 是否需要滚动 SGPageContentScrollView 默认为 YES；设为 NO 时，不用设置 SGPageContentScrollView 的代理及代理方法 >  */
@property (nonatomic, assign) BOOL isScrollEnabled;

/**  < 给外界提供的方法，获取 SGPageTitleView 选中按钮的下标, 必须实现 >  */
- (void)setPageCententScrollViewCurrentIndex:(NSInteger)currentIndex;

@end
