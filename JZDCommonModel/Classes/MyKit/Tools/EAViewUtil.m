//
//  EAViewUtil.m
//  AshineDoctor
//
//  Created by Lipeng on 15-7-29.
//  Copyright (c) 2015年 esuizhen. All rights reserved.
//

#import "EAViewUtil.h"
#import "MyUIKit.h"
#import "NSString+EA.h"
#import "MyGenmetry.h"
@implementation EAViewUtil
+ (UILabel *)exampleLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,36,20)];
    //label.cornerRadius = 6;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = k_gray_200;
    label.textColor = k_black_0;
    label.font = [UIFont systemFontOfSize:12];
    label.text = @"示例";
    return label;
}

+ (UILabel *)makeLabel:(CGRect)frame
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

+ (void)setLabel:(UILabel *)label
                :(NSTextAlignment)align
                :(UIColor *)color
                :(UIFont *)font
{
    label.textAlignment = align;
    label.textColor = color;
    label.font = font;
}

+ (UITextField *)makeTextField:(CGRect)frame
{
    UITextField *tf = [[UITextField alloc] initWithFrame:frame];
    tf.backgroundColor = [UIColor clearColor];
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    tf.leftViewMode    = UITextFieldViewModeAlways;
    return tf;
}

+ (void)setTextFiled:(UITextField *)textField
                    :(NSString *)placeHolder
                    :(NSTextAlignment)align
                    :(UIFont *)font
                    :(UIColor *)color
                    :(UIKeyboardType)keyboardType
                    :(UIReturnKeyType)returnkeyType
{
    textField.textAlignment = align;
    textField.font = font;
    textField.textColor = color;
    textField.placeholder = placeHolder;
    textField.keyboardType = keyboardType;
    textField.returnKeyType = returnkeyType;
}

+ (UITextView *)makeTextView:(CGRect)frame
{
    UITextView *tv = [[UITextView alloc] initWithFrame:frame];
    tv.backgroundColor = [UIColor clearColor];
    tv.showsVerticalScrollIndicator = NO;
    if ([tv respondsToSelector:@selector(layoutManager)]){
        tv.layoutManager.allowsNonContiguousLayout = NO;
    }
    return tv;
}

+ (void)setTextView:(UITextView *)textView
                   :(NSTextAlignment)align
                   :(UIFont *)font
                   :(UIColor *)color
                   :(UIReturnKeyType)keyType
{
    textView.font = font;
    textView.textAlignment = align;
    textView.textColor = color;
    textView.returnKeyType = keyType;
}

+ (UIButton *)makeButton:(CGRect)frame
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.backgroundColor = [UIColor clearColor];
    return button;
}

+ (void)setButton:(UIButton *)button
                 :(NSString *)title
                 :(UIFont *)font
                 :(UIColor *)titleColor
                 :(UIControlState)state
{
    button.titleLabel.font = font;
    [button setTitle:title forState:state];
    [button setTitleColor:titleColor forState:state];
}

//window显示的提示
+ (void)toastText:(NSString *)text
{
    UIWindow *wdw = [UIApplication sharedApplication].keyWindow;
    UIFont *font = font(14);
    CGSize size = [text eaSizeWithFont:font maxWidth:CGViewGetWidth(wdw)-68];
    UILabel *toast = [self makeLabel:CGRectMake(0,0,size.width+20,size.height+10)];
    [self setLabel:toast :NSTextAlignmentCenter :UIColorFromRGB(255,255,255) :font];
    toast.backgroundColor = UIColorFromRGBA(0, 0, 0, .6);
  //  toast.cornerRadius = 4;
    toast.text = text;
    toast.numberOfLines = 0;

    [wdw addSubview:toast];
    toast.center = CGPointMake(CGViewGetWidth(wdw)/2, CGViewGetHeight(wdw)/2);
    
    toast.alpha = 0;
    [UIView animateWithDuration:.2f animations:^{
        toast.alpha = 1;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:.2f animations:^{
            toast.alpha = 0;
        } completion:^(BOOL finished) {
            [toast removeFromSuperview];
        }];
    });
}

+ (void)toastText:(NSString *)text time:(NSInteger) time
{
    UIFont *font = font(14);
    CGSize size = [text eaSizeWithFont:font];
    UILabel *toast = [self makeLabel:CGRectMake(0,0,size.width+20,size.height+10)];
    [self setLabel:toast :NSTextAlignmentCenter :k_white_252 :font];
    toast.backgroundColor = UIColorFromRGBA(0, 0, 0, .6);
//    toast.cornerRadius = 4;
    toast.text = text;
    UIWindow *wdw = [UIApplication sharedApplication].keyWindow;
    [wdw addSubview:toast];
    toast.center = CGPointMake(CGViewGetWidth(wdw)/2, CGViewGetHeight(wdw)/2);
    
    toast.alpha = 0;
    if (0 == time) {
        time = 1;
    }
    [UIView animateWithDuration:.2f animations:^{
        toast.alpha = 1;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, time * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:.2f animations:^{
            toast.alpha = 0;
        } completion:^(BOOL finished) {
            [toast removeFromSuperview];
        }];
    });
}
//头像
+ (UIImageView *)makeHeadImageView:(CGFloat)width
{
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,width,width)];
    iv.contentMode = UIViewContentModeScaleAspectFill;
  //  iv.cornerRadius = width/2;
    iv.backgroundColor = UIColorFromRGBA(0xf8,0xf8,0xf9,1);
    return iv;
}
//未读标志
+ (UILabel *)unreadDotView:(CGFloat)width
{
    UILabel *v = [[UILabel alloc] initWithFrame:CGRectMake(0,0,width,width)];
    v.backgroundColor = UIColorFromRGBA(0xfc,0x4e,0x4e,1);
//    v.cornerRadius = width/2;
    v.font = font(10);
    v.textAlignment = NSTextAlignmentCenter;
    v.textColor = k_white_252;
    return v;
}

//测试高度
+ (CGFloat)testHeightWithFont:(UIFont *)font
{
    return [@"测试" eaSizeWithFont:font].height;
}

@end
