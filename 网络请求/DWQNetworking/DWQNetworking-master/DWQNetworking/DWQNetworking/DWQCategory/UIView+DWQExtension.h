//
//  UIView+DWQExtension.h
//  DWQTools
//
//  Created by 杜文全 on 16/9/28.
//  Copyright © 2016年 杜文全. All rights reserved.
//  杜文全版权所有》--->如果问题请联系 439878592@qq.com

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HDAnimationType)
{
    HDAnimationOpen,// 动画开启
    HDAnimationClose// 动画关闭
};


@interface UIView (DWQExtension)

#pragma mark - 快速设置控件的frame
@property (nonatomic, assign) CGFloat dwq_x;
@property (nonatomic, assign) CGFloat dwq_y;
@property (nonatomic, assign) CGFloat dwq_centerX;
@property (nonatomic, assign) CGFloat dwq_centerY;
@property (nonatomic, assign) CGFloat dwq_width;
@property (nonatomic, assign) CGFloat dwq_height;
@property (nonatomic, assign) CGPoint dwq_origin;
@property (nonatomic, assign) CGSize dwq_size;

#pragma mark - 动画相关
/**
 *  在某个点添加动画
 *
 *  @param point 动画开始的点
 */
- (void)dwq_addAnimationAtPoint:(CGPoint)point;

/**
 *  在某个点添加动画
 *
 *  @param point 动画开始的点
 *  @param type  动画的类型
 *  @param color 动画的颜色
 */
- (void)dwq_addAnimationAtPoint:(CGPoint)point WithType:(HDAnimationType)type withColor:(UIColor *)animationColor;

/**
 *  在某个点添加动画
 *
 *  @param point 动画开始的点
 *  @param type  动画的类型
 *  @param color 动画的颜色
 *  @param completion 动画结束后的代码快
 */
- (void)dwq_addAnimationAtPoint:(CGPoint)point WithType:(HDAnimationType)type withColor:(UIColor *)animationColor completion:(void (^)(BOOL finished))completion;

/**
 *  在某个点添加动画
 *
 *  @param point      动画开始的点
 *  @param duration   动画时间
 *  @param type       动画的类型
 *  @param color 动画的颜色
 *  @param completion 动画结束后的代码快
 */
- (void)dwq_addAnimationAtPoint:(CGPoint)point WithDuration:(NSTimeInterval)duration WithType:(HDAnimationType) type withColor:(UIColor *)animationColor completion:(void (^)(BOOL finished))completion;

@end
