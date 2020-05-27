//
//  WB_PageViewController.m
//  WB_PageViewControllerDemo1
//
//  Created by WMB on 2017/8/13.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "WBPageViewController.h"

@interface WBPageViewController () <WB_PageSegmentedViewDelegate,WB_PageContentViewDelegate>
{
    NSArray *_titleArray;
    NSArray *_childVcs;
    WBSegmentPositonStyle _positionStyle;
}
@end

@implementation WBPageViewController
#pragma mark -- Life Cycle
#pragma mark
- (instancetype)initWithChildVcs:(NSArray *)childVcs titleArray:(NSArray *)titleArray positionStyle:(WBSegmentPositonStyle)positionStyle {
    if (self = [super init]) {
        _titleArray = titleArray;
        _childVcs = childVcs;
        _positionStyle = positionStyle;
        [self defaultConfig];
    }
    return self;
}

+ (instancetype)pageViewControllerWithChildVcs:(NSArray *)childVcs titleArray:(NSArray<NSString *> *)titleArray positionStyle:(WBSegmentPositonStyle)positionStyle {
    return [[self alloc]initWithChildVcs:childVcs titleArray:titleArray positionStyle:positionStyle];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self defaultConfig];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark -- WB_PageSegmentedViewDelegate
#pragma mark
- (void)pageTitleView:(WBPageSegmentedView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentView setPageCententViewCurrentIndex:selectedIndex];
}

#pragma mark -- WB_PageContentViewDelegate
#pragma mark
- (void)pageContentView:(WBPageContentView *)pageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.segmentedView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

#pragma mark -- Private Method
#pragma mark
- (void)defaultConfig {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    switch (_positionStyle) {
        case WBSegmentPositonSubViewStyle:
            [self.view addSubview:self.segmentedView];
            break;
        case WBSegmentPositonNavigationBarStyle:
            self.navigationItem.titleView = self.segmentedView;
            break;
        default:
            break;
    }
    [self.view addSubview:self.pageContentView];
}

#pragma mark -- Getter And Setter
#pragma mark
- (WBPageSegmentedView *)segmentedView {
    if (!_segmentedView) {
        CGRect frame;
        switch (_positionStyle) {
            case WBSegmentPositonNavigationBarStyle:
                frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 100, 44);
                break;
            case WBSegmentPositonSubViewStyle:
                frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 44);
                break;
            default:
                break;
        }
        _segmentedView = [WBPageSegmentedView pageTitleViewWithFrame:frame delegate:self titleArray:_titleArray];
    }
    return _segmentedView;
}

- (WBPageContentView *)pageContentView {
    if (!_pageContentView) {
        CGRect frame;
        switch (_positionStyle) {
            case WBSegmentPositonNavigationBarStyle:
                frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
                break;
            case WBSegmentPositonSubViewStyle:
                frame = CGRectMake(0, CGRectGetMaxY(self.segmentedView.frame), [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(self.segmentedView.frame));
                break;
            default:
                break;
        }
        _pageContentView = [WBPageContentView pageContentViewWithFrame:frame parentVc:self childVcs:_childVcs];
        _pageContentView.delegate = self;
    }
    return _pageContentView;
}

@end
