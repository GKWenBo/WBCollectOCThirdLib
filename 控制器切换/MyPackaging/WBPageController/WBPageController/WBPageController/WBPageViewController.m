//
//  WBPageViewController.m
//  WBPageController
//
//  Created by wenbo on 2018/5/9.
//  Copyright © 2018年 wenbo. All rights reserved.
//

#import "WBPageViewController.h"

static CGFloat const kSegmentHeight = 44.f;
static NSString *kIdentifier = @"CELLID";

#define kWBWeakObjc(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
#define kWBStrongObjc(o) autoreleasepool{} __strong typeof(o) o = o##Weak;

@interface WBPageViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
{
    CGRect _menuViewFrame,_contentViewFrame;
    CGFloat   _oldOffSetX;
    BOOL _isLoadFirstView;
    NSInteger _sysVersion;
}

/** < 用于处理重用和内容的显示 >  */
@property (nonatomic, strong) WBCollectionView *collectionView;
/** < collectionView的布局 >  */
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
/** < 所有子控制器 >  */
@property (nonatomic, strong) NSMutableDictionary <NSNumber *,UIViewController *>*childVcsDict;
/** < 当前下标 >  */
@property (nonatomic, assign) NSInteger currentIndex;
/** < 上个下标 >  */
@property (nonatomic, assign) NSInteger oldIndex;
/** < 标题数组 >  */
@property (nonatomic, strong) NSArray *titleArray;
/** < 滚动超过页面(直接设置contentOffSet导致) >  */
@property (nonatomic, assign) BOOL scrollOverOnePage;
/** < 当这个属性设置为YES的时候 就不用处理 scrollView滚动的计算 >  */
@property (assign, nonatomic) BOOL forbidTouchToAdjustPosition;
/** < 子控制器个数 >  */
@property (nonatomic, assign) NSInteger childVcCount;

@end

@implementation WBPageViewController


#pragma mark < Dealloc >
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if DEBUG
    NSLog(@"ZJContentView---销毁");
#endif
    
}

#pragma mark < 初始化 >

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self wb_commonInit];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
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
    _sysVersion = [[[UIDevice currentDevice] systemVersion] integerValue];
    _showOnNavigationBar = NO;

    self.delegate = self;
    
    if (_delegate && [_delegate respondsToSelector:@selector(wb_numberChildViewControllrs:)]) {
        self.childVcCount = [_delegate wb_numberChildViewControllrs:self];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(wb_numberOfTitlesInPageController:)]) {
        self.titleArray = [_delegate wb_numberOfTitlesInPageController:self];
    }
    
    [self addNotification];
    [self wb_dealGestureConflict];
}

#pragma mark < Life Cycle >
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self wb_calculateSize];
    [self wb_addMenuView];
    [self wb_addCollectionView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!self.childVcCount) {
        return;
    }
    [self forceLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark < Private Method >
- (void)wb_calculateSize {
    if (_delegate && [_delegate respondsToSelector:@selector(pageController:preferredFrameForMenuView:)]) {
        _menuViewFrame = [_delegate pageController:self preferredFrameForMenuView:self.segementView];
    }else {
        CGFloat originY = (self.showOnNavigationBar && self.navigationController.navigationBar) ? 0 : CGRectGetMaxY(self.navigationController.navigationBar.frame);
        _menuViewFrame = CGRectMake(0, originY, self.view.frame.size.width, kSegmentHeight);
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(pageController:preferredFrameForContentView:)]) {
        _contentViewFrame = [_delegate pageController:self preferredFrameForContentView:self.collectionView];
    }else {
        CGFloat originY = (self.showOnNavigationBar && self.navigationController.navigationBar) ? CGRectGetMaxY(self.navigationController.navigationBar.frame) : CGRectGetMaxY(_menuViewFrame);
        CGFloat tabBarHeight = self.tabBarController.tabBar && !self.tabBarController.tabBar.hidden ? self.tabBarController.tabBar.frame.size.height : 0;
        CGFloat sizeHeight = self.view.frame.size.height - tabBarHeight - originY;
        _contentViewFrame = CGRectMake(0, originY, self.view.frame.size.width, sizeHeight);
    }
}

