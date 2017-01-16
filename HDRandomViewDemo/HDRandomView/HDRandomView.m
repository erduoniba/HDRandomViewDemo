//
//  HDRandomView.m
//  LookOtherDemo
//
//  Created by denglibing on 2017/1/11.
//  Copyright © 2017年 denglibing. All rights reserved.
//

#import "HDRandomView.h"

typedef struct {
    CGPoint center;
    CGFloat radius;
} CircleInfo;

@interface HDRandomView ()

//先生成一系列的标准圆 （相互不重叠 & 包含在大圆内部 & 不在中圆内部且不重叠）, 默认生成 10 个
@property (nonatomic, strong) NSMutableArray <UIView *>*randomCicleView;

@property (nonatomic, strong) UIView *middleView;

@end

@implementation HDRandomView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _middleScale = 3/5.0;
        _minRadius = 30;
        _raduisRange = 40;
        _randomCicleView = @[].mutableCopy;
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = self.frame.size.width / 2;
        
        _middleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width * _middleScale, self.frame.size.height * _middleScale)];
        _middleView.center = self.center;
        _middleView.backgroundColor = [UIColor orangeColor];
        _middleView.layer.cornerRadius = _middleView.frame.size.width / 2;
        [self addSubview:_middleView];
    }
    return self;
}

- (void)setMiddleScale:(CGFloat)middleScale{
    _middleScale = middleScale;
    
    _middleView.frame = CGRectMake(0, 0, self.frame.size.width * _middleScale, self.frame.size.height * _middleScale);
    _middleView.center = self.center;
    _middleView.layer.cornerRadius = _middleView.frame.size.width / 2;
}


- (NSMutableArray *)generateRandomView:(NSInteger)count{
    
    CGFloat totalCount = 0;
    CGFloat bigCircleAccordCount = 0;
    CGFloat middleCircleAccordCount = 0;
    NSMutableArray *randomCircleInfos = @[].mutableCopy;
    
    while (randomCircleInfos.count < count) {
        
        totalCount++;
        
        NSInteger randomWidth = _minRadius + arc4random() % _raduisRange;
        NSInteger randomCPX = arc4random() % (int)self.frame.size.width;
        NSInteger randomCPY = arc4random() % (int)self.frame.size.height;
        
        CGFloat R = self.frame.size.width / 2;
        CGFloat Rr = R * _middleScale;
        CGFloat r = randomWidth / 2;
        
        // 1: 判断随机生成的 圆 包含在 self 这个大圆内部
        if ( sqrt(pow(self.center.x - randomCPX, 2) + pow(self.frame.size.height / 2 - randomCPY, 2)) < (R - r) ) {
            
            bigCircleAccordCount++;
            
            // 2: 判断随机生成的 圆 不在 中间 这个圆 不能重合， 即得到两个圆之间的小圆
            if (sqrt(pow(self.center.x - randomCPX, 2) + pow(self.frame.size.height / 2 - randomCPY, 2)) > (Rr + r)) {
                
                middleCircleAccordCount++;
                
                if (randomCircleInfos.count == 0) {
                    [randomCircleInfos addObject:[self standardCircle:randomCPX centerY:randomCPY radius:r]];
                }
                else {
                    // 3: 新生成的 圆 和已经存在的 圆 不能重合
                    BOOL success = YES;
                    for (NSValue *value in randomCircleInfos) {
                        CircleInfo circle;
                        [value getValue:&circle];
                        
                        // 只要新生成的 圆 和 任何一个存在的 圆 有交集，则失败
                        if (sqrt(pow(circle.center.x - randomCPX, 2) + pow(circle.center.y - randomCPY, 2)) <= (circle.radius + r)) {
                            success = NO;
                            break ;
                        }
                    }
                    
                    if (success) {
                        [randomCircleInfos addObject:[self standardCircle:randomCPX centerY:randomCPY radius:r]];
                    }
                }
                
            }
        }
    }
    
    NSLog(@"\n为了寻找 %d 个标准圆 \n一共生成了 %d 个随机圆 \n生成了 %d 个在大圆内部的圆 \n生成了 %d 个在大圆内部的圆且不与中圆有交集的圆 \n", (int)count, (int)totalCount, (int)bigCircleAccordCount, (int)middleCircleAccordCount);
    
    return randomCircleInfos;
}

- (NSValue *)standardCircle:(CGFloat)randomCPX centerY:(CGFloat)randomCPY radius:(CGFloat)radius{
    CircleInfo newCircle;
    newCircle.center = CGPointMake(randomCPX, randomCPY);
    newCircle.radius = radius;
    NSValue *value = [NSValue valueWithBytes:&newCircle objCType:@encode(CircleInfo)];
    return value;
}

- (void)reloadDataAnimated:(BOOL)animated{
    if (_hdDataSource &&
        [_hdDataSource respondsToSelector:@selector(numberOfRandomViewInHDRandomView:)] &&
        [_hdDataSource respondsToSelector:@selector(hdRandomView:randomViewAtIndex:)]) {
        
        NSInteger randomViewCount = [_hdDataSource numberOfRandomViewInHDRandomView:self];
        NSMutableArray *randomCircleInfos = [self generateRandomView:randomViewCount]; //生成制定的 标准圆
        
        [_randomCicleView enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        
        for (int i=0; i<randomViewCount; i++) {
            CircleInfo circle;
            NSValue *value = randomCircleInfos[i];
            [value getValue:&circle];
            
            UIView *randomView = [_hdDataSource hdRandomView:self randomViewAtIndex:i];
            randomView.tag = i;
            randomView.frame = CGRectMake(0, 0, circle.radius * 2, circle.radius * 2);
            randomView.center = circle.center;
            randomView.layer.cornerRadius = circle.radius;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(randomViewAction:)];
            [randomView addGestureRecognizer:tap];
            [self addSubview:randomView];
            [_randomCicleView addObject:randomView];
            
            if (animated) {
                randomView.alpha = 0;
                NSInteger index = [randomCircleInfos indexOfObject:value];
                [UIView animateWithDuration:0.6
                                      delay:index * 0.3
                                    options:UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     randomView.transform = CGAffineTransformMakeScale(1.2, 1.2);
                                     randomView.alpha = 0.5;
                                 }
                                 completion:^(BOOL finished) {
                                     [UIView animateWithDuration:0.6 animations:^{
                                         randomView.transform = CGAffineTransformMakeScale(1, 1);
                                         randomView.alpha = 1;
                                     }];
                                 }];
            }
        }
        
    }
}

- (void)randomViewAction:(UITapGestureRecognizer *)tap{
    if (_hdDelegate && [_hdDelegate respondsToSelector:@selector(hdRandomView:selectIndex:)]) {
        [_hdDelegate hdRandomView:self selectIndex:tap.view.tag];
    }
}

- (UIView *)hdRandomViewAtIndex:(NSInteger)index{
    if (_randomCicleView.count > index) {
        return _randomCicleView[index];
    }
    return nil;
}

@end
