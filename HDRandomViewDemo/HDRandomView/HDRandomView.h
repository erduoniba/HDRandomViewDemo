//
//  HDRandomView.h
//  LookOtherDemo
//
//  Created by denglibing on 2017/1/11.
//  Copyright © 2017年 denglibing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HDRandomView;

@protocol HDRandomViewDelegate <NSObject>

@optional

// 点击哪一个随机圆
- (void)hdRandomView:(HDRandomView *)hdRandomView selectIndex:(NSInteger)index;

@end


@protocol HDRandomViewDataSource <NSObject>

// 需要生成多少个随机圆
- (NSInteger)numberOfRandomViewInHDRandomView:(HDRandomView *)hdRandomView;

// 每一个随机圆需要通过该协议传入，但是随机圆的大小和位置由 HDRandomView 内部决定
- (UIView *)hdRandomView:(HDRandomView *)hdRandomView randomViewAtIndex:(NSInteger)index;

@end



@interface HDRandomView : UIView

// 中间圆和半径是大圆半径的比例 默认为 3/5
@property (nonatomic, assign) CGFloat middleScale;

// 标准圆最小的半径, 默认为30
@property (nonatomic, assign) NSInteger minRadius;

// 标准圆随机数范围最大值，默认为40
@property (nonatomic, assign) NSInteger raduisRange;

@property (nonatomic, weak) id<HDRandomViewDelegate> hdDelegate;

@property (nonatomic, weak) id<HDRandomViewDataSource> hdDataSource;

// 刷新数据，生成随机圆
- (void)reloadDataAnimated:(BOOL)animated;

// 获取index位置的随机圆
- (UIView *)hdRandomViewAtIndex:(NSInteger)index;

@end