- (void)wb_addCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = _contentViewFrame.size;
    flowLayout.minimumLineSpacing = 0.f;
    flowLayout.minimumInteritemSpacing = 0.f;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout = flowLayout;
    
    WBCollectionView *collectonview = [[WBCollectionView alloc]initWithFrame:_contentViewFrame collectionViewLayout:flowLayout];
    collectonview.delegate = self;
    collectonview.dataSource = self;
    collectonview.backgroundColor = [UIColor whiteColor];
    collectonview.pagingEnabled = YES;
    collectonview.scrollsToTop = NO;
    collectonview.bounces = YES;
    collectonview.showsHorizontalScrollIndicator = NO;
    [collectonview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kIdentifier];
    if (@available(iOS 11.0,*)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview:collectonview];
    self.collectionView = collectonview;
}

- (void)wb_addMenuView {
    WBSegmentView *segementView = [[WBSegmentView alloc]initWithFrame:_menuViewFrame titleArray:self.titleArray];
    segementView.delegate = self;
    self.segementView = segementView;
    
    if (self.showOnNavigationBar && self.navigationController.navigationBar) {
        self.navigationItem.titleView = self.segementView;
    }else {
        [self.view addSubview:self.segementView];
    }
}

- (void)forceLayoutSubviews {
    if (!self.childVcCount) {
        return;
    }
    [self wb_calculateSize];
    [self wb_adjustMenuViewFrame];
    [self wb_adjustCollectionViewFrame];
    [self wb_adjustDisplayingViewControllersFrame];
}

- (void)wb_adjustCollectionViewFrame {
    CGFloat oldContentOffsetX = self.collectionView.contentOffset.x;
    CGFloat contentWidth = self.collectionView.contentSize.width;
    self.collectionView.frame = _contentViewFrame;
    CGFloat xContentOffset = contentWidth == 0 ? self.currentIndex * _contentViewFrame.size.width : oldContentOffsetX / contentWidth * self.childVcCount * _contentViewFrame.size.width;
    [self.collectionView setContentOffset:CGPointMake(xContentOffset, 0)];
}

- (void)wb_adjustDisplayingViewControllersFrame {
    [self.childVcsDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIViewController * _Nonnull obj, BOOL * _Nonnull stop) {
        obj.view.frame = _contentViewFrame;
    }];
}

- (void)wb_adjustMenuViewFrame {
    self.segementView.frame = _menuViewFrame;
    [self.segementView wb_resetFrame:_menuViewFrame];
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMemoryWarningHander) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

- (void)setupChildVcForCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    _currentChildVc = [self.childVcsDict objectForKey:@(indexPath.item)];
    
    if (_delegate && [_delegate respondsToSelector:@selector(wb_pageController:reuseViewController:viewControllerAtIndex:)]) {
        if (_currentChildVc == nil) {
            _currentChildVc = [_delegate wb_pageController:self reuseViewController:nil viewControllerAtIndex:indexPath.item];
            _currentChildVc.wb_currentIndex = indexPath.item;
            [self.childVcsDict setObject:_currentChildVc forKey:@(indexPath.item)];
        }else {
            [_delegate wb_pageController:self reuseViewController:_currentChildVc viewControllerAtIndex:indexPath.item];
        }
    }else {
        NSAssert(NO, @"必须设置代理和实现代理方法");
    }
    /** < 这里建立子控制器和父控制器的关系 >  */
    if ([_currentChildVc isKindOfClass:[UINavigationController class]]) {
        NSAssert(NO, @"不要添加UINavigationController包装后的子控制器");
    }
    if (_currentChildVc.parentViewController != self) {
        [self addChildViewController:_currentChildVc];
    }
    _currentChildVc.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:_currentChildVc.view];
    [_currentChildVc didMoveToParentViewController:self.parentViewController];
    
}

+ (void)removeChildVc:(UIViewController *)childVc {
    [childVc willMoveToParentViewController:nil];
    [childVc.view removeFromSuperview];
    [childVc removeFromParentViewController];
}

