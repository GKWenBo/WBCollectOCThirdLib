//
//  WBPageChildVcDelegate.h
//  WBPageController
//
//  Created by wenbo on 2018/5/9.
//  Copyright © 2018年 wenbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WBPageChildVcDelegate <NSObject>

@optional

/**
 * 请注意: 如果你希望所有的子控制器的view的系统生命周期方法被正确的调用
 * 请重写父控制器的'shouldAutomaticallyForwardAppearanceMethods'方法 并且返回NO
 * 当然如果你不做这个操作, 子控制器的生命周期方法将不会被正确的调用
 * 如果你仍然想利用子控制器的生命周期方法, 请使用'ZJScrollPageViewChildVcDelegate'提供的代理方法
 * 或者'ZJScrollPageViewDelegate'提供的代理方法
 */
- (void)wb_viewWillAppearForIndex:(NSInteger)index;
- (void)wb_viewDidAppearForIndex:(NSInteger)index;
- (void)wb_viewWillDisappearForIndex:(NSInteger)index;
- (void)wb_viewDidDisappearForIndex:(NSInteger)index;

- (void)wb_viewDidLoadForIndex:(NSInteger)index;


@end
