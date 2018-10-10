//
//  ViewController.m
//  TextCarouselView
//
//  Created by 纯泽科技 on 2016/11/18.
//  Copyright © 2016年 Focus Chen. All rights reserved.
//

#import "ViewController.h"

#import "CFaTextCarouselView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCFaTextCarouselView];
}

/**
 * @title 设置文字轮播视图
 */
- (void)setupCFaTextCarouselView
{
    NSArray *textArr = @[
                         @"前尘往事不可追，",
                         @"一成相思一层灰。",
                         @"来世化作采莲人，",
                         @"与卿相逢横塘水。"
                         ];
    CFaTextCarouselView *textCarouselView = [[CFaTextCarouselView alloc] initWithFrame:CGRectMake(0.0, 100.0, self.view.bounds.size.width, 50.0) textArray:textArr carouselDirection:CFaCarouselDirectionHorizontally carouselType:CFaCarouselTypePagingEnabled];
    
    textCarouselView.scrollDelay = 5.f;
    
    [self.view addSubview:textCarouselView];
    
    
    //木兰花 晏殊
    NSArray *mulanhuaArr = @[
                             @"绿杨芳草长亭路，",
                             @"年少抛人容易去。",
                             @"楼头残梦五更钟，",
                             @"花底离愁三月雨。",
                             @"无情不似多情苦，",
                             @"一寸还成千万缕。",
                             @"天涯地角有穷时，",
                             @"只有相思无尽处。"
                             ];
    CFaTextCarouselView *textCarouselView2 = [[CFaTextCarouselView alloc] initWithFrame:CGRectMake(0.0, 200.0, self.view.bounds.size.width, 50.0) textArray:mulanhuaArr carouselDirection:CFaCarouselDirectionHorizontally carouselType:CFaCarouselTypeFlowing];
    
    textCarouselView2.canUserScroll = YES;//用户可滑动
    textCarouselView2.canUserTap = YES;//用户可点击
    textCarouselView2.textFont = [UIFont systemFontOfSize:16.f];//文字字号
    textCarouselView2.textColor = [UIColor redColor];//文字颜色
    
    [self.view addSubview:textCarouselView2];
    
    
    //鹊桥仙 秦观
    NSArray *queqiaoxianArr = @[
                                @"纤云弄巧，",
                                @"飞星传恨，",
                                @"银汉迢迢暗渡，",
                                @"金风玉露一相逢，",
                                @"便胜却人间无数。",
                                @"柔情似水，",
                                @"佳期如梦，",
                                @"忍顾鹊桥归路，",
                                @"两情若是久长时，",
                                @"又岂在朝朝暮暮。"
                                ];
    CFaTextCarouselView *textCarouselView3 = [[CFaTextCarouselView alloc] initWithFrame:CGRectMake(0.0, 300.0, self.view.bounds.size.width, 50.0) textArray:queqiaoxianArr carouselDirection:CFaCarouselDirectionVertically carouselType:CFaCarouselTypePagingEnabled];
    
    textCarouselView3.scrollDelay = 5.f;//轮播间隔
    
    [self.view addSubview:textCarouselView3];
    
    
    //青玉案·元夕 辛弃疾
    NSArray *qingyuanArr = @[
                             @"东风夜放花千树，",
                             @"更吹落，",
                             @"星如雨，",
                             @"宝马雕车香满路。",
                             @"凤箫声动，",
                             @"玉壶光转，",
                             @"一夜鱼龙舞。",
                             @"蛾儿雪柳黄金缕，",
                             @"笑语盈盈暗香去。",
                             @"众里寻他千百度，",
                             @"蓦然回首，",
                             @"那人却在，",
                             @"灯火阑珊处。"
                             ];
    CFaTextCarouselView *textCarouselView4 = [[CFaTextCarouselView alloc] initWithFrame:CGRectMake(0.0, 400.0, self.view.bounds.size.width, 50.0) textArray:qingyuanArr carouselDirection:CFaCarouselDirectionVertically carouselType:CFaCarouselTypeFlowing];
    
    textCarouselView4.backgroundColor = [[UIColor cyanColor] colorWithAlphaComponent:0.5];//背景色
    
    [self.view addSubview:textCarouselView4];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
