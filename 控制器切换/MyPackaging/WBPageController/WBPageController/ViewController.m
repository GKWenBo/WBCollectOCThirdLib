//
//  ViewController.m
//  WBPageController
//
//  Created by wenbo on 2018/5/9.
//  Copyright © 2018年 wenbo. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"
@interface ViewController ()

@end

@implementation ViewController

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        self.showOnNavigationBar = NO;
//        self.selectedIndex = 2;
//        self.titleNormalColor = [UIColor grayColor];
//        self.titleSelectedColor = [UIColor blackColor];
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.showOnNavigationBar = YES;
    self.titleNormalColor = [UIColor grayColor];
    self.titleSelectedColor = [UIColor blackColor];
    self.selectedIndex = 2;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)wb_numberChildViewControllrs:(WBPageViewController *)pageController {
    return 3;
}

- (NSArray<NSString *> *)wb_numberOfTitlesInPageController:(WBPageViewController *)pageController {
    return @[@"1",
             @"2",
             @"3"];
}

- (UIViewController *)wb_pageController:(WBPageViewController *)pageController reuseViewController:(UIViewController *)reuseViewController viewControllerAtIndex:(NSInteger)index {
    TestViewController *vc = (TestViewController *)reuseViewController;
    if (!vc) {
        vc = [[TestViewController alloc]init];
    }
    return vc;
}

@end
