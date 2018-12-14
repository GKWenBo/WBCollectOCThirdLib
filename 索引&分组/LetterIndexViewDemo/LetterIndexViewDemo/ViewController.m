//
//  ViewController.m
//  LetterIndexViewDemo
//
//  Created by imac on 2017/10/12.
//  Copyright © 2017年 ms. All rights reserved.
//

#import "ViewController.h"

#import "NSString+PinYin.h"

#import "IndexView.h"
#import "TableViewHeaderView.h"
#import "TableViewSearchHeaderView.h"
#import "TableViewCell.h"

#define NAV_HEIGHT 64
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

static NSString *TableViewHeaderViewIdentifier = @"TableViewHeaderViewIdentifier";
static NSString *TableViewCellIdentifier = @"TableViewCellIdentifier";
static NSString *TableViewSearchHeaderViewIdentifier = @"TableViewSearchHeaderViewIdentifier";

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, IndexViewDelegate, IndexViewDataSource>

@property (nonatomic, strong) UITableView *demoTableView;
@property (nonatomic, strong) IndexView *indexView;

@property (nonatomic, copy) NSArray *dataSourceArray;                           /**< 数据源数组 */
@property (nonatomic, strong) NSMutableArray *brandArray;                       /**< 品牌名数组 */
@property (nonatomic, assign) BOOL isSearchMode;                                /**< 是否有搜索栏  */

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //解析数据
    NSMutableArray *tempBrandArray = [NSMutableArray array];
    for (NSString *brandName in self.dataSourceArray) {
        [tempBrandArray addObject:brandName];
    }
    //获取拼音首字母
    NSArray *indexArray= [tempBrandArray arrayWithPinYinFirstLetterFormat];
    self.brandArray = [NSMutableArray arrayWithArray:indexArray];
    
    //添加搜索视图
    self.isSearchMode = YES;
    NSMutableDictionary *searchDic = [NSMutableDictionary dictionary];
    [searchDic setObject:[NSMutableArray array] forKey:@"content"];
    [self.brandArray insertObject:searchDic atIndex:0];
    
    //添加视图
    [self.view addSubview:self.demoTableView];
    [self.view addSubview:self.indexView];
    //默认设置第一组
    [self.indexView setSelectionIndex:0];
}

#pragma mark - 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.brandArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dict = self.brandArray[section];
    NSMutableArray *array = dict[@"content"];
    return [array count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //搜索头视图
    if (section == 0 && self.isSearchMode) {
        return 40;
    }
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //搜索头视图
    if (section == 0 && self.isSearchMode) {
        TableViewSearchHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:TableViewSearchHeaderViewIdentifier];
        return headerView;
    }
    
    TableViewHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:TableViewHeaderViewIdentifier];
    headerView.letter = self.brandArray[section][@"firstLetter"];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
    NSDictionary *dict = self.brandArray[indexPath.section];
    NSMutableArray *array = dict[@"content"];
    //品牌
    NSString *brandInfo = array[indexPath.row];
    cell.title = brandInfo;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    [self.indexView tableView:tableView willDisplayHeaderView:view forSection:section];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    [self.indexView tableView:tableView didEndDisplayingHeaderView:view forSection:section];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.indexView scrollViewDidScroll:scrollView];
}

#pragma mark - IndexView
- (NSArray<NSString *> *)sectionIndexTitles {
    //搜索符号  [NSMutableArray arrayWithObject:UITableViewIndexSearch]; [NSMutableArray array];
    NSMutableArray *resultArray = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
    for (NSDictionary *dict in self.brandArray) {
        NSString *title = dict[@"firstLetter"];
        if (title) {
            [resultArray addObject:title];
        }
    }
    return resultArray;
}

//当前选中组
- (void)selectedSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    if (self.isSearchMode && (index == 0)) {
        //搜索视图头视图(这里不能使用scrollToRowAtIndexPath，因为搜索组没有cell)
        [self.demoTableView setContentOffset:CGPointZero animated:NO];
        return;
    }
    [self.demoTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

//将指示器视图添加到当前视图上
- (void)addIndicatorView:(UIView *)view {
    [self.view addSubview:view];
}

#pragma mark - getter
- (UITableView *)demoTableView {
    if (!_demoTableView) {
        _demoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:(UITableViewStylePlain)];
        _demoTableView.delegate = self;
        _demoTableView.dataSource = self;
        _demoTableView.showsVerticalScrollIndicator = NO;
        
        [_demoTableView registerClass:[TableViewHeaderView class] forHeaderFooterViewReuseIdentifier:TableViewHeaderViewIdentifier];
        [_demoTableView registerClass:[TableViewCell class] forCellReuseIdentifier:TableViewCellIdentifier];
        [_demoTableView registerClass:[TableViewSearchHeaderView class] forHeaderFooterViewReuseIdentifier:TableViewSearchHeaderViewIdentifier];
    }
    return _demoTableView;
}

- (IndexView *)indexView {
    if (!_indexView) {
        _indexView = [[IndexView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30, NAV_HEIGHT, 30, SCREEN_HEIGHT - NAV_HEIGHT)];
        _indexView.delegate = self;
        _indexView.dataSource = self;
    }
    return _indexView;
}

- (NSArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = @[@"卡地亚", @"法兰克穆勒", @"尊皇", @"蒂芙尼", @"艾米龙", @"NOMOS", @"依波路", @"波尔", @"帝舵", @"名士", @"芝柏", @"积家", @"尼芙尔", @"泰格豪雅", @"艾美", @"拉芙兰瑞", @"宝格丽", @"古驰", @"香奈儿", @"迪奥", @"雷达", @"豪利时", @"路易.威登", @"蕾蒙威", @"康斯登", @"爱马仕", @"昆仑", @"斯沃琪", @"WEMPE", @"万宝龙", @"浪琴", @"柏莱士", @"雅克德罗", @"雅典", @"帕玛强尼", @"格拉苏蒂原创", @"伯爵", @"百达翡丽", @"爱彼", @"宝玑", @"江诗丹顿", @"宝珀", @"理查德·米勒", @"梵克雅宝", @"罗杰杜彼", @"萧邦", @"百年灵", @"宝齐莱", @"瑞宝", @"沛纳海", @"宇舶", @"真力时", @"万国", @"欧米茄", @"劳力士", @"朗格"];
    }
    return _dataSourceArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
