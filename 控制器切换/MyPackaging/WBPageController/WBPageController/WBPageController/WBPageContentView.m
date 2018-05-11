//
//  WBPageContentView.m
//  WBPageController
//
//  Created by wenbo on 2018/5/10.
//  Copyright © 2018年 wenbo. All rights reserved.
//

#import "WBPageContentView.h"
#import "WBCollectionView.h"

#define kWBWeakObjc(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
#define kWBStrongObjc(o) autoreleasepool{} __strong typeof(o) o = o##Weak;

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
@property (weak, nonatomic) UIViewController *parentViewController;
/** < 所有子控制器 >  */
@property (nonatomic, strong) NSMutableDictionary <NSNumber *,UIViewController *>*childVcsDict;
/** < 当前下标 >  */
@property (nonatomic, assign) NSInteger currentIndex;
/** < 上个下标 >  */
@property (nonatomic, assign) NSInteger oldIndex;
/** < 滚动超过页面(直接设置contentOffSet导致) >  */
@property (nonatomic, assign) BOOL scrollOverOnePage;
/** < 当这个属性设置为YES的时候 就不用处理 scrollView滚动的计算 >  */
@property (assign, nonatomic) BOOL forbidTouchToAdjustPosition;
/** < 子控制器个数 >  */
@property (nonatomic, assign) NSInteger childVcCount;

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
- (instancetype)initWithFrame:(CGRect)frame parentViewController:(UIViewController *)parentViewController delegate:(id<WBPageContentViewDelegate>)delegate {
    if (self = [super initWithFrame:frame]) {
        self.delegate = delegate;
        self.parentViewController = parentViewController;
        [self wb_commonInit];
    }
    return self;
}

- (void)wb_commonInit {
    _oldIndex = -1;
    _currentIndex = 0;
    _oldOffSetX = 0.0f;
    _forbidTouchToAdjustPosition = NO;
    _isLoadFirstView = YES;
    _selectedIndex = 0;
    _isNeedBounce = NO;
    _sysVersion = [[[UIDevice currentDevice] systemVersion] integerValue];
    
    if (_delegate && [_delegate respondsToSelector:@selector(numberOfChildViewControllers:)]) {
        self.childVcCount = [_delegate numberOfChildViewControllers:self];
    }
    
    [self addNotification];
    [self wb_dealGestureConflict];
    [self wb_addCollectionView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.currentChildVc) {
        self.currentChildVc.view.frame = self.bounds;
    }
}

#pragma mark < Private Method >
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMemoryWarningHander) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

- (void)wb_dealGestureConflict {
    UINavigationController *nav = (UINavigationController *)self.parentViewController.parentViewController;
    if ([nav isKindOfClass:[UINavigationController class]]) {
        if (nav.viewControllers.count == 1) {
            return;
        }
        if (nav.interactivePopGestureRecognizer) {
            [self.collectionView setupScrollViewShouldBeginPanGestureHandler:^BOOL(WBCollectionView *collectionView, UIPanGestureRecognizer *panGesture) {
                CGFloat transionX = [panGesture translationInView:panGesture.view].x;
                if (collectionView.contentOffset.x == 0 && transionX > 0) {
                    nav.interactivePopGestureRecognizer.enabled = YES;
                }
                else {
                    nav.interactivePopGestureRecognizer.enabled = NO;
                }
                return YES;
            }];
        }
    }
}

+ (void)removeChildVc:(UIViewController *)childVc {
    [childVc willMoveToParentViewController:nil];
    [childVc.view removeFromSuperview];
    [childVc removeFromParentViewController];
}

- (void)wb_addCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = self.bounds.size;
    flowLayout.minimumLineSpacing = 0.f;
    flowLayout.minimumInteritemSpacing = 0.f;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout = flowLayout;
    
    WBCollectionView *collectonview = [[WBCollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flowLayout];
    collectonview.delegate = self;
    collectonview.dataSource = self;
    collectonview.backgroundColor = [UIColor whiteColor];
    collectonview.pagingEnabled = YES;
    collectonview.scrollsToTop = NO;
    collectonview.bounces = _isNeedBounce;
    collectonview.showsHorizontalScrollIndicator = NO;
    [collectonview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kIdentifier];
    if (@available(iOS 11.0,*)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self addSubview:collectonview];
    self.collectionView = collectonview;
}

- (void)setupChildVcForCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    _currentChildVc = [self.childVcsDict objectForKey:@(indexPath.item)];
    
    if (_delegate && [_delegate respondsToSelector:@selector(pageContentView:reuseViewController:viewControllerAtIndex:)]) {
        if (_currentChildVc == nil) {
            _currentChildVc = [_delegate pageContentView:self reuseViewController:nil viewControllerAtIndex:indexPath.item];
            _currentChildVc.wb_currentIndex = indexPath.item;
            [self.childVcsDict setObject:_currentChildVc forKey:@(indexPath.item)];
        }else {
            [_delegate pageContentView:self reuseViewController:_currentChildVc viewControllerAtIndex:indexPath.item];
        }
    }else {
        NSAssert(NO, @"必须设置代理和实现代理方法");
    }
    /** < 这里建立子控制器和父控制器的关系 >  */
    if ([_currentChildVc isKindOfClass:[UINavigationController class]]) {
        NSAssert(NO, @"不要添加UINavigationController包装后的子控制器");
    }
    if (_currentChildVc.parentViewController != self.parentViewController) {
        [self.parentViewController addChildViewController:_currentChildVc];
    }
    _currentChildVc.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:_currentChildVc.view];
    [_currentChildVc didMoveToParentViewController:self.parentViewController];
}

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

#pragma mark < 通知 >
- (void)receiveMemoryWarningHander {
    @kWBWeakObjc(self)
    [self.childVcsDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIViewController * _Nonnull obj, BOOL * _Nonnull stop) {
        @kWBStrongObjc(self)
        if (obj != _currentChildVc) {
            [WBPageContentView removeChildVc:obj];
            [self.childVcsDict removeObjectForKey:key];
        }
    }];
}

#pragma mark < UICollectionViewDelegate,UICollectionViewDataSource >
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.childVcCount;
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
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentIndex = (scrollView.contentOffset.x / self.bounds.size.width);
    if (_delegate && [_delegate respondsToSelector:@selector(pageContentView:didScrollToIndex:)]) {
        [_delegate pageContentView:self didScrollToIndex:currentIndex];
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


#pragma mark < Public Method >
- (void)reload {
    [self.childVcsDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIViewController * _Nonnull obj, BOOL * _Nonnull stop) {
        [WBPageContentView removeChildVc:obj];
        obj = nil;
    }];
    self.childVcsDict = nil;
    [self wb_commonInit];
    [self.collectionView reloadData];
    [self setContentOffSet:CGPointZero animated:NO];
}

#pragma mark < setter >
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (_selectedIndex == selectedIndex) {
        return;
    }
    _selectedIndex = selectedIndex;
    [self setContentOffSet:CGPointMake(selectedIndex * self.collectionView.bounds.size.width, 0) animated:NO];
}

- (void)setIsNeedBounce:(BOOL)isNeedBounce {
    if (_isNeedBounce == isNeedBounce) {
        return;
    }
    _isNeedBounce = isNeedBounce;
    self.collectionView.bounces = isNeedBounce;
}

#pragma mark < Getter >
- (NSMutableDictionary<NSNumber *,UIViewController *> *)childVcsDict {
    if (!_childVcsDict) {
        _childVcsDict = @{}.mutableCopy;
    }
    return _childVcsDict;
}

@end
