//
//  EAViewUtil.h
//  AshineDoctor
//
//  Created by Lipeng on 15-7-29.
//  Copyright (c) 2015年 esuizhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EAViewUtil : NSObject
//示例
+ (UILabel *)exampleLabel;
//UILabel
+ (UILabel *)makeLabel:(CGRect)frame;
+ (void)setLabel:(UILabel *)label
                :(NSTextAlignment)align
                :(UIColor *)color
                :(UIFont *)font;
//UITextField
+ (UITextField *)makeTextField:(CGRect)frame;
+ (void)setTextFiled:(UITextField *)textField
                    :(NSString *)placeHolder
                    :(NSTextAlignment)align
                    :(UIFont *)font
                    :(UIColor *)color
                    :(UIKeyboardType)keyboardType
                    :(UIReturnKeyType)returnkeyType;
//UITextView
+ (UITextView *)makeTextView:(CGRect)frame;
+ (void)setTextView:(UITextView *)textView
                   :(NSTextAlignment)align
                   :(UIFont *)font
                   :(UIColor *)color
                   :(UIReturnKeyType)key;
//按钮
+ (UIButton *)makeButton:(CGRect)frame;
+ (void)setButton:(UIButton *)button
                 :(NSString *)title
                 :(UIFont *)font
                 :(UIColor *)titleColor
                 :(UIControlState)state;
+ (void)toastText:(NSString *)text;
+ (void)toastText:(NSString *)text time:(NSInteger) time;
//头像
+ (UIImageView *)makeHeadImageView:(CGFloat)width;
//未读标志
+ (UILabel *)unreadDotView:(CGFloat)width;
//测试高度
+ (CGFloat)testHeightWithFont:(UIFont *)font;
@end
