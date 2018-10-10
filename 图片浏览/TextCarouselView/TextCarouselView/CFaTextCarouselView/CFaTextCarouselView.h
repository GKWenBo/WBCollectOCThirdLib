//
//  CFaTextCarouselView.h
//  TextCarouselView
//
//  Created by 纯泽科技 on 2016/11/18.
//  Copyright © 2016年 Focus Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CFaTextCarouselViewDelegate <NSObject>

- (void)delegateSendTapForTextArrsIndex:(NSInteger)index;

@end

typedef NS_ENUM(NSInteger, CFaCarouselDirection) {
    /**竖直方向*/
    CFaCarouselDirectionVertically = 1,
    /**水平方向*/
    CFaCarouselDirectionHorizontally
};

typedef NS_ENUM(NSInteger, CFaCarouselType) {
    /**整页滚动*/
    CFaCarouselTypePagingEnabled = 1,
    /**缓慢滑动*/
    CFaCarouselTypeFlowing
};

@interface CFaTextCarouselView : UIView

@property (nonatomic, assign) id<CFaTextCarouselViewDelegate> delegate;/**<label's tap delegate*/

@property (nonatomic, assign, getter=isCanUserScroll) BOOL canUserScroll;/**<用户是否可滑动*/
@property (nonatomic, assign, getter=isCanUserTap) BOOL canUserTap;/**<用户是否可点击*/
@property (nonatomic, copy) UIFont *textFont;/**<文字字号*/
@property (nonatomic, copy) UIColor *textColor;/**<文字颜色*/
@property (nonatomic, assign) CGFloat scrollDelay;/**<轮播间隔*/

- (instancetype)initWithFrame:(CGRect)frame textArray:(NSArray *)textArr carouselDirection:(CFaCarouselDirection)direction carouselType:(CFaCarouselType)type;

@end
