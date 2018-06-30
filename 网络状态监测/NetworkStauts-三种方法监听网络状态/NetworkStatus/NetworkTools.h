//
//  NetworkTools.h
//  NetworkStatus
//
//  Created by mdd on 16/3/21.
//  Copyright © 2016年 com.personal. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface NetworkTools : AFHTTPSessionManager
+ (instancetype)sharedManager;
@end
