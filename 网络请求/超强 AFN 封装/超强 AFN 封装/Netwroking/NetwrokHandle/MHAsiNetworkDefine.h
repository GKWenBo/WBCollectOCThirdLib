//
//  MHAsiNetworkDefine.h
//  MHProject
//
//  Created by MengHuan on 15/4/23.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

#ifndef MHProject_MHAsiNetworkDefine_h
#define MHProject_MHAsiNetworkDefine_h

/**
 *  请求类型
 */
typedef enum {
    MHAsiNetWorkGET = 1,   /**< GET请求 */
    MHAsiNetWorkPOST       /**< POST请求 */
} MHAsiNetWorkType;

/**
 *  网络请求超时的时间
 */
#define MHAsi_API_TIME_OUT 20


#if NS_BLOCKS_AVAILABLE
/**
 *  请求开始的回调（下载时用到）
 */
typedef void (^MHAsiStartBlock)(void);

/**
 *  请求成功回调
 *
 *  @param returnData 回调block
 */
typedef void (^MHAsiSuccessBlock)(id returnData,int code,NSString *msg);

/**
 *  请求失败回调
 *
 *  @param error 回调block
 */
typedef void (^MHAsiFailureBlock)(NSError *error);

#endif

#endif
