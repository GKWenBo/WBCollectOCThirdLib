//
//  TableViewCell.m
//  LetterIndexViewDemo
//
//  Created by imac on 2017/10/12.
//  Copyright © 2017年 ms. All rights reserved.
//

#import "TableViewCell.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

@interface TableViewCell ()

@property (nonatomic, strong) UILabel *brandTitleLabel;

@end

@implementation TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.brandTitleLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    CGSize size = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.brandTitleLabel.font} context:nil].size;
    self.brandTitleLabel.text = title;
    self.brandTitleLabel.frame = CGRectMake(10, (40 - size.height)/2.0, size.width, size.height);
}

#pragma mark - getter
- (UILabel *)brandTitleLabel {
    if (!_brandTitleLabel) {
        _brandTitleLabel = [[UILabel alloc] init];
        _brandTitleLabel.textColor = [UIColor blackColor];
        _brandTitleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _brandTitleLabel;
}

@end
