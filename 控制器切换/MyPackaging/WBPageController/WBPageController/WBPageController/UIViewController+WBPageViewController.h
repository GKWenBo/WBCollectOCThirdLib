//
//  UIViewController+WBPageViewController.h
//  WBPageController
//
//  Created by wenbo on 2018/5/9.
//  Copyright © 2018年 wenbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (WBPageViewController)

///** < 所有子控制的父控制器, 方便在每个子控制页面直接获取到父控制器进行其他操作 >  */
//@property (nonatomic, weak, readonly) UIViewController *wb_pageViewController;
@property (nonatomic, assign) NSInteger wb_currentIndex;


@end