- (void)wb_dealGestureConflict {
    UINavigationController *nav = (UINavigationController *)self.parentViewController;
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

- (void)setContentOffSet:(CGPoint)offset animated:(BOOL)animated {
    self.forbidTouchToAdjustPosition = YES;
    
    NSInteger currentIndex = offset.x / self.collectionView.bounds.size.width;
    _oldIndex = _currentIndex;
    self.currentIndex = currentIndex;
    [self.segementView setSelectedIndex:self.currentIndex animated:NO];
    _scrollOverOnePage = NO;
    
    NSInteger page = labs(_currentIndex-_oldIndex);
    if (page >= 2) {// 需要滚动两页以上的时候, 跳过中间页的动画
        _scrollOverOnePage = YES;
    }
    [self.collectionView setContentOffset:offset animated:animated];
}


#pragma mark < Public Method >
- (void)reload {
    [self.childVcsDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIViewController * _Nonnull obj, BOOL * _Nonnull stop) {
        [WBPageViewController removeChildVc:obj];
        obj = nil;
    }];
    self.childVcsDict = nil;
    [self wb_commonInit];
    [self forceLayoutSubviews];
    [self.collectionView reloadData];
    [self setContentOffSet:CGPointZero animated:NO];

}

#pragma mark < 通知 >
- (void)receiveMemoryWarningHander {
    @kWBWeakObjc(self)
    [self.childVcsDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIViewController * _Nonnull obj, BOOL * _Nonnull stop) {
        @kWBStrongObjc(self)
        if (obj != _currentChildVc) {
            [WBPageViewController removeChildVc:obj];
            [self.childVcsDict removeObjectForKey:key];
        }
    }];
}

#pragma mark < WBSegmentViewDelegate >
- (void)wbSegmentView:(WBSegmentView *)wbSegmentView didSelectedIndex:(NSInteger)index {
    [self setContentOffSet:CGPointMake(index * self.view.bounds.size.width, 0) animated:YES];
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
    CGFloat tempProgress = scrollView.contentOffset.x / self.view.bounds.size.width;
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
    NSInteger currentIndex = (scrollView.contentOffset.x / self.view.bounds.size.width);
    [self.segementView setSelectedIndex:currentIndex animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _oldOffSetX = scrollView.contentOffset.x;
    self.forbidTouchToAdjustPosition = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    UINavigationController *navi = (UINavigationController *)self.parentViewController;
    if ([navi isKindOfClass:[UINavigationController class]] && navi.interactivePopGestureRecognizer) {
        navi.interactivePopGestureRecognizer.enabled = YES;
    }
}

#pragma mark < getter >

- (NSMutableDictionary<NSNumber *,UIViewController *> *)childVcsDict {
    if (!_childVcsDict) {
        _childVcsDict = @{}.mutableCopy;
    }
    return _childVcsDict;
}

- (void)setShowOnNavigationBar:(BOOL)showOnNavigationBar {
    if (_showOnNavigationBar == showOnNavigationBar) {
        return;
    }
    _showOnNavigationBar = showOnNavigationBar;
    if (self.segementView) {
        [self.segementView removeFromSuperview];
        [self wb_addMenuView];
        [self forceLayoutSubviews];
        [self.segementView setSelectedIndex:self.currentIndex animated:YES];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (_selectedIndex == selectedIndex) {
        return;
    }
    _selectedIndex = selectedIndex;
    [self setContentOffSet:CGPointMake(selectedIndex * self.collectionView.bounds.size.width, 0) animated:NO];
    [self.segementView setSelectedIndex:selectedIndex animated:NO];
}

- (void)setTitleNormalColor:(UIColor *)titleNormalColor {
    _titleNormalColor = titleNormalColor;
    self.segementView.normalColor = titleNormalColor;
}

- (void)setTitleSelectedColor:(UIColor *)titleSelectedColor {
    _titleSelectedColor = titleSelectedColor;
    self.segementView.selectedColor = titleSelectedColor;
}

- (void)setTitleNormalFont:(UIFont *)titleNormalFont {
    _titleNormalFont = titleNormalFont;
    self.segementView.normalFont = titleNormalFont;
}

- (void)setTitleSelectedFont:(UIFont *)titleSelectedFont {
    _titleSelectedFont = titleSelectedFont;
    self.segementView.selectedFont = titleSelectedFont;
}

@end
