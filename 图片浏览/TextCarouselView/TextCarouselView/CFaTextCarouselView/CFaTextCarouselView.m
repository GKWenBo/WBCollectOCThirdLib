//
//  CFaTextCarouselView.m
//  TextCarouselView
//
//  Created by 纯泽科技 on 2016/11/18.
//  Copyright © 2016年 Focus Chen. All rights reserved.
//

#import "CFaTextCarouselView.h"

#define DefaultScrollDelay 3.0//默认轮播间隔
#define MinScrollDelay 0.5//最小轮播间隔

#define FlowingScrollDistance 1.0//非整页滚动时每次滑动1像素

@interface CFaTextCarouselView ()<UIScrollViewDelegate>

@end

@implementation CFaTextCarouselView
{
    NSArray *_textArr;/**<轮播资源*/
    CFaCarouselDirection _direction;/**<轮播方向*/
    CFaCarouselType _type;
    
    __weak UIScrollView *_scrollView;/**<轮播滚动视图*/
    __weak UILabel *_lastLabel,/**<上一个Label*/*_thisLabel,/**<当前展示Label*/*_nextLabel;/**<下一个Label*/
    
    NSTimer *_timer;/**<定时器*/
    NSInteger _currentIndex;/**<当前展示Index*/
}

- (void)setCanUserScroll:(BOOL)canUserScroll{
    _scrollView.userInteractionEnabled = canUserScroll;
}

- (void)setCanUserTap:(BOOL)canUserTap{
    _lastLabel.userInteractionEnabled = canUserTap;
    _thisLabel.userInteractionEnabled = canUserTap;
    _nextLabel.userInteractionEnabled = canUserTap;
}

- (void)setTextFont:(UIFont *)textFont{
    _lastLabel.font = textFont;
    _thisLabel.font = textFont;
    _nextLabel.font = textFont;
}

- (void)setTextColor:(UIColor *)textColor{
    _lastLabel.textColor = textColor;
    _thisLabel.textColor = textColor;
    _nextLabel.textColor = textColor;
}

- (void)setScrollDelay:(CGFloat)scrollDelay{
    if (scrollDelay < MinScrollDelay) return;
    _scrollDelay = scrollDelay;
    [self createTimer];
}

- (instancetype)initWithFrame:(CGRect)frame textArray:(NSArray *)textArr carouselDirection:(CFaCarouselDirection)direction carouselType:(CFaCarouselType)type
{
    if (textArr.count < 2) return nil;
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.65];
        
        _textArr = textArr;
        
        _direction = direction;
        
        _type = type;
        
        [self setupScrollView];
    }
    
    return self;
}

/**
 * @title 设置轮播滚动视图
 */
- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView = scrollView;
    [self addSubview:_scrollView];
    
    if (_direction == CFaCarouselDirectionVertically) {
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height * 3);
    } else {
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
    }
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    _scrollView.backgroundColor = [UIColor clearColor];
    
    _scrollView.userInteractionEnabled = NO;//默认用户不可手动滑动
    
    _scrollView.pagingEnabled = NO;//默认不整页滚动
    
    _scrollView.delegate = self;
    
    [self setupThreeLabels];//展示Label
    
    [self setScrollDelay:DefaultScrollDelay];
}

/**
 * @title 设置3TextLabel
 */
- (void)setupThreeLabels
{
    UILabel *lastLabel = [self createLabel:0];
    UILabel *thisLabel = [self createLabel:1];
    UILabel *nextLabel = [self createLabel:2];
    
    _lastLabel = lastLabel;
    _thisLabel = thisLabel;
    _nextLabel = nextLabel;
    
    _lastLabel.backgroundColor = [UIColor clearColor];
    _thisLabel.backgroundColor = [UIColor clearColor];
    _nextLabel.backgroundColor = [UIColor clearColor];
    
    [_scrollView addSubview:_lastLabel];
    [_scrollView addSubview:_thisLabel];
    [_scrollView addSubview:_nextLabel];
    
    [self showTextForLast:_textArr[_textArr.count - 1] this:_textArr[0] next:_textArr[1]];
}
- (UILabel *)createLabel:(NSInteger)index
{
    UILabel *label = [[UILabel alloc] init];
    
    if (_direction == CFaCarouselDirectionHorizontally) {
        label.frame = CGRectMake(_scrollView.frame.size.width * index, 0.0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    } else {
        label.frame = CGRectMake(0.0, _scrollView.frame.size.height * index, _scrollView.frame.size.width, _scrollView.frame.size.height);
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14.f];
    label.textColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labeltaped:)];
    [label addGestureRecognizer:tap];
    
    return label;
}

/**
 * @title Label被点击
 * @param tap 单击手势
 */
- (void)labeltaped:(UITapGestureRecognizer *)tap
{
    UILabel *label = (UILabel *)tap.view;
    
    NSInteger index;
    for (int i = 0; i < _textArr.count; i++) {
        if ([label.text isEqualToString:_textArr[i]]) {
            index = i;
            break;
        }
    }
    NSLog(@"text%li:%@", (long)index, label.text);
    [self.delegate delegateSendTapForTextArrsIndex:index];
}

/**
 * @title Label展示文字
 * @param last 上一文字
 * @param this 当前文字
 * @param next 下一文字
 */
