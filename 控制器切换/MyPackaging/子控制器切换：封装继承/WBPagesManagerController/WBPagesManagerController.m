//
//  WBPagesManagerController.m
//  WBPagesManagerController
//
//  Created by WMB on 2017/3/27.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "WBPagesManagerController.h"

/**
 *  屏幕宽高
 */
#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREENH_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds

/**
 *  强/弱应用
 */
#define WeakSelf(type)  __weak typeof(type) weak##type = type;
#define StrongSelf(type)  __strong typeof(type) type = weak##type;

#define Segment_Height 40.f
#define kWBStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
#define kWBNavigationBarHeight 44

@interface WBPagesManagerController ()

@end

@implementation WBPagesManagerController

#pragma mark -- LifeCycle
#pragma mark
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.segmentView];
    [self.view addSubview:self.mainScrollView];
    
    [self.mainScrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    
    
}

#pragma mark -- 初始化
#pragma mark
- (void)initDataSource {
    
}
#pragma mark -- event response
#pragma mark
- (void)changeSegmentWithIndex:(NSInteger)index {
    [self.mainScrollView setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0) animated:YES];
}

#pragma mark -- public method
#pragma mark
- (void)scrollDidStopAddChildVcIfNeed {
    
    NSInteger index = self.mainScrollView.contentOffset.x / SCREEN_WIDTH;
    [self.segmentView.segmentControl setSelectedSegmentIndex:index animated:YES];
    
    NSString * className = self.classNames[index];
    UIViewController * vc = self.allChildsDict[className];
    
    if (!vc) {
        vc = [[NSClassFromString(className) alloc]init];
        vc.view.frame = self.mainScrollView.bounds;
        [self.allChildsDict setObject:vc forKey:className];
        
        [self.mainScrollView addSubview:vc.view];
        [self addChildViewController:vc];
    }
    [self changeChildVcCompleteWithIndex:index];
}

- (void)changeChildVcCompleteWithIndex:(NSInteger)index {
    
}

#pragma mark -- UIScrollViewDelegate
#pragma mark
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:scrollView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollDidStopAddChildVcIfNeed];
}
#pragma mark -- getter and setter
#pragma mark
- (WBPagesReuseSegmentView *)segmentView {
    if (!_segmentView) {
        _segmentView = [[WBPagesReuseSegmentView alloc]initWithFrame:CGRectMake(0, kWBStatusBarHeight + kWBNavigationBarHeight, SCREEN_WIDTH, Segment_Height) titleArray:self.segmentTitles];
        
        
        WeakSelf(self)
        [_segmentView.segmentControl setIndexChangeBlock:^(NSInteger index) {
            [weakself changeSegmentWithIndex:index];
        }];
    }
    return _segmentView;
}
- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentView.frame), SCREEN_WIDTH, SCREENH_HEIGHT - CGRectGetHeight(self.segmentView.bounds) - kWBStatusBarHeight - kWBNavigationBarHeight)];
        _mainScrollView.backgroundColor = [UIColor clearColor];
        _mainScrollView.delegate = self;
        _mainScrollView.scrollsToTop = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.contentOffset = CGPointMake(0, 0);
        _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.classNames.count, 0);
        
        [self scrollDidStopAddChildVcIfNeed];
    }
    return _mainScrollView;
}

- (NSMutableDictionary *)allChildsDict {
    if (!_allChildsDict ) {
        _allChildsDict  = [[NSMutableDictionary alloc]init];
    }
    return _allChildsDict ;
}
- (NSArray *)segmentTitles {
    if (!_segmentTitles) {
        _segmentTitles = [[NSArray alloc]init];
    }
    return _segmentTitles;
}
- (NSArray *)classNames {
    if (!_classNames) {
        _classNames = [[NSArray alloc]init];
    }
    return _classNames;
}
@end
