//
//  UIViewController+WBPageViewController.m
//  WBPageController
//
//  Created by wenbo on 2018/5/9.
//  Copyright © 2018年 wenbo. All rights reserved.
//

#import "UIViewController+WBPageViewController.h"
//#import "WBPageViewControllerDelegate.h"
#import <objc/runtime.h>

static void *WBCurrentIndexKey = &WBCurrentIndexKey;

@implementation UIViewController (WBPageViewController)

//- (UIViewController *)wb_pageViewController {
//    UIViewController *controller = self;
//    while (controller) {
//        if ([controller conformsToProtocol:@protocol(WBPageChildVcDelegate)]) {
//            break;
//        }
//        controller = controller.parentViewController;
//    }
//    return controller;
//}

- (void)setWb_currentIndex:(NSInteger)wb_currentIndex {
    objc_setAssociatedObject(self, WBCurrentIndexKey, [NSNumber numberWithInteger:wb_currentIndex], OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)wb_currentIndex {
    return [objc_getAssociatedObject(self, WBCurrentIndexKey) integerValue];
}

@end
