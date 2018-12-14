//
//  TableViewSearchHeaderView.m
//  LetterIndexViewDemo
//
//  Created by apple on 2018/6/20.
//  Copyright © 2018年 ms. All rights reserved.
//

#import "TableViewSearchHeaderView.h"

@interface TableViewSearchHeaderView ()

@property (nonatomic, strong) UITextField *searchTextField;

@end

@implementation TableViewSearchHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.searchTextField];
    }
    return self;
}

#pragma mark - getter
- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 5, [UIScreen mainScreen].bounds.size.width - 30, 30)];
        _searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _searchTextField;
}

@end
