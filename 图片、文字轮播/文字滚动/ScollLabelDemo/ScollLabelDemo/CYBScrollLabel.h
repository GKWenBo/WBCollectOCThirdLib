//
//  CYBScrollLabel.h
//  scoll
//
//  Created by 曾洪磊 on 2019/2/27.
//  Copyright © 2019 曾洪磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CYBScrollLabel : UIView
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) CGFloat scrollSpeed;// 滚动速度 (初始值为40)
- (void)startScoll;//开始滚动 如果不调用此方法 就是普通的view样式
- (void)destory;//销毁 消除内部的timer方法
@end

NS_ASSUME_NONNULL_END
