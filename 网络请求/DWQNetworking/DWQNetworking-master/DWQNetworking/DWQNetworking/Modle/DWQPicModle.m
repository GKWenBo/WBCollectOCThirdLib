//
//  DWQPicModle.m
//  DWQTools
//
//  Created by 杜文全 on 16/9/28.
//  Copyright © 2016年 杜文全. All rights reserved.
//  杜文全版权所有》--->如果问题请联系 439878592@qq.com

#import "DWQPicModle.h"

@implementation DWQPicModle

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ : %p> \n{picName : %@ \n pic : %@ \n}", [self class], self,self.picName, self.pic];
}

@end
