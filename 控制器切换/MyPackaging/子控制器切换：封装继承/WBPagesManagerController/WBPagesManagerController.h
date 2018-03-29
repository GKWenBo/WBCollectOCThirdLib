//
//  WBPagesManagerController.h
//  WBPagesManagerController
//
//  Created by WMB on 2017/3/27.
//  Copyright © 2017年 文波. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WBPagesReuseSegmentView.h"
@interface WBPagesManagerController : UIViewController <UIScrollViewDelegate>

@property (nonatomic,strong) WBPagesReuseSegmentView * segmentView;/**  分段控件  */

@property (nonatomic,strong) NSArray * segmentTitles;/**  分段控件标题  */
@property (nonatomic,strong) NSArray * classNames;/**  类名称  */
@property (nonatomic,strong) NSMutableDictionary * allChildsDict;


@property (nonatomic,strong) UIScrollView * mainScrollView;/**  滚动视图  */

/**
 添加child view 到 horScrollView
 */
- (void)scrollDidStopAddChildVcIfNeed;


/**
 当点击 segement 或者 滑动 scrollView 完成 分页切换后， 针对 每一页 做不同的 改变, 可 不实现
 */
- (void)changeChildVcCompleteWithIndex:(NSInteger)index;

/**
 切换segment
 
 @param index index description
 */
- (void)changeSegmentWithIndex:(NSInteger)index;


@end
