//
//  HDRadarView.h
//  LookOtherDemo
//
//  Created by denglibing on 2017/1/11.
//  Copyright © 2017年 denglibing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDRadarView : UIView

// YES：背景扩散， NO：单纯的线条扩散
@property (nonatomic, assign) BOOL radarSolid;

// 咻咻扩展动画几次，默认10次
@property (nonatomic, assign) NSInteger radarCount;

// 是否能执行 咻咻 动画
@property (nonatomic, assign) BOOL radarAble;

// 咻咻间隔时间 默认1s
@property (nonatomic, assign) CGFloat radarDuration;

@property (nonatomic, strong) UIColor *cycleViewBgColor;

- (void)startXiuxiu;
- (void)stopXiuxiu;

@end
