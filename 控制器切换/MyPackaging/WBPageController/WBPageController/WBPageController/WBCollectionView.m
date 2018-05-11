//
//  WBCollectionView.m
//  WBPageController
//
//  Created by wenbo on 2018/5/9.
//  Copyright © 2018年 wenbo. All rights reserved.
//

#import "WBCollectionView.h"

@interface WBCollectionView ()

@property (nonatomic, copy) WBScrollViewShouldBeginPanGestureHandler gestureBeginHandler;

@end

@implementation WBCollectionView

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (_gestureBeginHandler && gestureRecognizer == self.panGestureRecognizer) {
        return _gestureBeginHandler(self, (UIPanGestureRecognizer *)gestureRecognizer);
    }else {
        return [super gestureRecognizerShouldBegin:gestureRecognizer];
    }
}

- (void)setupScrollViewShouldBeginPanGestureHandler:(WBScrollViewShouldBeginPanGestureHandler)handler {
    _gestureBeginHandler = [handler copy];
}

/** < 处理全屏返回冲突 >  */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.contentOffset.x <= 0) {
        if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"_FDFullscreenPopGestureRecognizerDelegate")]) {
            return YES;
        }
    }
    return NO;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
