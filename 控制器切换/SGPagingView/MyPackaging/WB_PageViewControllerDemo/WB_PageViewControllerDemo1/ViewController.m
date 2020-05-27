//
//  ViewController.m
//  WB_PageViewControllerDemo1
//
//  Created by WMB on 2017/8/12.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "ViewController.h"
#import "OneViewController.h"
#import "TwoViewController.h"
#import "ThreeViewController.h"
#import "FourViewController.h"
#import "FiveViewController.h"
#import "SixViewController.h"

#import "WBPageSegmentedView.h"
#import "WBPageContentView.h"
#import "WBPageContentScrollView.h"

#import "PageViewDemoVcViewController.h"
@interface ViewController () 
//@property (nonatomic, strong) WB_PageSegmentedView *pageTitleView;
//@property (nonatomic, strong) WB_PageContentScrollView *pageContentView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSArray *titleArr = @[@"精选精选", @"电影精选精选", @"电视剧", @"综艺", @"NBA精选", @"娱乐唱会"];
//    self.pageTitleView = [WB_PageSegmentedView pageTitleViewWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 44) delegate:self titleArray:titleArr];
//    _pageTitleView.isTitleGradientEffect = NO;
//    _pageTitleView.indicatorLengthStyle = WB_IndicatorLengthEqualStyle;
//    _pageTitleView.indicatorScrollStyle = WB_IndicatorScrollDefaultStyle;
////    _pageTitleView.selectedIndex = 1;
////    _pageTitleView.isNeedBounces = NO;
////    _pageTitleView.isShowIndicator = NO;
////    _pageTitleView.isTitleGradientEffect = YES;
////    _pageTitleView.titleTextScaling = 0.3;
////    _pageTitleView.isOpenTitleTextZoom = YES;
////    _pageTitleView.isShowBottomSeparator = YES;
////    _pageTitleView.indicatorHeight = 6;
//    [self.view addSubview:self.pageTitleView];
//    
//    OneViewController * oneVc = [OneViewController new];
//    TwoViewController * twoVc = [TwoViewController new];
//    ThreeViewController * threeVc = [ThreeViewController new];
//    FourViewController * fourVc = [FourViewController new];
//    FiveViewController* fiveVc = [FiveViewController new];
//    SixViewController * sixVc = [SixViewController new];
//    
//    NSArray *childArr = @[oneVc, twoVc, threeVc, fourVc,fiveVc,sixVc];
//    CGFloat contentViewHeight = self.view.frame.size.height - 108;
//    self.pageContentView = [[WB_PageContentScrollView alloc] initWithFrame:CGRectMake(0, 108, self.view.frame.size.width, contentViewHeight) parentVc:self childVcs:childArr];
//    _pageContentView.delegate = self;
//    [self.view addSubview:_pageContentView];
}

- (IBAction)net:(id)sender {
    OneViewController * oneVc = [OneViewController new];
    TwoViewController * twoVc = [TwoViewController new];
    ThreeViewController * threeVc = [ThreeViewController new];
    FourViewController * fourVc = [FourViewController new];
    FiveViewController* fiveVc = [FiveViewController new];
    SixViewController * sixVc = [SixViewController new];
    NSArray *titleArr = @[@"精选精选", @"电影精选精选", @"电视剧", @"综艺", @"NBA精选", @"娱乐唱会"];
    NSArray *childArr = @[oneVc, twoVc, threeVc, fourVc,fiveVc,sixVc];
    PageViewDemoVcViewController *vc = [PageViewDemoVcViewController pageViewControllerWithChildVcs:childArr titleArray:titleArr positionStyle:WBSegmentPositonNavigationBarStyle];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark --------  WB_PageContentViewDelegate  --------
//#pragma mark
//- (void)pageContentView:(WB_PageContentView *)pageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
//    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
//}
//
//#pragma mark --------  WB_PageSegmentedViewDelegate  --------
//#pragma mark
//- (void)pageTitleView:(WB_PageSegmentedView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
//    [self.pageContentView setPageCententScrollViewCurrentIndex:selectedIndex];
//}
//
//#pragma mark --------  WB_PageContentScrollViewDelegate  --------
//#pragma mark
//- (void)pageContentScrollView:(WB_PageContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
//    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
//}

@end
