//
//  CZUploadParam.h
//  传智微博
//
//  Created by apple on 15-3-13.
//  Copyright (c) 2015年 apple. All rights reserved.
//  图片上传的参数模型

#import <Foundation/Foundation.h>

@interface MHUploadParam : NSObject

/**
 *  上传文件的二进制数据
 */
@property (nonatomic, strong) NSData *data;
/**
 *  上传的参数名称
 */
@property (nonatomic, copy) NSString *name;
/**
 *  上传到服务器的文件名称
 */
@property (nonatomic, copy) NSString *fileName;

/**
 *  上传文件的类型
 */
@property (nonatomic, copy) NSString *mimeType;



@end
