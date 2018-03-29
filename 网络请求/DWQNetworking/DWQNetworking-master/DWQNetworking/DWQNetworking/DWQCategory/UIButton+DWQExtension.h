//
//  UIButton+DWQExtension.h
//  DWQTools
//
//  Created by 杜文全 on 16/9/28.
//  Copyright © 2016年 杜文全. All rights reserved.
//  杜文全版权所有》--->如果问题请联系 439878592@qq.com 

#import <UIKit/UIKit.h>

@interface UIButton (DWQExtension)

/**
 * 设置普通状态与高亮状态的背景图片
 */
- (void)dwq_setN_BG:(NSString *)nbg H_BG:(NSString *)hbg;

/**
 * 设置普通状态与高亮状态的拉伸后背景图片
 */
- (void)dwq_setResizeN_BG:(NSString *)nbg H_BG:(NSString *)hbg;

/**
 * 设置普通状态与高亮状态的文字
 */
- (void)dwq_setNormalTitleColor:(UIColor *)nColor Higblighted:(UIColor *)hColor;
/*
 
 
 */


@end
