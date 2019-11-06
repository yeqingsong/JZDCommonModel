//
//  XEqualClass.h
//  XmenCombat
//
//  Created by Long on 2018/1/11.
//  Copyright © 2018年 bjjzd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XEqualClass : NSObject

+ (UIButton *)CreatButtonWithFrame:(CGRect)frame
                               tag:(NSInteger)tag
                            target:(id)target
                            action:(SEL)action
                           bgcolor:(UIColor *)color
                             image:(NSString *)imageName
                           bgImage:(NSString *)bgImageName
                        seletImage:(NSString *)seleImage
                             title:(NSString *)title;


+ (UIImageView *)createImageWithFrame:(CGRect)frame
                                image:(NSString *)image;

+(UILabel *)createLabelWithFram:(CGRect)frame
                       fontSize:(CGFloat)size
                      backColor:(UIColor *)color
                      textColor:(UIColor *)textColor
                      alignment:(NSTextAlignment)alignment
                     numberLine:(NSInteger)line
                        content:(NSString *)text;

+(UISwitch *)createSwitchWithFrame:(CGRect)frame
                         openState:(BOOL)open
                       actionEvent:(SEL)action;

+(UITextField *)createTextFieldWithFrame:(CGRect)frame
                               backColor:(UIColor *)backColor
                               textColor:(UIColor *)textColor
                             placeholder:(NSString *)place
                             borderStyle:(UITextBorderStyle)style
                         clearButtonMode:(UITextFieldViewMode)model
                         secureTextEntry:(BOOL)entry
                      autocorrectionType:(UITextAutocorrectionType)type
                    clearsOnBeginEditing:(BOOL)editing
                           textAlignment:(NSTextAlignment)alignment
                            keyboardType:(UIKeyboardType)keyboard
                           returnKeyType:(UIReturnKeyType)returnKey;

+(UITextView *)createTextViewWithFrame:(CGRect)frame
                              editable:(BOOL)edit
                             textColor:(UIColor *)textColor
                             backColor:(UIColor *)backColor
                         scrollEnabled:(BOOL)enabled
                            systemFont:(float)size;
@end


