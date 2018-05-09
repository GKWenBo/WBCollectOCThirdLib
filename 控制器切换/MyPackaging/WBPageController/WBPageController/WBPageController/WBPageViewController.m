//
//  WBPageViewController.m
//  WBPageController
//
//  Created by wenbo on 2018/5/9.
//  Copyright © 2018年 wenbo. All rights reserved.
//

#import "WBPageViewController.h"

static CGFloat const kSegmentHeight = 44.f;

@interface WBPageViewController () 
{
    WBSegmentPositionStyle _postion;
    NSArray *_titles;
}

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *childVcs;

@end

@implementation WBPageViewController


#pragma mark < 初始化 >
- (instancetype)initWithSegmentTitles:(NSArray <NSString *>*)titles
                             childVcs:(NSArray <UIViewController<WBPageChildVcDelegate> *>*)childVcs
                             position:(WBSegmentPositionStyle)position{
    if (self = [super init]) {
        self.titles = titles;
        self.childVcs = childVcs;
        _postion = position;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    switch (_postion) {
        case WBSegmentPositionNaviStyle:
            {
                self.segementView = [[WBSegmentView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width * 0.8, kSegmentHeight) titleArray:self.titles];
                self.segementView.delegate = self;
                self.navigationItem.titleView = self.segementView;
                
                self.contentView = [[WBPageContentView alloc]initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height + 44, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - 44) parentViewController:self childVcs:self.childVcs];
                self.contentView.delegate = self;
                [self.view addSubview:self.contentView];
            }
            break;
        default:
        {
            self.segementView = [[WBSegmentView alloc]initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height + 44, self.view.bounds.size.width, kSegmentHeight) titleArray:self.titles];
            self.segementView.delegate = self;
            [self.view addSubview:self.segementView];
            
            self.contentView = [[WBPageContentView alloc]initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height + 44 + kSegmentHeight, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - 44 - kSegmentHeight) parentViewController:self childVcs:self.childVcs];
            self.contentView.delegate = self;
            [self.view addSubview:self.contentView];
        }
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark < WBSegmentViewDelegate >
- (void)wbSegmentView:(WBSegmentView *)wbSegmentView didSelectedIndex:(NSInteger)index {
    [self.contentView setContentOffSet:CGPointMake(index * self.view.bounds.size.width, 0) animated:YES];
}

#pragma mark < WBPageContentViewDelegate >
- (void)wbPageContentView:(WBPageContentView *)wbPageContentView didScrollToCurrentIndex:(NSInteger)currentIndex {
    [self.segementView setSelectedIndex:currentIndex animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
