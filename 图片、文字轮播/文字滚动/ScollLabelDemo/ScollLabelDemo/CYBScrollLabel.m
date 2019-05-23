//
//  CYBScrollLabel.m
//  scoll
//
//  Created by 曾洪磊 on 2019/2/27.
//  Copyright © 2019 曾洪磊. All rights reserved.
//

#import "CYBScrollLabel.h"
@interface CYBScollViewImageView : UIView
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) CGFloat superWidth;
@property (nonatomic, assign) CGFloat superHeight;
@property (nonatomic, assign) BOOL isScoll;
- (UIImageView *)getRangeViewWith:(CGFloat)width;
@end
@implementation CYBScollViewImageView {
    NSInteger strCount;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _text = @"";
        strCount = 1;
        _font = [UIFont systemFontOfSize:15];
        _textColor = [UIColor blackColor];
    }
    return self;
}
- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        _text = @"";
        strCount = 1;
        _font = [UIFont systemFontOfSize:15];
        _textColor = [UIColor blackColor];
    }
    return self;
}
- (void)setText:(NSString *)text {
    _text = text;
    CGSize size = [_text sizeWithAttributes:@{NSFontAttributeName:self.font}];
    CGFloat tempWidth = size.width;
    if (self.isScoll) {
        while (size.width <= self.superWidth - 20) {
            strCount ++;
            size.width += (tempWidth + 20);
        }
    }
    self.frame = CGRectMake(0, (self.superHeight - size.height) * 0.5, size.width, size.height);
    [self setNeedsDisplay];
}
- (void)setFItSize {
    
}
- (void)setFont:(UIFont *)font {
    _font = font;
    [self setNeedsDisplay];
}
- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
    CGSize size = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}];
    for (int i = 0; i < strCount; i ++) {
        [self.text drawInRect:CGRectMake((size.width + 20) * i, 0, size.width, size.height) withAttributes:@{NSFontAttributeName:self.font,NSForegroundColorAttributeName:self.textColor}];
    }
    
}
- (UIImageView *)getRangeViewWith:(CGFloat)width {
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.origin.y, width, self.frame.size.height)];
    UIImage* image = nil;
    if (width == 0 || self.frame.size.height == 0) {
        image = [UIImage new];
    } else {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, self.frame.size.height), NO, [UIScreen mainScreen].scale);
        {
            if (UIGraphicsGetCurrentContext()) {
                [self.layer renderInContext:UIGraphicsGetCurrentContext()];
                image = UIGraphicsGetImageFromCurrentImageContext();
                
            }
        }
        UIGraphicsEndImageContext();
    }
    if (image != nil) {
        imageView.image = image;
        imageView.backgroundColor = [UIColor clearColor];
        return imageView;
    }
    return nil;
}
@end

@interface CYBScrollLabel()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) CYBScollViewImageView *contentView;
@property (nonatomic, strong) UIImageView *scollImageView;
@property (nonatomic, assign) BOOL isScoll;
@end
@implementation CYBScrollLabel
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _text = @"";
        _font = [UIFont systemFontOfSize:15];
        _textColor = [UIColor blackColor];
        self.clipsToBounds = YES;
        self.scrollSpeed = 40;
        self.clipsToBounds = YES;
        self.contentView = [[CYBScollViewImageView alloc]initWithFrame:CGRectZero];
        self.contentView.superWidth = frame.size.width;
        self.contentView.superHeight = frame.size.height;
        [self addSubview:self.contentView];
        self.scollImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self addSubview:self.scollImageView];
    }
    return self;
}
- (void)setText:(NSString *)text {
    _text = text;
    self.contentView.text = text;
}
- (void)setFont:(UIFont *)font {
    _font = font;
    self.contentView.font = font;
}
- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.contentView.textColor = textColor;
}
- (void)startScoll {
    self.isScoll = YES;
    self.contentView.isScoll = YES;
    self.contentView.text = self.text;
    self.timer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(scollo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)scollo {
    CGRect frame = self.contentView.frame;
    CGRect imageFrame = self.scollImageView.frame;
    if (frame.origin.x + frame.size.width <= 0) {
        frame.origin.x = CGRectGetMaxX(imageFrame) + 20;
    } else if (imageFrame.origin.x + imageFrame.size.width <= 0) {
        imageFrame.origin.x = CGRectGetMaxX(frame) + 20;
    }
    //大于本生的宽度减去20的时候
    if (frame.origin.x < imageFrame.origin.x) {
        //滚动在图片的左边
        frame.origin.x -= self.scrollSpeed * 0.01;
        [self.scollImageView removeFromSuperview];
        self.scollImageView = [self.contentView getRangeViewWith:- frame.origin.x];
        CGRect tempImageFrame = self.scollImageView.frame;
        tempImageFrame.origin.x = CGRectGetMaxX(frame) + 20;
        self.scollImageView.frame = tempImageFrame;
        [self addSubview:self.scollImageView];
    } else {
        //滚动在图片的右边
        imageFrame.origin.x -= self.scrollSpeed * 0.01;
        self.scollImageView.frame = imageFrame;
        frame.origin.x = CGRectGetMaxX(imageFrame) + 20;
    }
    self.contentView.frame = frame;
}
- (void)destory {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    for (UIView *sub in self.subviews) {
        [sub removeFromSuperview];
    }
}
@end
