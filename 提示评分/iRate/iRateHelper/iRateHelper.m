//
//  iRateHelper.m
//  Start
//
//  Created by Mr_Lucky on 2018/9/29.
//  Copyright © 2018 jmw. All rights reserved.
//

#import "iRateHelper.h"
#import <iRate.h>

@interface iRateHelper () <iRateDelegate,UIAlertViewDelegate>

@end

@implementation iRateHelper

+ (instancetype)shareHelper {
    static iRateHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance  = [[self alloc]init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self wb_defaultConfig];
    }
    return self;
}

- (void)wb_defaultConfig {
    //最少的使用次数，大于或等于它才弹出评级框
    [iRate sharedInstance].usesUntilPrompt = 12;
    //只有在最新的版本中弹出评级框，默认是Yes
    [iRate sharedInstance].onlyPromptIfLatestVersion = NO;
    //boundidentifier
    [iRate sharedInstance].applicationBundleID = @"com.Tcsd.JmwPlus";
    //用户安装并启动之后多少天才弹出评级框 10天
    [iRate sharedInstance].daysUntilPrompt = 6;
    
    /*  < 每次启动就弹框提醒 > */
    [iRate sharedInstance].promptAtLaunch = NO;
    
//    [iRate sharedInstance].previewMode = YES;
    
    //当用户点击稍后提醒我后，再次弹出评级框的间隔时间，这个设置会覆盖其他配置，即使有新版本也不会弹出
    [iRate sharedInstance].remindPeriod = 6.0f;
    
    //设置代理
    [iRate sharedInstance].delegate = self;
}

// MARK:iRateDelegate
- (BOOL)iRateShouldPromptForRating {
    [self setupCustomAlertController];
    return NO;
}

- (void)setupCustomAlertController {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"给我评价"
                                                       message:@"觉得这个app怎么样，喜欢就来评价一下呗"
                                                      delegate:self
                                             cancelButtonTitle:@"以后再说"
                                             otherButtonTitles:@"喜欢，支持一下",@"不喜欢，去吐槽", nil];
    [alertView show];
}

// MARK:UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
        {//以后再说
            // 记录当前时间
            [iRate sharedInstance].lastReminded = [NSDate date];
        }
            break;
        case 1:
        {
            // 记录评级
            [iRate sharedInstance].ratedThisVersion = YES;
            // 跳转AppStore
            [[iRate sharedInstance] openRatingsPageInAppStore];
        }
            break;
        case 2:
        {//去吐槽
            
            NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1154361853?mt=8"];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
            break;
        default:
            break;
    }
}


@end
