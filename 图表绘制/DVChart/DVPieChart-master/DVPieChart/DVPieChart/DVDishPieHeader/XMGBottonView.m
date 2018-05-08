//
//  XMGBottonView.m
//  DVPieChart
//
//  Created by machao on 2018/4/27.
//  Copyright © 2018年 Fire. All rights reserved.
//

#import "XMGBottonView.h"
#import "Masonry.h"

@interface XMGBottonView()

@property (nonatomic, strong) UIView *iconView;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation XMGBottonView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    _iconView = [[UIView alloc] init];
    _iconView.backgroundColor = [UIColor redColor];
    [self addSubview:_iconView];
    
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@(20));
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"小马哥测试";
    [self addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconView.mas_right).offset(10);
        make.centerY.equalTo(_iconView);
        make.right.equalTo(self.mas_right).offset(-5);
    }];
}

-(void)setIconColor:(UIColor *)iconColor{
    _iconColor = iconColor;
    _iconView.backgroundColor = iconColor;
}

@end
