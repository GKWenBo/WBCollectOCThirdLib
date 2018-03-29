//
//  UIView+DWQExtension.m
//  DWQTools
//
//  Created by 杜文全 on 16/9/28.
//  Copyright © 2016年 杜文全. All rights reserved.
//  杜文全版权所有》--->如果问题请联系 439878592@qq.com

#import "UIView+DWQExtension.h"

@implementation UIView (DWQExtension)

#pragma mark - 快速设置控件的frame
- (void)setDwq_x:(CGFloat)dwq_x
{
    CGRect frame = self.frame;
    frame.origin.x = dwq_x;
    self.frame = frame;
}

- (void)setDwq_y:(CGFloat)dwq_y
{
    CGRect frame = self.frame;
    frame.origin.y = dwq_y;
    self.frame = frame;
}

- (CGFloat)dwq_x
{
    return self.frame.origin.x;
}

- (CGFloat)dwq_y
{
    return self.frame.origin.y;
}

- (void)setDwq_centerX:(CGFloat)dwq_centerX
{
    CGPoint center = self.center;
    center.x = dwq_centerX;
    self.center = center;
}

- (CGFloat)dwq_centerX
{
    return self.center.x;
}

- (void)setDwq_centerY:(CGFloat)dwq_centerY
{
    CGPoint center = self.center;
    center.y = dwq_centerY;
    self.center = center;
}

- (CGFloat)dwq_centerY
{
    return self.center.y;
}

- (void)setDwq_width:(CGFloat)dwq_width
{
    CGRect frame = self.frame;
    frame.size.width = dwq_width;
    self.frame = frame;
}

- (void)setDwq_height:(CGFloat)dwq_height
{
    CGRect frame = self.frame;
    frame.size.height = dwq_height;
    self.frame = frame;
}

- (CGFloat)dwq_height
{
    return self.frame.size.height;
}

- (CGFloat)dwq_width
{
    return self.frame.size.width;
}

- (void)setDwq_size:(CGSize)dwq_size
{
    CGRect frame = self.frame;
    frame.size = dwq_size;
    self.frame = frame;
}

- (CGSize)dwq_size
{
    return self.frame.size;
}

- (void)setDwq_origin:(CGPoint)dwq_origin
{
    CGRect frame = self.frame;
    frame.origin = dwq_origin;
    self.frame = frame;
}

- (CGPoint)dwq_origin
{
    return self.frame.origin;
}

#pragma mark - 动画相关
- (void)dwq_addAnimationAtPoint:(CGPoint)point;
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    CGFloat diameter = [self dwq_mdShapeDiameterForPoint:point];
    shapeLayer.frame = CGRectMake(floor(point.x - diameter * 0.5), floor(point.y - diameter * 0.5), diameter, diameter);
    shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0.0, 0.0, diameter, diameter)].CGPath;
    [self.layer addSublayer:shapeLayer];
    shapeLayer.fillColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0].CGColor;
    // animate
    CGFloat scale = 100.0 / shapeLayer.frame.size.width;
    NSString *timingFunctionName = kCAMediaTimingFunctionDefault; //inflating ? kCAMediaTimingFunctionDefault : kCAMediaTimingFunctionDefault;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, 1.0)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:timingFunctionName];
    animation.removedOnCompletion = YES;
    animation.duration = 3.0;
    shapeLayer.transform = [animation.toValue CATransform3DValue];
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [shapeLayer removeFromSuperlayer];
    }];
    [shapeLayer addAnimation:animation forKey:@"shapeBackgroundAnimation"];
    [CATransaction commit];
}

- (void)dwq_addAnimationAtPoint:(CGPoint)point WithType:(HDAnimationType) type withColor:(UIColor *)animationColor completion:(void (^)(BOOL))completion
{
    [self dwq_addAnimationAtPoint:point WithDuration:1.0 WithType:type withColor:animationColor  completion:completion];
}

