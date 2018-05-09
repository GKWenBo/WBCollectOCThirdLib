//
//  WBScrollPageView.m
//  WBPageController
//
//  Created by wenbo on 2018/5/9.
//  Copyright © 2018年 wenbo. All rights reserved.
//

#import "WBPageContentView.h"

static NSString *kIdentifier = @"CELLID";

@interface WBPageContentView () <UICollectionViewDelegate,UICollectionViewDataSource>
{
    CGFloat   _oldOffSetX;
    BOOL _isLoadFirstView;
    NSInteger _sysVersion;
}

/** < 用于处理重用和内容的显示 >  */
@property (nonatomic, strong) WBCollectionView *collectionView;
/** < collectionView的布局 >  */
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
/** < 父类 用于处理添加子控制器  使用weak避免循环引用 >  */
@property (nonatomic, weak) UIViewController *parentViewController;
/** < 所有子控制器 >  */
@property (nonatomic, strong) NSMutableArray <UIViewController<WBPageChildVcDelegate> *>*childVcs;
/** < 当前下标 >  */
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger oldIndex;
/** < 是否需要手动管理生命周期方法的调用 >  */
@property (nonatomic, assign) BOOL needManageLifeCycle;
/** < 滚动超过页面(直接设置contentOffSet导致) >  */
@property (nonatomic, assign) BOOL scrollOverOnePage;
/** < 当这个属性设置为YES的时候 就不用处理 scrollView滚动的计算 >  */
@property (assign, nonatomic) BOOL forbidTouchToAdjustPosition;

@end

@implementation WBPageContentView


#pragma mark < Dealloc >
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if DEBUG
    NSLog(@"ZJContentView---销毁");
#endif

}

#pragma mark < 初始化 >
- (instancetype)initWithFrame:(CGRect)frame
         parentViewController:(UIViewController *)parentViewController
                     childVcs:(NSArray<UIViewController<WBPageChildVcDelegate> *> *)childVcs {
    if (self = [super initWithFrame:frame]) {
        self.parentViewController = parentViewController;
        _needManageLifeCycle = [parentViewController shouldAutomaticallyForwardAppearanceMethods];
        [self.childVcs removeAllObjects];
        [self.childVcs addObjectsFromArray:childVcs];
        if (!_needManageLifeCycle) {
#if DEBUG
            NSLog(@"\n请注意: 如果你希望所有的子控制器的view的系统生命周期方法被正确的调用\n请重写%@的'shouldAutomaticallyForwardAppearanceMethods'方法 并且返回NO\n当然如果你不做这个操作, 子控制器的生命周期方法将不会被正确的调用\n如果你仍然想利用子控制器的生命周期方法, 请使用'ZJScrollPageViewChildVcDelegate'提供的代理方法\n或者'ZJScrollPageViewDelegate'提供的代理方法", [parentViewController class]);
#endif
        }
        [self commonInit];
        [self addSubview:self.collectionView];
        
        [self addNotification];
    }
    return self;
}

#pragma mark < Private Method >
- (void)commonInit {
    _oldIndex = -1;
    _currentIndex = 0;
    _oldOffSetX = 0.0f;
    _isLoadFirstView = YES;
    _sysVersion = [[[UIDevice currentDevice] systemVersion] integerValue];
    
    /** < 添加控制器 >  */
//    [self.childVcs enumerateObjectsUsingBlock:^(UIViewController<WBPageChildVcDelegate> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [self.parentViewController addChildViewController:obj];
//    }];
    
    UINavigationController *nav = (UINavigationController *)self.parentViewController.parentViewController;
    if ([nav isKindOfClass:[UINavigationController class]]) {
        if (nav.viewControllers.count == 1) return;
        if (nav.interactivePopGestureRecognizer) {
            [self.collectionView setupScrollViewShouldBeginPanGestureHandler:^BOOL(WBCollectionView *collectionView, UIPanGestureRecognizer *panGesture) {
                CGFloat transionX = [panGesture translationInView:panGesture.view].x;
                if (collectionView.contentOffset.x == 0 && transionX > 0) {
                    nav.interactivePopGestureRecognizer.enabled = YES;
                }else {
                    nav.interactivePopGestureRecognizer.enabled = NO;
                }
                return YES;
            }];
        }
    }
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMemoryWarningHander) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

