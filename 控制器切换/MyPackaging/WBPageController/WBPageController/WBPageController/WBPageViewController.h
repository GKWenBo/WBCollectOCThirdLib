//
//  WBPageViewController.h
//  WBPageController
//
//  Created by wenbo on 2018/5/9.
//  Copyright © 2018年 wenbo. All rights reserved.
//

/** <
    分页控制器，继承使用
 >  */

#import <UIKit/UIKit.h>
#import "WBSegmentView.h"
#import "WBPageContentView.h"

typedef NS_ENUM(NSInteger, WBSegmentPositionStyle) {
    WBSegmentPositionNaviStyle, /** < 分段控件在导航栏 >  */
    WBSegmentPositionSubStyle   /** < 分段控件在subView >  */
};

@interface WBPageViewController : UIViewController <WBSegmentViewDelegate,WBPageContentViewDelegate>

/** < 分段控件 >  */
@property (nonatomic, strong) WBSegmentView *segementView;
/** < 内容视图 >  */
@property (nonatomic, strong) WBPageContentView *contentView;

/**
 初始化方法

 @param titles 标题
 @param childVcs 子控制器名数组
 @param position 分段控件位置
 @return WBPageViewController
 */
- (instancetype)initWithSegmentTitles:(NSArray <NSString *>*)titles
                             childVcs:(NSArray <UIViewController<WBPageChildVcDelegate> *>*)childVcs
                             position:(WBSegmentPositionStyle)position;

@end
