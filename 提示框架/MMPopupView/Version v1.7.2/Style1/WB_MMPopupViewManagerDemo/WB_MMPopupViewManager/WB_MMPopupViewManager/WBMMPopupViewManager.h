//
//  WB_MMPopupViewManager.h
//  WB_MMPopupViewManager
//
//  Created by WMB on 2017/6/11.
//  Copyright © 2017年 文波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMPopupView.h"
#import "MMAlertView.h"
#import "MMSheetView.h"

@interface WBMMPopupViewManager : NSObject

+ (void)wb_defaultConfig;

#pragma mark --------  基础方法  --------
#pragma mark
/**
 *  一个按钮提示框
 *
 *  @param title 标题
 *  @param message 详情信息
 *  @param actionTitle 按钮标题
 *  @param blurEffectStyle 模糊效果
 *  @param itemHandlerBlock 点击回调
 */
+ (void)wb_showOneActionAlertViewWithTitle:(NSString *)title
                                   message:(NSString *)message
                               actionTitle:(NSString *)actionTitle
                           blurEffectStyle:(UIBlurEffectStyle)blurEffectStyle
                          itemHandlerBlock:(MMPopupItemHandler)itemHandlerBlock;
/**
 *  两个按钮提示框
 *
 *  @param title 标题
 *  @param message 详情文字
 *  @param leftTitle 左边按钮标题
 *  @param rightTitle 右边边按钮标题
 *  @param blurEffectStyle 模糊效果
*  @param itemHandlerBlock 点击下标回调
 */
+ (void)wb_showTwoActionAlertViewWithTitle:(NSString *)title
                                   message:(NSString *)message
                                 leftTitle:(NSString *)leftTitle
                                rightTitle:(NSString *)rightTitle
                           blurEffectStyle:(UIBlurEffectStyle)blurEffectStyle
                          itemHandlerBlock:(MMPopupItemHandler)itemHandlerBlock;
/**
 *  中间多个按钮
 *
 *  @param title 标题
 *  @param message 详情文字
 *  @param actionTitles 按钮标题数组
 *  @param actionStyles 对应按钮样式数组
 *  @param blurEffectStyle 模糊效果
 *  @param itemHandlerBlock 点击下标回调
 */
+ (void)wb_showAlertViewWithTitle:(NSString *)title
                          message:(NSString *)message
                     actionTitles:(NSArray <NSString *> *)actionTitles
                     actionStyles:(NSArray <NSNumber *> *)actionStyles
                  blurEffectStyle:(UIBlurEffectStyle)blurEffectStyle
                 itemHandlerBlock:(MMPopupItemHandler)itemHandlerBlock;

/**
 *  底部弹出多个按钮
 *
 *  @param title 标题
 *  @param actionTitles 按钮标题数组
 *  @param actionStyles 对应按钮样式数组
 *  @param blurEffectStyle 模糊效果
 *  @param itemHandlerBlock 点击下标回调
 */
+ (void)wb_showActionSheetWithTitle:(NSString *)title
                       actionTitles:(NSArray <NSString *> *)actionTitles
                       actionStyles:(NSArray <NSNumber *> *)actionStyles
                    blurEffectStyle:(UIBlurEffectStyle)blurEffectStyle
                   itemHandlerBlock:(MMPopupItemHandler)itemHandlerBlock;


#pragma mark --------  常用方法  --------
#pragma mark
/**
 *  一个按钮
 *
 *  @param title 标题
 *  @param message 详情提示信息
 *  @param itemHandlerBlock 小标点击回调
 */
+ (void)wb_showOneActionAlertViewWithTitle:(NSString *)title
                                   message:(NSString *)message
                          itemHandlerBlock:(MMPopupItemHandler)itemHandlerBlock;
/**
 *  两个按钮
 *
 *  @param title 标题
 *  @param message 详情提示信息
 *  @param itemHandlerBlock 小标点击回调
 */
+ (void)wb_showTwoActionAlertViewWithTitle:(NSString *)title
                                   message:(NSString *)message
                          itemHandlerBlock:(MMPopupItemHandler)itemHandlerBlock;
/**
 *  中间多个按钮
 *
 *  @param title 标题
 *  @param message 详情文字
 *  @param actionTitles 按钮标题数组
 *  @param actionStyles 对应按钮样式数组
 *  @param itemHandlerBlock 点击下标回调
 */
+ (void)wb_showAlertViewWithTitle:(NSString *)title
                       message:(NSString *)message
                  actionTitles:(NSArray <NSString *> *)actionTitles
                  actionStyles:(NSArray <NSNumber *> *)actionStyles
              itemHandlerBlock:(MMPopupItemHandler)itemHandlerBlock;
/**
 *  底部弹出多个按钮
 *
 *  @param title 标题
 *  @param actionTitles 按钮标题数组
 *  @param actionStyles 对应按钮样式数组
 *  @param itemHandlerBlock 点击下标回调
 */
+ (void)wb_showActionSheetWithTitle:(NSString *)title
                       actionTitles:(NSArray <NSString *> *)actionTitles
                       actionStyles:(NSArray <NSNumber *> *)actionStyles
                   itemHandlerBlock:(MMPopupItemHandler)itemHandlerBlock;


@end
