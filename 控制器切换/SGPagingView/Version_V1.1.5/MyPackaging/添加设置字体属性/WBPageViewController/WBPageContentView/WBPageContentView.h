//
//  WB_PageContentView.h
//  WB_PageViewControllerDemo1
//
//  Created by WMB on 2017/8/13.
//  Copyright © 2017年 文波. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WBPageContentView;
@protocol WB_PageContentViewDelegate <NSObject>

- (void)pageContentView:(WBPageContentView *)pageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex;

@end
@interface WBPageContentView : UIView


/**
 对象方法创建 WB_PageContentView

 @param frame 位置大小
 @param parentVc 父控制器
 @param childVcs 子控制器
 @return WB_PageContentView
 */
- (instancetype)initWithFrame:(CGRect)frame parentVc:(UIViewController *)parentVc childVcs:(NSArray *)childVcs;

/**
 类方法创建 WB_PageContentView

 @param frame 位置大小
 @param parentVc 父控制器
 @param childVcs 子控制器
 @return WB_PageContentView
 */
+ (instancetype)pageContentViewWithFrame:(CGRect)frame parentVc:(UIViewController *)parentVc childVcs:(NSArray *)childVcs;

@property (nonatomic,assign) id <WB_PageContentViewDelegate> delegate;
/**  < 是否需要滚动 SGPageContentView 默认为 YES；设为 NO 时，不必设置 SGPageContentView 的代理及代理方法 >  */
@property (nonatomic,assign) BOOL isScrollEnabled;
/**  < 给外界提供的方法，获取 SGPageTitleView 选中按钮的下标, 必须实现 >  */
- (void)setPageCententViewCurrentIndex:(NSInteger)currentIndex;
@end
