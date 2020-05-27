# ZJSwipeTableView
一个可以方便实现自定义的tableView的左右侧滑菜单的效果. 支持四种动画效果. 也同时支持了简书的漂亮的侧滑效果.

![swipeTableViewCell.gif](http://upload-images.jianshu.io/upload_images/1271831-e4772b0472eef55d.gif?imageMogr2/auto-orient/strip)


```

- (NSArray<ZJSwipeButton *> *)tableView:(UITableView *)tableView leftSwipeButtonsAtIndexPath:(NSIndexPath *)indexPath {
    ZJSwipeButton *leftBtn = [[ZJSwipeButton alloc] initWithTitle:@"检查1" image:nil onClickHandler:^(UIButton *swipeButton) {
        NSLog(@"点击了检查1: --- %ld", indexPath.row);
        [ZJProgressHUD showStatus:[NSString stringWithFormat:@"点击了检查1: --- %ld", indexPath.row] andAutoHideAfterTime:1];
    }];
    ZJSwipeButton *leftBtn1 = [[ZJSwipeButton alloc] initWithTitle:@"测试2" image:nil onClickHandler:^(UIButton *swipeButton) {
        NSLog(@"点击了测试2: --- %ld", indexPath.row);
        [ZJProgressHUD showStatus:[NSString stringWithFormat:@"点击了测试2: --- %ld", indexPath.row] andAutoHideAfterTime:1];

    }];
    return @[leftBtn,leftBtn1, leftBtn2,leftBtn3];

}
```

> 这是我写的<iOS自定义控件剖析>这本书籍中的一个demo, 如果你希望知道具体的实现过程和其他的一些常用效果的实现, 那么你应该能轻易在网上下载到免费的盗版书籍. 

> 当然作为本书的写作者, 还是希望有人能支持正版书籍. 如果你有意购买书籍, 在[这篇文章中](http://www.jianshu.com/p/510500f3aebd), 介绍了书籍中所有的内容和书籍适合阅读的人群, 和一些试读章节, 以及购买链接. 在你准备[购买](http://www.qingdan.us/product/13)之前, 请一定读一读里面的说明. 否则, 如果不适合你阅读, 虽然书籍售价35不是很贵, 但是也是一笔损失.


> 如果你希望联系到我, 可以通过[简书](http://www.jianshu.com/users/fb31a3d1ec30/latest_articles)联系到我
