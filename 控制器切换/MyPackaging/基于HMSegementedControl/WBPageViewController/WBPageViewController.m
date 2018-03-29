//
//  WB_PageViewController.m
//  WB_PageViewController
//
//  Created by WMB on 2017/8/12.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "WBPageViewController.h"

@interface WBPageViewController () <UIScrollViewDelegate>

@end

@implementation WBPageViewController

#pragma mark -- LifeCycle
#pragma mark
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self defaultConfig];
    [self initializeDataSource];
    [self initializeUserInterface];
    [self setupCustomUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Initialize
#pragma mark
/**  初始化数据  */
- (void)initializeDataSource {
    
}
/**  初始化界面  */
- (void)initializeUserInterface {

}

#pragma mark --------  WB_ReuseSegmentedViewDelegate  --------
#pragma mark
- (void)wb_reuseSegmentedView:(WBReuseSegmentedView *)wb_reuseSegmentedView selectedIndex:(NSInteger)selectedIndex {
    [self.mainScrollView setContentOffset:CGPointMake(selectedIndex * CGRectGetWidth(self.mainScrollView.bounds), 0) animated:YES];
}

#pragma mark --------  UIScrollViewDelegate  --------
#pragma mark
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x  / CGRectGetWidth(self.mainScrollView.bounds);
    [self setCurrentChildViewControllerWithIndex:index];
    /**  < 调整分段控件 >  */
    [self.segmentView.segmentedControl setSelectedSegmentIndex:index animated:YES];
}

#pragma mark -- Private Method
#pragma mark
- (void)defaultConfig {
    self.segmentHeight = 40.f;
    self.segmentLocation = WBSegmentLocationSubViewStyle;
    self.srollEnabled = YES;
}

- (void)setupCustomUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    /**  < 处理手势冲突 >  */
    [self.mainScrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    NSAssert(self.childViewControllers.count != 0, @"请添加子控制器");
    NSAssert(self.titleArray.count != 0, @"请设置标题");
    NSAssert(self.childViewControllers.count == self.titleArray.count, @"控制器个数与标题个数不相等");
    switch (self.segmentLocation) {
        case WBSegmentLocationNavigationBarStyle:
            self.navigationItem.titleView = self.segmentView;
            break;
        case WBSegmentLocationSubViewStyle:
            [self.view addSubview:self.segmentView];
            break;
        default:
            break;
    }
    [self.view addSubview:self.mainScrollView];
    /**  < 设置默认控制器 >  */
    [self setDefaultChildVc];
}

- (void)setDefaultChildVc {
    UIViewController *vc = self.childViewControllers.firstObject;
    vc.view.frame = self.mainScrollView.bounds;
    [self addChildViewController:vc];
    [self.mainScrollView addSubview:vc.view];
    _currentDisplayController = vc;
    _currentIndex = 0;
}

- (void)setCurrentChildViewControllerWithIndex:(NSInteger)index {
    UIViewController *vc = self.childViewControllers[index];
    if (vc.isViewLoaded) {
        return;
    }
    vc.view.frame = self.mainScrollView.bounds;
    [self addChildViewController:vc];
    [self.mainScrollView addSubview:vc.view];
    _currentDisplayController = vc;
    _currentIndex = index;
}

#pragma mark -- Getter and Setter
#pragma mark
- (WBReuseSegmentedView *)segmentView {
    if (!_segmentView) {
        CGRect frame;
        switch (self.segmentLocation) {
            case WBSegmentLocationNavigationBarStyle:
                frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) * 0.8, self.segmentHeight);
                break;
            case WBSegmentLocationSubViewStyle:
                frame = CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), self.segmentHeight);
                break;
            default:
                break;
        }
        _segmentView = [[WBReuseSegmentedView alloc]initWithFrame:frame titleArray:self.titleArray];
        _segmentView.backgroundColor = [UIColor orangeColor];
        _segmentView.delegate = self;
    }
    return _segmentView;
}
- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        CGRect frame;
        switch (self.segmentLocation) {
            case WBSegmentLocationSubViewStyle:
                frame = CGRectMake(0, CGRectGetMaxY(self.segmentView.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.segmentView.bounds) - 64);
                break;
            case WBSegmentLocationNavigationBarStyle:
                frame = CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 64);
                break;
            default:
                break;
        }
        _mainScrollView = [[UIScrollView alloc]initWithFrame:frame];
        /**  < 关闭回弹 >  */
        _mainScrollView.bounces = NO;
        _mainScrollView.backgroundColor = [UIColor clearColor];
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.delegate = self;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.scrollEnabled = self.srollEnabled;
        /**  < 内容大小 >  */
        _mainScrollView.contentSize = CGSizeMake(self.childViewControllers.count * CGRectGetWidth(self.view.bounds), 0);
    }
    return _mainScrollView;
}

@end
