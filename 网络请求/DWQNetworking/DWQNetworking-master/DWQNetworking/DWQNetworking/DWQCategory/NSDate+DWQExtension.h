//
//  NSDate+DWQExtension.h
//  DWQTools
//
//  Created by 杜文全 on 16/9/28.
//  Copyright © 2016年 杜文全. All rights reserved.
//  《杜文全版权所有》 如有问题请联系439878592@qq.com

#import <Foundation/Foundation.h>

@interface NSDate (DWQExtension)
/**
 *  是否为今天
 */
- (BOOL)dwq_isToday;

/**
 *  是否为昨天
 */
- (BOOL)dwq_isYesterday;

/**
 *  是否为今年
 */
- (BOOL)dwq_isThisYear;

/**
 *  返回一个只有年月日的时间
 */
- (NSDate *)dwq_dateWithYMD;

/**
 *  获得与当前时间的差距
 */
- (NSDateComponents *)dwq_deltaWithNow;
@end