- (void)setupChildVcForCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    _currentChildVc = self.childVcs[indexPath.item];
    if (_currentChildVc.wb_pageViewController != self.parentViewController) {
        [self.parentViewController addChildViewController:_currentChildVc];
        _currentChildVc.wb_currentIndex = indexPath.item;
    }
    
    /** < 这里建立子控制器和父控制器的关系 >  */
    if ([_currentChildVc isKindOfClass:[UINavigationController class]]) {
        NSAssert(NO, @"不要添加UINavigationController包装后的子控制器");
    }
    _currentChildVc.view.frame = cell.contentView.bounds;
    if (indexPath.item == 0) {
        _currentChildVc.view.backgroundColor = [UIColor redColor];

    }else {
        _currentChildVc.view.backgroundColor = [UIColor orangeColor];

    }
        [cell.contentView addSubview:_currentChildVc.view];
    [_currentChildVc didMoveToParentViewController:self.parentViewController];
    
    if (_isLoadFirstView) { // 第一次加载cell? 不会调用endDisplayCell
        [self willAppearWithIndex:indexPath.item];
        [self didAppearWithIndex:indexPath.item];
        _isLoadFirstView = NO;
    }
    else {
        [self willAppearWithIndex:indexPath.item];
        [self willDisappearWithIndex:_oldIndex];
    }
}

+ (void)removeChildVc:(UIViewController *)childVc {
    [childVc willMoveToParentViewController:nil];
    [childVc.view removeFromSuperview];
    [childVc removeFromParentViewController];
}

- (void)contentViewDidMoveFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    
}

- (void)didAppearWithIndex:(NSInteger)index {
    UIViewController<WBPageChildVcDelegate> *controller = self.childVcs[index];
    if (controller) {
        if ([controller respondsToSelector:@selector(wb_viewDidAppearForIndex:)]) {
            [controller wb_viewDidAppearForIndex:index];
        }
        if (_needManageLifeCycle) {
            [controller endAppearanceTransition];
        }
    }
}

- (void)didDisappearWithIndex:(NSInteger)index {
    UIViewController<WBPageChildVcDelegate> *controller = self.childVcs[index];
    if (controller) {
        if ([controller respondsToSelector:@selector(wb_viewDidDisappearForIndex:)]) {
            [controller wb_viewDidDisappearForIndex:index];
        }
        if (_needManageLifeCycle) {
            [controller endAppearanceTransition];
        }
    }
}

- (void)willAppearWithIndex:(NSInteger)index {
    UIViewController<WBPageChildVcDelegate> *controller = self.childVcs[index];
    if (controller) {
        if ([controller respondsToSelector:@selector(wb_viewWillAppearForIndex:)]) {
            [controller wb_viewWillAppearForIndex:index];
        }
        if (_needManageLifeCycle) {
            [controller beginAppearanceTransition:YES animated:NO];
        }
        
    }
}

- (void)willDisappearWithIndex:(NSInteger)index {
    UIViewController<WBPageChildVcDelegate> *controller = self.childVcs[index];
    if (controller) {
        if ([controller respondsToSelector:@selector(wb_viewWillDisappearForIndex:)]) {
            [controller wb_viewWillDisappearForIndex:index];
        }
        if (_needManageLifeCycle) {
            [controller beginAppearanceTransition:NO animated:NO];
            
        }
    }
}

// 处理当前子控制器的生命周期 : 已知问题, 当push的时候会被调用两次
- (void)willMoveToWindow:(nullable UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    if (newWindow == nil) {
        [self willDisappearWithIndex:_currentIndex];
    }
    else {
        [self willAppearWithIndex:_currentIndex];
    }
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    if (self.window == nil) {
        [self didDisappearWithIndex:_currentIndex];
    }
    else {
        [self didAppearWithIndex:_currentIndex];
    }
}

#pragma mark < Public Method >
- (void)setContentOffSet:(CGPoint)offset animated:(BOOL)animated {
    self.forbidTouchToAdjustPosition = YES;
    NSInteger currentIndex = offset.x / self.collectionView.bounds.size.width;
    _oldIndex = _currentIndex;
    self.currentIndex = currentIndex;
    _scrollOverOnePage = NO;
    
    NSInteger page = labs(_currentIndex-_oldIndex);
    if (page >= 2) {// 需要滚动两页以上的时候, 跳过中间页的动画
        _scrollOverOnePage = YES;
    }
    
    [self.collectionView setContentOffset:offset animated:animated];
}

- (void)reload {
    [self.childVcs enumerateObjectsUsingBlock:^(UIViewController<WBPageChildVcDelegate> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [WBPageContentView removeChildVc:obj];
        obj = nil;
    }];
    self.childVcs = nil;
    [self commonInit];
    [self.collectionView reloadData];
    [self setContentOffSet:CGPointZero animated:NO];
}

#pragma mark < Noti >
- (void)receiveMemoryWarningHander {
    [self.childVcs enumerateObjectsUsingBlock:^(UIViewController<WBPageChildVcDelegate> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj != self.currentChildVc) {
            [self.childVcs removeObject:obj];
            [WBPageContentView removeChildVc:obj];
        }
    }];
}