- (void)showTextForLast:(NSString *)last this:(NSString *)this next:(NSString *)next
{
    _lastLabel.text = last;
    _thisLabel.text = this;
    _nextLabel.text = next;
    
    if (_direction == CFaCarouselDirectionHorizontally) {
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0.f)];
    } else {
        [_scrollView setContentOffset:CGPointMake(0.f, _scrollView.frame.size.height)];
    }
}

/**
 * @title 创建定时器
 */
- (void)createTimer
{
    [self removeTimer];
    
    if (_type == CFaCarouselTypeFlowing) {
        CGFloat timeInterval;
        if (_direction == CFaCarouselDirectionHorizontally) {
            timeInterval = self.scrollDelay/(_scrollView.frame.size.width / FlowingScrollDistance);
        } else {
            timeInterval = self.scrollDelay/(_scrollView.frame.size.height / FlowingScrollDistance);
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(scroll) userInfo:nil repeats:YES];
    } else {
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.scrollDelay target:self selector:@selector(scroll) userInfo:nil repeats:YES];
    }
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

/**
 * @title 移除定时器
 */
- (void)removeTimer
{
    if (_timer == nil) return;
    [_timer invalidate];
    _timer = nil;
}

/**
 * @title 轮播滚动
 */
- (void)scroll
{
    if (_type == CFaCarouselTypePagingEnabled) {
        if (_direction == CFaCarouselDirectionHorizontally) {
            [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x + _scrollView.frame.size.width, 0.0) animated:YES];
        } else {
            [_scrollView setContentOffset:CGPointMake(0.0, _scrollView.contentOffset.y + _scrollView.frame.size.height) animated:YES];
        }
    } else {
        if (_direction == CFaCarouselDirectionHorizontally) {
            //每次滑动一定像素
            [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x + FlowingScrollDistance, 0.0)];
        } else {
            //每次滑动一定像素
            [_scrollView setContentOffset:CGPointMake(0.0, _scrollView.contentOffset.y + FlowingScrollDistance)];
        }
    }
}

/**
 * scrollView滚动(手动、自动都会调用此方法)
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_direction == CFaCarouselDirectionHorizontally) {
        [self doAfterScroll:scrollView.contentOffset.x];
    } else {
        [self doAfterScroll:scrollView.contentOffset.y];
    }
}

/**
 * @title 滚动响应事件
 * @param xy 滚动所在的x或y坐标
 */
- (void)doAfterScroll:(CGFloat)xy
{
    if (_direction == CFaCarouselDirectionHorizontally) {
        if (xy >= _scrollView.frame.size.width * 2) {
            _currentIndex++;
            if (_currentIndex == _textArr.count-1) {
                [self showTextForLast:_textArr[_currentIndex-1] this:_textArr[_currentIndex] next:_textArr[0]];
            } else if (_currentIndex == _textArr.count) {
                _currentIndex = 0;
                [self showTextForLast:_textArr[_textArr.count-1] this:_textArr[_currentIndex] next:_textArr[_currentIndex+1]];
            } else {
                [self showTextForLast:_textArr[_currentIndex-1] this:_textArr[_currentIndex] next:_textArr[_currentIndex+1]];
            }
        }
        
        if (xy <= 0.0) {
            _currentIndex--;
            if (_currentIndex == 0) {
                [self showTextForLast:_textArr[_textArr.count-1] this:_textArr[_currentIndex] next:_textArr[_currentIndex+1]];
            } else if (_currentIndex == -1) {
                _currentIndex = _textArr.count - 1;
                [self showTextForLast:_textArr[_currentIndex-1] this:_textArr[_currentIndex] next:_textArr[0]];
            } else {
                [self showTextForLast:_textArr[_currentIndex-1] this:_textArr[_currentIndex] next:_textArr[_currentIndex+1]];
            }
        }
    } else {
        if (xy >= _scrollView.frame.size.height * 2) {
            _currentIndex++;
            if (_currentIndex == _textArr.count-1) {
                [self showTextForLast:_textArr[_currentIndex-1] this:_textArr[_currentIndex] next:_textArr[0]];
            } else if (_currentIndex == _textArr.count) {
                _currentIndex = 0;
                [self showTextForLast:_textArr[_textArr.count-1] this:_textArr[_currentIndex] next:_textArr[_currentIndex+1]];
            } else {
                [self showTextForLast:_textArr[_currentIndex-1] this:_textArr[_currentIndex] next:_textArr[_currentIndex+1]];
            }
        }
        
        if (xy <= 0.0) {
            _currentIndex--;
            if (_currentIndex == 0) {
                [self showTextForLast:_textArr[_textArr.count-1] this:_textArr[_currentIndex] next:_textArr[_currentIndex+1]];
            } else if (_currentIndex == -1) {
                _currentIndex = _textArr.count - 1;
                [self showTextForLast:_textArr[_currentIndex-1] this:_textArr[_currentIndex] next:_textArr[0]];
            } else {
                [self showTextForLast:_textArr[_currentIndex-1] this:_textArr[_currentIndex] next:_textArr[_currentIndex+1]];
            }
        }
    }
}

/**
 * 即将开始拖动时(移除定时器)
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //滚动时长太短,跳出方法
    if (_scrollDelay < MinScrollDelay) return;
    //移除定时器
    [self removeTimer];
}

/**
 * 已经完成拖动后(设置定时器)
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //滚动时长太短,跳出方法
    if (_scrollDelay < MinScrollDelay) return;
    //设置定时器
    [self createTimer];
}

- (void)dealloc{
    [self removeTimer];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
