//
//  MHAsiNetworkItemDelegate.h
//  PersonalAssistant
//
//  Created by dabing on 15/10/23.
//  Copyright © 2015年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *   AFN 请求封装的代理协议
 */
@protocol MHAsiNetworkDelegate <NSObject>

@optional
/**
 *   请求结束
 *
 *   @param returnData 返回的数据
 */
- (void)requestDidFinishLoading:(NSDictionary*)returnData;
/**
 *   请求失败
 *
 *   @param error 失败的 error
 */
- (void)requestdidFailWithError:(NSError*)error;


- (void)netWorkWillDealloc:(MHAsiNetworkItem*)itme;

@end
