//
//  ViewController.m
//  ReuserSegmentControlDemo
//
//  Created by Admin on 2017/2/15.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "ViewController.h"
#import "ReuseSegmentControl.h"
#import "ViewControllerOne.h"
#import "ViewControllerTwo.h"
#import "ViewControllerThree.h"
/*
 屏幕宽高
 */
#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
/**
 自适应大小
 */
#define AUTOLAYOUTSIZE(size) ((size) * (SCREEN_WIDTH / 375))

/*
 强引用/弱引用
 */
#define WeakSelf(type)  __weak typeof(type) weak##type = type;
#define StrongSelf(type)  __strong typeof(type) type = weak##type;


@interface ViewController ()
@property (nonatomic,strong) ReuseSegmentControl * segmentView;
@property (nonatomic,strong) NSArray * classNames;/**  控制器数组  */
@property (nonatomic,strong) NSArray * segmentTitles;/**  分段控件标题  */
@property (nonatomic,strong) NSMutableDictionary * classDict;/**  保存控制器字典  */
@property (nonatomic,assign) CGRect defaultFrame;/**  自控制器默认大小  */
@property (nonatomic,strong) UIViewController * currentVc;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.segmentView];
    WeakSelf(self)
    [_segmentView.segmentControl setIndexChangeBlock:^(NSInteger index) {
        [weakself changeSegmentWithIndex:index];
    }];
    [self setupDefaultChildVc];
    
}

#pragma mark -- 设置默认子控制器
#pragma mark
- (void)setupDefaultChildVc{
    NSString * className = self.classNames.firstObject;
    UIViewController * vc = self.classDict[className];
    if (!vc) {
        Class c = NSClassFromString(className);
        vc = [[c alloc]init];
        vc.view.frame = [self defaultFrame];
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        
        [self.classDict setValue:vc forKey:className];
        self.currentVc = vc;
    }
}
//下标改变切换控制器
- (void)changeSegmentWithIndex:(NSInteger)index {
    
    [self addChildWithClassName:self.classNames[index]];
}

#pragma mark -- 添加子控制器
#pragma mark
- (void)addChildWithClassName:(NSString *)className {
    UIViewController * vc = self.classDict[className];
    if (!vc) {
        Class c = NSClassFromString(className);
        vc = [[c alloc]init];
        vc.view.frame = [self defaultFrame];
        [self.classDict setValue:vc forKey:className];
    }
    [self replaceController:self.currentVc newController:vc];
}
#pragma mark -- 控制器切换
#pragma mark
/** 控制器切换关键代码 */
- (void)replaceController:(UIViewController *)oldController
            newController:(UIViewController *)newController{
    
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController
                      toViewController:newController
                              duration:0
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:nil completion:^(BOOL finished) {
                                [newController didMoveToParentViewController:self];
                                [oldController removeFromParentViewController];
                                [oldController willMoveToParentViewController:nil];
                                self.currentVc = newController;
                            }];
}

#pragma mark -- getter and setter
#pragma mark
- (NSArray *)segmentTitles {
    if (!_segmentTitles) {
        _segmentTitles = @[@"音乐",
                        @"视频",
                        @"电影"];
    }
    return _segmentTitles;
}
- (NSArray *)classNames {
    if (!_classNames) {
        _classNames = @[@"ViewControllerOne",
                        @"ViewControllerTwo",
                        @"ViewControllerThree"];
    }
    return _classNames;
}
- (ReuseSegmentControl *)segmentView {
    if (!_segmentView) {
        _segmentView = [[ReuseSegmentControl alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 40) titles:self.segmentTitles];
    }
    return _segmentView;
}

- (CGRect)defaultFrame {
    return CGRectMake(0,60, SCREEN_WIDTH, SCREEN_HEIGHT - 20);
}
- (UIViewController *)currentVc {
    if (!_currentVc) {
        _currentVc = [UIViewController new];
    }
    return _currentVc;
}
- (NSMutableDictionary *)classDict {
    if (!_classDict) {
        _classDict = @{}.mutableCopy;
    }
    return _classDict;
}

@end
