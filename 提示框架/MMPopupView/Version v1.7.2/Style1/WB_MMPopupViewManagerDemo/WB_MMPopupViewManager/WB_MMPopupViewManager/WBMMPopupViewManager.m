//
//  WB_MMPopupViewManager.m
//  WB_MMPopupViewManager
//
//  Created by WMB on 2017/6/11.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "WBMMPopupViewManager.h"

@implementation WBMMPopupViewManager

+ (void)wb_defaultConfig {
    
    [MMPopupWindow sharedWindow].touchWildToHide = YES;
    
}

#pragma mark --------  基础方法  --------
#pragma mark
+ (void)wb_showOneActionAlertViewWithTitle:(NSString *)title
                                   message:(NSString *)message
                               actionTitle:(NSString *)actionTitle
                           blurEffectStyle:(UIBlurEffectStyle)blurEffectStyle
                          itemHandlerBlock:(MMPopupItemHandler)itemHandlerBlock {
    
    MMPopupCompletionBlock completeBlock = ^(MMPopupView *popupView, BOOL finished){
        
    };
    
    MMPopupItemHandler block = ^(NSInteger index){
//        NSLog(@"clickd %@ button",@(index));
        if (itemHandlerBlock) {
            itemHandlerBlock(index);
        }
    };
    
    MMAlertViewConfig * config = [MMAlertViewConfig globalConfig];
    config.defaultTextOK = actionTitle;
    
    NSArray * items = @[MMItemMake(config.defaultTextOK, MMItemTypeHighlight, block)];
    
    MMAlertView * alertView = [[MMAlertView alloc]initWithTitle:title detail:message items:items];
    /**  设置蒙版样式  */
    alertView.attachedView.mm_dimBackgroundBlurEnabled = YES;
    alertView.attachedView.mm_dimBackgroundBlurEffectStyle = blurEffectStyle;
    
    [alertView showWithBlock:completeBlock];
}

+ (void)wb_showTwoActionAlertViewWithTitle:(NSString *)title
                                   message:(NSString *)message
                                 leftTitle:(NSString *)leftTitle
                                rightTitle:(NSString *)rightTitle
                           blurEffectStyle:(UIBlurEffectStyle)blurEffectStyle
                          itemHandlerBlock:(MMPopupItemHandler)itemHandlerBlock {
    
    MMPopupItemHandler block = ^(NSInteger index){
        //        NSLog(@"clickd %@ button",@(index));
        if (itemHandlerBlock) {
            itemHandlerBlock(index);
        }
    };
    
    MMAlertViewConfig * config = [MMAlertViewConfig globalConfig];
    config.defaultTextCancel = leftTitle;
    config.defaultTextConfirm = rightTitle;
    
    NSArray * items = @[MMItemMake(config.defaultTextCancel, MMItemTypeHighlight, block),
                        MMItemMake(config.defaultTextConfirm, MMItemTypeNormal, block)];
    MMAlertView * alertView = [[MMAlertView alloc]initWithTitle:title detail:message items:items];
    alertView.attachedView.mm_dimBackgroundBlurEnabled = YES;
    alertView.attachedView.mm_dimBackgroundBlurEffectStyle = blurEffectStyle;
    
    [alertView show];
}
+ (void)wb_showAlertViewWithTitle:(NSString *)title
                          message:(NSString *)message
                     actionTitles:(NSArray <NSString *> *)actionTitles
                     actionStyles:(NSArray <NSNumber *> *)actionStyles
                  blurEffectStyle:(UIBlurEffectStyle)blurEffectStyle
                 itemHandlerBlock:(MMPopupItemHandler)itemHandlerBlock{
    
//    MMAlertViewConfig * config = [MMAlertViewConfig globalConfig];
//    config.itemNormalColor = [UIColor blackColor];
//    config.itemHighlightColor = [UIColor redColor];
    NSAssert(actionTitles.count > 0 || actionStyles.count > 0, @"按钮标题或按钮样式不能为空");
    NSAssert(actionTitles.count == actionStyles.count, @"按钮标题个数和按钮样式个数不相等，请检查");
    
    MMPopupItemHandler block = ^(NSInteger index){
       
        if (itemHandlerBlock) {
            
            itemHandlerBlock(index);
        }
    };
    
    NSMutableArray * items = @[].mutableCopy;
    /**  遍历标题  */
    [actionTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        NSNumber * type = actionStyles[idx];
        NSAssert(type.integerValue == MMItemTypeNormal || type.integerValue == MMItemTypeHighlight || type.integerValue == MMItemTypeDisabled, @"样式设置有误请检查");
        MMItemType style;
        switch (type.integerValue) {
            case MMItemTypeNormal:
                style = MMItemTypeNormal;
                break;
            case MMItemTypeHighlight:
                style = MMItemTypeHighlight;
                break;
            case MMItemTypeDisabled:
                style = MMItemTypeDisabled;
                break;
            default:
                style = MMItemTypeNormal;
                break;
        }
        [items addObject:MMItemMake(obj, style, block)];
    }];
    
    MMAlertView * alertView = [[MMAlertView alloc]initWithTitle:title detail:message items:items];
    alertView.attachedView.mm_dimBackgroundBlurEnabled = YES;
    alertView.attachedView.mm_dimBackgroundBlurEffectStyle = blurEffectStyle;
    [alertView show];
}
+ (void)wb_showActionSheetWithTitle:(NSString *)title
                       actionTitles:(NSArray <NSString *> *)actionTitles
                       actionStyles:(NSArray <NSNumber *> *)actionStyles
                    blurEffectStyle:(UIBlurEffectStyle)blurEffectStyle
                   itemHandlerBlock:(MMPopupItemHandler)itemHandlerBlock {
    
    NSAssert(actionTitles.count > 0 || actionStyles.count > 0, @"按钮标题或按钮样式不能为空");
    NSAssert(actionTitles.count == actionStyles.count, @"按钮标题个数和按钮样式个数不相等，请检查");
    
    MMPopupItemHandler block = ^(NSInteger index){
        
        if (itemHandlerBlock) {
            
            itemHandlerBlock(index);
        }
    };

//    MMSheetViewConfig * config = [MMSheetViewConfig globalConfig];
//    config.itemNormalColor = [UIColor blackColor];
//    config.itemHighlightColor = [UIColor redColor];
    NSMutableArray * items = @[].mutableCopy;
    /**  遍历标题  */
    [actionTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSNumber * type = actionStyles[idx];
        NSAssert(type.integerValue == MMItemTypeNormal || type.integerValue == MMItemTypeHighlight || type.integerValue == MMItemTypeDisabled, @"样式设置有误请检查");
        MMItemType style;
        switch (type.integerValue) {
            case MMItemTypeNormal:
                style = MMItemTypeNormal;
                break;
            case MMItemTypeHighlight:
                style = MMItemTypeHighlight;
                break;
            case MMItemTypeDisabled:
                style = MMItemTypeDisabled;
                break;
            default:
                style = MMItemTypeNormal;
                break;
        }
        [items addObject:MMItemMake(obj, style, block)];
    }];

    MMSheetView * sheetView = [[MMSheetView alloc]initWithTitle:title items:items];
    sheetView.attachedView.mm_dimBackgroundBlurEnabled = YES;
    sheetView.attachedView.mm_dimBackgroundBlurEffectStyle = blurEffectStyle;
    
    [sheetView show];
}