- (void)dwq_addAnimationAtPoint:(CGPoint)point WithDuration:(NSTimeInterval)duration WithType:(HDAnimationType) type withColor:(UIColor *)animationColor completion:(void (^)(BOOL finished))completion
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    CGFloat diameter = [self dwq_mdShapeDiameterForPoint:point];
    shapeLayer.frame = CGRectMake(floor(point.x - diameter * 0.5), floor(point.y - diameter * 0.5), diameter, diameter);
    shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0.0, 0.0, diameter, diameter)].CGPath;
    
    shapeLayer.fillColor = animationColor.CGColor;
    // animate
    CGFloat scale = 1.0 / shapeLayer.frame.size.width;
    NSString *timingFunctionName = kCAMediaTimingFunctionDefault; //inflating ? kCAMediaTimingFunctionDefault : kCAMediaTimingFunctionDefault;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    switch (type) {
        case HDAnimationOpen:
        {
            [self.layer addSublayer:shapeLayer];
            animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
            animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, 1.0)];
            break;
        }
        case HDAnimationClose:
        {
            [self.layer insertSublayer:shapeLayer atIndex:0];
            animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, 1.0)];
            animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
            break;
        }
        default:
            break;
    }
    animation.timingFunction = [CAMediaTimingFunction functionWithName:timingFunctionName];
    animation.removedOnCompletion = YES;
    animation.duration = duration;
    shapeLayer.transform = [animation.toValue CATransform3DValue];
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [shapeLayer removeFromSuperlayer];
        completion(true);
    }];
    [shapeLayer addAnimation:animation forKey:@"shapeBackgroundAnimation"];
    [CATransaction commit];
    
}

- (void)dwq_addAnimationAtPoint:(CGPoint)point WithType:(HDAnimationType) type withColor:(UIColor *)animationColor;
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    CGFloat diameter = [self dwq_mdShapeDiameterForPoint:point];
    shapeLayer.frame = CGRectMake(floor(point.x - diameter * 0.5), floor(point.y - diameter * 0.5), diameter, diameter);
    shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0.0, 0.0, diameter, diameter)].CGPath;
    
    shapeLayer.fillColor = animationColor.CGColor;
    // animate
    CGFloat scale = 100.0 / shapeLayer.frame.size.width;
    NSString *timingFunctionName = kCAMediaTimingFunctionDefault; //inflating ? kCAMediaTimingFunctionDefault : kCAMediaTimingFunctionDefault;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    switch (type) {
        case HDAnimationOpen:
        {
            [self.layer addSublayer:shapeLayer];
            animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
            animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, 1.0)];
            break;
        }
        case HDAnimationClose:
        {
            [self.layer insertSublayer:shapeLayer atIndex:0];
            animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, 1.0)];
            animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
            break;
        }
        default:
            break;
    }
    animation.timingFunction = [CAMediaTimingFunction functionWithName:timingFunctionName];
    animation.removedOnCompletion = YES;
    animation.duration = 3.0;
    shapeLayer.transform = [animation.toValue CATransform3DValue];
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [shapeLayer removeFromSuperlayer];
    }];
    [shapeLayer addAnimation:animation forKey:@"shapeBackgroundAnimation"];
    [CATransaction commit];
}

// 计算离屏幕的边框最大的距离
- (CGFloat)dwq_mdShapeDiameterForPoint:(CGPoint)point
{
    CGPoint cornerPoints[] = {
        {0.0, 0.0},
        {0.0, self.bounds.size.height},
        {self.bounds.size.width, self.bounds.size.height},
        {self.bounds.size.width, 0.0}
    };
    
    CGFloat radius = 0.0;
    for (int i = 0; i < 4; i++)
    {
        CGPoint p = cornerPoints[i];
        CGFloat d = sqrt( pow(p.x - point.x, 2.0) + pow(p.y - point.y, 2.0));
        if (d > radius)
        {
            radius = d;
        }
    }
    
    return radius * 2.0;
}

@end
