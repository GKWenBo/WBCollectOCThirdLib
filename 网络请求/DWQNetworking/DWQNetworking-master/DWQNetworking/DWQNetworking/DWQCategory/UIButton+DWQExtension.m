//
//  UIButton+DWQExtension.m
//  DWQTools
//
//  Created by 杜文全 on 16/9/28.
//  Copyright © 2016年 杜文全. All rights reserved.
//  杜文全版权所有》--->如果问题请联系 439878592@qq.com

#import "UIButton+DWQExtension.h"

@implementation UIButton (DWQExtension)
- (void)dwq_setN_BG:(NSString *)nbg H_BG:(NSString *)hbg
{
    [self setBackgroundImage:[UIImage imageNamed:nbg] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:hbg] forState:UIControlStateHighlighted];
}

- (void)dwq_setNormalTitleColor:(UIColor *)nColor Higblighted:(UIColor *)hColor
{
    [self setTitleColor:nColor forState:UIControlStateNormal];
    [self setTitleColor:hColor forState:UIControlStateHighlighted];
}

- (void)dwq_setResizeN_BG:(NSString *)nbg H_BG:(NSString *)hbg
{
    UIImage *normalImage = [UIImage imageNamed:nbg];
    int normalLeftCap = normalImage.size.width * 0.5;
    int normalTopCap = normalImage.size.height * 0.5;
    [self setBackgroundImage:[normalImage stretchableImageWithLeftCapWidth:normalLeftCap topCapHeight:normalTopCap] forState:UIControlStateNormal];
    
    UIImage *highlightedImage = [UIImage imageNamed:hbg];
    int highlightedImageLeftCap = normalImage.size.width * 0.5;
    int highlightedImageTopCap = normalImage.size.height * 0.5;
    [self setBackgroundImage:[highlightedImage stretchableImageWithLeftCapWidth:highlightedImageLeftCap topCapHeight:highlightedImageTopCap] forState:UIControlStateHighlighted];
}
@end
