//
//  HDRadarView.m
//  LookOtherDemo
//
//  Created by denglibing on 2017/1/11.
//  Copyright © 2017年 denglibing. All rights reserved.
//

#import "HDRadarView.h"

@interface HDRadarView ()
{
    NSInteger radarCurrentCount;
    BOOL    radaring;
}

@property (nonatomic, strong) UIButton *radarBt;
@property (nonatomic, strong) UIView *circleView;

@end

@implementation HDRadarView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _cycleViewBgColor = [UIColor colorWithRed:52 / 255.0 green:143 / 255.0 blue:242 / 255.0 alpha:1.0];
        _radarCount = 10;
        radarCurrentCount = 0;
        _radarDuration = 1;
        _radarAble = YES;
        radaring = NO;
        
        _radarBt = [UIButton buttonWithType:UIButtonTypeCustom];
        _radarBt.frame = CGRectMake(0, 0, 50, 50);
        _radarBt.backgroundColor = [UIColor orangeColor];
        _radarBt.layer.cornerRadius = 25;
        _radarBt.layer.masksToBounds = YES;
        _radarBt.center = self.center;
        [_radarBt addTarget:self action:@selector(xiuxiuAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_radarBt];
        
        _circleView = [self circleView];
        [self insertSubview:_circleView belowSubview:_radarBt];
        _circleView.backgroundColor = _cycleViewBgColor;
        _circleView.layer.borderWidth = 0;
    }
    return self;
}

- (UIView *)circleView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    view.center = self.center;
    
    if (_radarSolid) {
        view.backgroundColor = _cycleViewBgColor;
    }
    else {
        view.backgroundColor = [UIColor clearColor];
        view.layer.borderColor = _cycleViewBgColor.CGColor;
        view.layer.borderWidth = 1;
    }
    
    view.layer.cornerRadius = 50.0;
    view.layer.masksToBounds = YES;
    return view;
}

- (void)xiuxiuAction{
    if (radaring) {
        [self stopXiuxiu];
    }
    else {
        [self startXiuxiu];
    }
    
    radaring = !radaring;
}

- (void)startXiuxiu{
    _circleView.backgroundColor = [UIColor colorWithRed:61 / 255.0 green:107 / 255.0 blue:147 / 255.0 alpha:1.0];
    [self performSelector:@selector(xiuxiuAnimate) withObject:nil afterDelay:0];
}

- (void)xiuxiuAnimate{
    
    if (radarCurrentCount > _radarCount || !_radarAble) {
        radarCurrentCount = 0;
        return ;
    }
    
    CGFloat scale = 8;
    
    UIView *animationView = [self circleView];
    if (_radarSolid) {
        animationView.backgroundColor = _circleView.backgroundColor;
    }
    [self insertSubview:animationView atIndex:0];
    
    [UIView animateWithDuration:5
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         animationView.transform = CGAffineTransformMakeScale(scale, scale);
                         animationView.backgroundColor = self.backgroundColor;
                         animationView.alpha = 0;
                         
                         radarCurrentCount++;
                         [self performSelector:@selector(xiuxiuAnimate) withObject:nil afterDelay:_radarDuration];
                     }
                     completion:^(BOOL finished) {
                         [animationView removeFromSuperview];
                     }];
}

- (void)stopXiuxiu{
    radarCurrentCount = 0;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(xiuxiuAnimate) object:nil];
}

@end
