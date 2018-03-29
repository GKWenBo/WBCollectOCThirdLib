//
//  UIView+WB_Frame.h
//  WB_CommonUtility
//
//  Created by WMB on 2017/5/14.
//  Copyright © 2017年 文波. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIView (WBFrame)

@property (nonatomic,assign) CGFloat left;        ///< Shortcut for frame.origin.x.
@property (nonatomic,assign) CGFloat top;         ///< Shortcut for frame.origin.y
@property (nonatomic,assign) CGFloat right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic,assign) CGFloat bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic,assign) CGFloat width;       ///< Shortcut for frame.size.width.
@property (nonatomic,assign) CGFloat height;      ///< Shortcut for frame.size.height.
@property (nonatomic,assign) CGFloat centerX;     ///< Shortcut for center.x
@property (nonatomic,assign) CGFloat centerY;     ///< Shortcut for center.y
@property (nonatomic,assign) CGPoint origin;      ///< Shortcut for frame.origin.
@property (nonatomic,assign) CGSize  size;        ///< Shortcut for frame.size.
/**  < 最大x值 >  */
@property (nonatomic,assign) CGFloat maxX;
/**  < 最大值 >  */
@property (nonatomic,assign) CGFloat maxY;
@end
