//
//  UITextField+DWQExtension.h
//  DWQTools
//
//  Created by 杜文全 on 16/9/28.
//  Copyright © 2016年 杜文全. All rights reserved.
//  杜文全版权所有》--->如果问题请联系 439878592@qq.com

#import <UIKit/UIKit.h>

@interface UITextField (DWQExtension)

/**
 *  添加TextFiled的左边视图(图片)
 */
- (void)dwq_addLeftViewWithImage:(NSString *)image;

/**
 *  获取选中光标位置
 *
 *  @return 返回NSRange
 */
- (NSRange)dwq_selectedRange;

/**
 *  设置光标位置
 */
- (void)dwq_setSelectedRange:(NSRange)range;

@end
