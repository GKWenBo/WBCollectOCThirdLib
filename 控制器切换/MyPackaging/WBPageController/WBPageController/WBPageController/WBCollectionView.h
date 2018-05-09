//
//  WBCollectionView.h
//  WBPageController
//
//  Created by wenbo on 2018/5/9.
//  Copyright © 2018年 wenbo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WBCollectionView : UICollectionView

typedef BOOL(^WBScrollViewShouldBeginPanGestureHandler)(WBCollectionView *collectionView,UIPanGestureRecognizer *panGesture);

- (void)setupScrollViewShouldBeginPanGestureHandler:(WBScrollViewShouldBeginPanGestureHandler)handler;

@end