#pragma mark --------  常用方法  --------
#pragma mark
+ (void)wb_showOneActionAlertViewWithTitle:(NSString *)title
                                   message:(NSString *)message
                          itemHandlerBlock:(MMPopupItemHandler)itemHandlerBlock {
    
    [self wb_showOneActionAlertViewWithTitle:title message:message actionTitle:@"好的" blurEffectStyle:UIBlurEffectStyleDark itemHandlerBlock:itemHandlerBlock];
}
+ (void)wb_showTwoActionAlertViewWithTitle:(NSString *)title
                                   message:(NSString *)message
                          itemHandlerBlock:(MMPopupItemHandler)itemHandlerBlock {
    
    [self wb_showTwoActionAlertViewWithTitle:title message:message leftTitle:@"取消" rightTitle:@"确定" blurEffectStyle:UIBlurEffectStyleDark itemHandlerBlock:itemHandlerBlock];
}
+ (void)wb_showAlertViewWithTitle:(NSString *)title
                          message:(NSString *)message
                     actionTitles:(NSArray <NSString *> *)actionTitles
                     actionStyles:(NSArray <NSNumber *> *)actionStyles
                 itemHandlerBlock:(MMPopupItemHandler)itemHandlerBlock{
    
    [self wb_showAlertViewWithTitle:title message:message actionTitles:actionTitles actionStyles:actionStyles blurEffectStyle:UIBlurEffectStyleDark itemHandlerBlock:itemHandlerBlock];
}

+ (void)wb_showActionSheetWithTitle:(NSString *)title
                       actionTitles:(NSArray <NSString *> *)actionTitles
                       actionStyles:(NSArray <NSNumber *> *)actionStyles
                   itemHandlerBlock:(MMPopupItemHandler)itemHandlerBlock {
    [self wb_showActionSheetWithTitle:title actionTitles:actionTitles actionStyles:actionStyles blurEffectStyle:UIBlurEffectStyleDark itemHandlerBlock:itemHandlerBlock];
}
@end
