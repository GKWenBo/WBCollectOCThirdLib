//
//  TableViewHeaderView.m
//  LetterIndexViewDemo
//
//  Created by imac on 2017/10/12.
//  Copyright © 2017年 ms. All rights reserved.
//

#import "TableViewHeaderView.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

@interface TableViewHeaderView ()

@property (nonatomic, strong) UILabel *firstLetterLabel;

@end

@implementation TableViewHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.firstLetterLabel];
        self.contentView.backgroundColor = [[UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.f] colorWithAlphaComponent:0.7];
    }
    return self;
}

- (void)setLetter:(NSString *)letter {
    _letter = letter;
    CGSize size = [letter boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.firstLetterLabel.font} context:nil].size;
    self.firstLetterLabel.text = letter;
    self.firstLetterLabel.frame = CGRectMake(16, (30 - size.height)/2.0, size.width, size.height);
}

#pragma mark - getter
- (UILabel *)firstLetterLabel {
    if (!_firstLetterLabel) {
        _firstLetterLabel = [[UILabel alloc] init];
        _firstLetterLabel.textColor = [UIColor blackColor];
        _firstLetterLabel.font = [UIFont systemFontOfSize:14];
    }
    return _firstLetterLabel;
}

@end
