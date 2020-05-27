//
//  WB_PageContentScrollView.m
//  WB_PageViewControllerDemo1
//
//  Created by WMB on 2017/8/13.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "WBPageContentScrollView.h"
#import "UIView+WBFrame.h"
@interface WBPageContentScrollView () <UIScrollViewDelegate>
/**  < 外界父控制器 >  */
@property (nonatomic,strong) UIViewController * parentViewController;
/**  < 存储子控制器 >  */
@property (nonatomic, strong) NSArray *childViewControllers;
/**  < 容器视图 >  */
@property (nonatomic, strong) UIScrollView *scrollView;
/**  < 记录刚开始时的偏移量 >  */
@property (nonatomic,assign) CGFloat startOffsetX;
@property (nonatomic, assign) BOOL isClickBtn;
/**  < 标记是否默认加载第一个子视图 >  */
@property (nonatomic, assign) BOOL isFirstViewLoaded;
@end

@implementation WBPageContentScrollView

#pragma mark --------  初始化  --------
#pragma mark
- (instancetype)initWithFrame:(CGRect)frame parentVc:(UIViewController *)parentVc childVcs:(NSArray *)childVcs {
    if (self = [super initWithFrame:frame]) {
        self.childViewControllers = childVcs;
        self.parentViewController = parentVc;
        [self defualtConfig];
        [self setupUI];
    }
    return self;
}

+ (instancetype)pageContentScrollViewWithFrame:(CGRect)frame parentVC:(UIViewController *)parentVC childVCs:(NSArray *)childVCs {
    return [[self alloc]initWithFrame:frame parentVc:parentVC childVcs:childVCs];
}

#pragma mark --------  setup  --------
#pragma mark
- (void)defualtConfig {
    self.isClickBtn = YES;
    self.startOffsetX = 0;
    self.isFirstViewLoaded = YES;
}

- (void)setupUI {
    [self addSubview:self.scrollView];
}

#pragma mark --------  UIScrollViewDelegate  --------
#pragma mark
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isClickBtn = NO;
     self.startOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = offsetX / scrollView.frame.size.width;
    UIViewController *vc = self.childViewControllers[index];
    // 判断控制器的view有没有加载过,如果已经加载过,就不需要加载
    if (vc.isViewLoaded) return;
    [self.scrollView addSubview:vc.view];
    vc.view.frame = CGRectMake(offsetX, 0, self.width, self.height);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isClickBtn == YES) {
        [self scrollViewDidEndDecelerating:scrollView];
        return;
    }
    // 1、定义获取需要的数据
    CGFloat progress = 0;
    NSInteger originalIndex = 0;
    NSInteger targetIndex = 0;
    
    // 2、判断是左滑还是右滑
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat scrollViewW = scrollView.bounds.size.width;
    if (currentOffsetX > self.startOffsetX) { // 左滑
        // 1、计算 progress
        progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW);
        // 2、计算 originalIndex
        originalIndex = currentOffsetX / scrollViewW;
        // 3、计算 targetIndex
        targetIndex = originalIndex + 1;
        if (targetIndex >= self.childViewControllers.count) {
            progress = 1;
            targetIndex = self.childViewControllers.count - 1;
        }
        // 4、如果完全划过去
        if (currentOffsetX - self.startOffsetX == scrollViewW) {
            progress = 1;
            targetIndex = originalIndex;
        }
    } else { // 右滑
        // 1、计算 progress
        progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW));
        // 2、计算 targetIndex
        targetIndex = currentOffsetX / scrollViewW;
        // 3、计算 originalIndex
        originalIndex = targetIndex + 1;
        if (originalIndex >= self.childViewControllers.count) {
            originalIndex = self.childViewControllers.count - 1;
        }
    }
    
    // 3、pageContentViewDelegare; 将 progress／sourceIndex／targetIndex 传递给 SGPageTitleView
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageContentScrollView:progress:originalIndex:targetIndex:)]) {
        [self.delegate pageContentScrollView:self progress:progress originalIndex:originalIndex targetIndex:targetIndex];
    }
}

#pragma mark --------  Public Method  --------
#pragma mark
- (void)setPageCententScrollViewCurrentIndex:(NSInteger)currentIndex {
    self.isClickBtn = YES;
    if (self.isFirstViewLoaded && currentIndex == 0) {
        self.isFirstViewLoaded = NO;
        // 2、默认选中第一个子控制器；self.scrollView.contentOffset ＝ 0
        UIViewController *vc = self.childViewControllers[0];
        if (vc.isViewLoaded) return;
        [self.scrollView addSubview:vc.view];
    }
    CGFloat offsetX = currentIndex * self.width;
    self.scrollView.contentOffset = CGPointMake(offsetX, 0);
}

#pragma mark --------  getter and setter  --------
#pragma mark
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(self.width * self.childViewControllers.count, 0);
    }
    return _scrollView;
}
- (void)setIsScrollEnabled:(BOOL)isScrollEnabled {
    _isScrollEnabled = isScrollEnabled;
    if (isScrollEnabled) {
        
    } else {
        self.scrollView.scrollEnabled = NO;
    }
}

@end