#pragma mark < UICollectionViewDelegate,UICollectionViewDataSource >
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.childVcs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kIdentifier forIndexPath:indexPath];
    /** < 移除subviews 避免重用内容显示错误 >  */
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (_sysVersion < 8) {
        [self setupChildVcForCell:cell atIndexPath:indexPath];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_sysVersion >= 8) {
        [self setupChildVcForCell:cell atIndexPath:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.forbidTouchToAdjustPosition) {
        if (_currentIndex == indexPath.item) {
            /** < 没有滚动完成 >  */
            if (_needManageLifeCycle) {
                UIViewController <WBPageChildVcDelegate>*currentVc = self.childVcs[_oldIndex];
                /** < 开始出现 >  */
                [currentVc beginAppearanceTransition:YES animated:NO];
                
                UIViewController <WBPageChildVcDelegate>*oldVc = self.childVcs[indexPath.item];
                /** < 开始消失 >  */
                [oldVc beginAppearanceTransition:NO animated:NO];
            }
            [self didAppearWithIndex:_oldIndex];
            [self didDisappearWithIndex:indexPath.item];
        }else {
            if (_oldIndex == indexPath.item) {
                /** < 滚动完成 >  */
                [self didAppearWithIndex:_currentIndex];
                [self didDisappearWithIndex:indexPath.item];
            }else {
                /** < 滚动没有完成又快速的反向打开了另一页 >  */
                if (_needManageLifeCycle) {
                    UIViewController <WBPageChildVcDelegate>*currentVc = self.childVcs[_oldIndex];
                    /** < 开始出现 >  */
                    [currentVc beginAppearanceTransition:YES animated:NO];
                    
                    UIViewController <WBPageChildVcDelegate>*oldVc = self.childVcs[indexPath.item];
                    /** < 开始消失 >  */
                    [oldVc beginAppearanceTransition:NO animated:NO];
                }
                [self didAppearWithIndex:_oldIndex];
                [self didDisappearWithIndex:indexPath.item];
            }
        }
    }else {
        if (_scrollOverOnePage) {
            if (labs(_currentIndex - indexPath.item) == 1) {
                /** < 滚动完成 >  */
                [self didAppearWithIndex:_currentIndex];
                [self didDisappearWithIndex:_oldIndex];
            }
        }else {
            [self didDisappearWithIndex:_oldIndex];
            [self didAppearWithIndex:_currentIndex];
        }
    }
}

#pragma mark < UIScrollViewDelegate >
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.forbidTouchToAdjustPosition || // 点击标题滚动
        scrollView.contentOffset.x <= 0 || // first or last
        scrollView.contentOffset.x >= scrollView.contentSize.width - scrollView.bounds.size.width) {
        return;
    }
    CGFloat tempProgress = scrollView.contentOffset.x / self.bounds.size.width;
    NSInteger tempIndex = tempProgress;

    CGFloat progress = tempProgress - floor(tempProgress);
    CGFloat deltaX = scrollView.contentOffset.x - _oldOffSetX;

    if (deltaX > 0) {// 向左
        if (progress == 0.0) {
            return;
        }
        self.currentIndex = tempIndex+1;
        self.oldIndex = tempIndex;
    }
    else if (deltaX < 0) {
        progress = 1.0 - progress;
        self.oldIndex = tempIndex+1;
        self.currentIndex = tempIndex;

    }
    else {
        return;
    }
    [self contentViewDidMoveFromIndex:_oldIndex toIndex:_currentIndex progress:progress];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentIndex = (scrollView.contentOffset.x / self.bounds.size.width);
    if (_delegate && [_delegate respondsToSelector:@selector(wbPageContentView:didScrollToCurrentIndex:)]) {
        [_delegate wbPageContentView:self didScrollToCurrentIndex:currentIndex];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _oldOffSetX = scrollView.contentOffset.x;
    self.forbidTouchToAdjustPosition = NO;
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    UINavigationController *navi = (UINavigationController *)self.parentViewController.parentViewController;
    if ([navi isKindOfClass:[UINavigationController class]] && navi.interactivePopGestureRecognizer) {
        navi.interactivePopGestureRecognizer.enabled = YES;
    }
}

#pragma mark < getter >
- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.itemSize = self.bounds.size;
        _flowLayout.minimumLineSpacing = 0.f;
        _flowLayout.minimumInteritemSpacing = 0.f;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

- (WBCollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[WBCollectionView alloc]initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollsToTop = NO;
        _collectionView.bounces = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kIdentifier];
        if (@available(iOS 11.0,*)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _collectionView;
}

- (NSMutableArray<UIViewController<WBPageChildVcDelegate> *> *)childVcs {
    if (!_childVcs) {
        _childVcs = @[].mutableCopy;
    }
    return _childVcs;
}

@end
