//
//  MHNetworkManager.m
//  MHProject
//
//  Created by yons on 15/9/22.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

#import "MHNetworkManager.h"
#import "MHAsiNetworkHandler.h"

@implementation MHNetworkManager
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static MHNetworkManager *_manager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [super allocWithZone:zone];
    });
    return _manager;
}
/// 返回单例
+(instancetype)sharedInstance
{
    return [[super alloc] init];
}
#pragma mark - GET 请求的三种回调方法

/**
 *   GET请求的公共方法 一下三种方法都调用这个方法 根据传入的不同参数觉得回调的方式
 *
 *   @param url           ur
 *   @param paramsDict   paramsDict
 *   @param target       target
 *   @param action       action
 *   @param delegate     delegate
 *   @param successBlock successBlock
 *   @param failureBlock failureBlock
 *   @param showHUD      showHUD
 */
+ (void)getRequstWithURL:(NSString*)url
                  params:(NSDictionary*)params
                  target:(id)target
                  action:(SEL)action
                delegate:(id)delegate
            successBlock:(MHAsiSuccessBlock)successBlock
            failureBlock:(MHAsiFailureBlock)failureBlock
                 showHUD:(BOOL)showHUD
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:params];
    [[MHAsiNetworkHandler sharedInstance] conURL:url networkType:MHAsiNetWorkGET params:mutableDict delegate:delegate showHUD:showHUD target:target action:action successBlock:successBlock failureBlock:failureBlock];
}
/**
 *   GET请求通过Block 回调结果
 *
 *   @param url          url
 *   @param paramsDict   paramsDict
 *   @param successBlock  成功的回调
 *   @param failureBlock  失败的回调
 *   @param showHUD      是否加载进度指示器
 */
+ (void)getRequstWithURL:(NSString*)url
                  params:(NSDictionary*)params
            successBlock:(MHAsiSuccessBlock)successBlock
            failureBlock:(MHAsiFailureBlock)failureBlock
                 showHUD:(BOOL)showHUD
{
    [self getRequstWithURL:url params:params target:nil action:nil delegate:nil successBlock:successBlock failureBlock:failureBlock showHUD:showHUD];
}
/**
 *   GET请求通过代理回调
 *
 *   @param url         url
 *   @param paramsDict  请求的参数
 *   @param delegate    delegate
 *   @param showHUD    是否转圈圈
 */
+ (void)getRequstWithURL:(NSString*)url
                  params:(NSDictionary*)params
                delegate:(id<MHAsiNetworkDelegate>)delegate
                 showHUD:(BOOL)showHUD
{
    [self getRequstWithURL:url params:params target:nil action:nil delegate:delegate successBlock:nil failureBlock:nil showHUD:showHUD];
}

/**
 *   get 请求通过 taget 回调方法
 *
 *   @param url         url
 *   @param paramsDict  请求参数的字典
 *   @param target      target
 *   @param action      action
 *   @param showHUD     是否加载进度指示器
 */
+ (void)getRequstWithURL:(NSString*)url
                  params:(NSDictionary*)params
                  target:(id)target
                  action:(SEL)action
                 showHUD:(BOOL)showHUD
{
    [self getRequstWithURL:url params:params target:target action:action delegate:nil successBlock:nil failureBlock:nil showHUD:showHUD];
}

#pragma mark - POST请求的三种回调方法
/**
 *   发送一个 POST请求的公共方法 传入不同的回调参数决定回调的方式
 *
 *   @param url           ur
 *   @param paramsDict   paramsDict
 *   @param target       target
 *   @param action       action
 *   @param delegate     delegate
 *   @param successBlock successBlock
 *   @param failureBlock failureBlock
 *   @param showHUD      showHUD
 */
+ (void)postReqeustWithURL:(NSString*)url
                    params:(NSDictionary*)params
                    target:(id)target
                    action:(SEL)action
                  delegate:(id<MHAsiNetworkDelegate>)delegate
              successBlock:(MHAsiSuccessBlock)successBlock
              failureBlock:(MHAsiFailureBlock)failureBlock
                   showHUD:(BOOL)showHUD
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:params];
    [[MHAsiNetworkHandler sharedInstance] conURL:url networkType:MHAsiNetWorkPOST params:mutableDict delegate:delegate showHUD:showHUD target:target action:action successBlock:successBlock failureBlock:failureBlock];
}
/**
 *   通过 Block回调结果
 *
 *   @param url           url
 *   @param paramsDict    请求的参数字典
 *   @param successBlock  成功的回调
 *   @param failureBlock  失败的回调
 *   @param showHUD       是否加载进度指示器
 */
+ (void)postReqeustWithURL:(NSString*)url
                    params:(NSDictionary*)params
              successBlock:(MHAsiSuccessBlock)successBlock
              failureBlock:(MHAsiFailureBlock)failureBlock
                   showHUD:(BOOL)showHUD
{
    [self postReqeustWithURL:url params:params target:nil action:nil delegate:nil successBlock:successBlock failureBlock:failureBlock showHUD:showHUD];
}

/**
 *   post请求通过代理回调
 *
 *   @param url         url
 *   @param paramsDict  请求的参数
 *   @param delegate    delegate
 *   @param showHUD    是否转圈圈
 */
+ (void)postReqeustWithURL:(NSString*)url
                    params:(NSDictionary*)params
                  delegate:(id<MHAsiNetworkDelegate>)delegate
                   showHUD:(BOOL)showHUD;
{
    [self postReqeustWithURL:url params:params target:nil action:nil delegate:delegate successBlock:nil failureBlock:nil showHUD:showHUD];
}


/**
 *   post 请求通过 target 回调结果
 *
 *   @param url         url
 *   @param paramsDict  请求参数的字典
 *   @param target      target
 *   @param showHUD     是否显示圈圈
 */
+ (void)postReqeustWithURL:(NSString*)url
                    params:(NSDictionary*)params
                    target:(id)target
                    action:(SEL)action
                   showHUD:(BOOL)showHUD
{
    [self postReqeustWithURL:url params:params target:target action:action delegate:nil successBlock:nil failureBlock:nil showHUD:showHUD];
}

@end
