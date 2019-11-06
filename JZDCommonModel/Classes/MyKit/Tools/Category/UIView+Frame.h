//
//  UIView+Frame.h
//  WarmHome
//
//  Created by huafangT on 16/11/14.
//
//直接修改frame中的某一个值

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (assign, nonatomic) CGFloat right;
@property (assign, nonatomic) CGFloat bottom;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;
@property (assign, nonatomic) CGFloat centerX;
@property (assign, nonatomic) CGFloat centerY;

@end
