//
//  XEqualClass.m
//  XmenCombat
//
//  Created by Long on 2018/1/11.
//  Copyright © 2018年 bjjzd. All rights reserved.
//

#import "XEqualClass.h"

@implementation XEqualClass

+ (UIButton *)CreatButtonWithFrame:(CGRect)frame
                               tag:(NSInteger)tag
                            target:(id)target
                            action:(SEL)action
                           bgcolor:(UIColor *)color
                             image:(NSString *)imageName
                           bgImage:(NSString *)bgImageName
                        seletImage:(NSString *)seleImage
                             title:(NSString *)title{
    UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setFrame:frame];
    [btn setTag:tag];
    [btn setBackgroundColor:color];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:seleImage] forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageNamed:bgImageName] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+ (UIImageView *)createImageWithFrame:(CGRect)frame
                                image:(NSString *)image{
    UIImageView *bImage=[[UIImageView alloc]initWithFrame:frame];
    [bImage setImage:[UIImage imageNamed:image]];
    bImage.contentMode=UIViewContentModeScaleToFill;
    bImage.backgroundColor =[UIColor clearColor];
    return bImage;
}

+(UILabel *)createLabelWithFram:(CGRect)frame
                       fontSize:(CGFloat)size
                      backColor:(UIColor *)color
                      textColor:(UIColor *)textColor
                      alignment:(NSTextAlignment)alignment
                     numberLine:(NSInteger)line
                        content:(NSString *)text;
{
    UILabel *label=[[UILabel alloc]init];
    label.frame=frame;
    label.font=[UIFont systemFontOfSize:size];
    label.backgroundColor=color;
    label.textColor=textColor;
    label.textAlignment=alignment;
    label.text=text;
    label.numberOfLines=line;
    
    return label;
}

+(UISwitch *)createSwitchWithFrame:(CGRect)frame
                         openState:(BOOL)open
                       actionEvent:(SEL)action
{
    UISwitch *createSwitch = [[UISwitch alloc] init];
    createSwitch.on = open;
    if (action != nil) {
        [createSwitch addTarget:self action:@selector(action) forControlEvents:UIControlEventValueChanged];
    }
    return createSwitch;
}

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
{
    UITextField *createTextField = [[UITextField alloc]init];
    createTextField.frame = frame;
    createTextField.backgroundColor = backColor;
    createTextField.textColor = textColor;
    //    createTextField.font = [UIFont systemFontOfSize:0.f]; default
    createTextField.placeholder = place;
    createTextField.borderStyle = style;
    createTextField.clearButtonMode = model;
    createTextField.autocorrectionType = type;
    createTextField.clearsOnBeginEditing = editing;
    createTextField.textAlignment = alignment;
    createTextField.keyboardType = keyboard;
    createTextField.returnKeyType = returnKey;
    createTextField.secureTextEntry = entry;
    return createTextField;
}

+(UITextView *)createTextViewWithFrame:(CGRect)frame
                              editable:(BOOL)edit
                             textColor:(UIColor *)textColor
                             backColor:(UIColor *)backColor
                         scrollEnabled:(BOOL)enabled
                            systemFont:(float)size
{
    UITextView *createTextView = [[UITextView alloc]init];
    createTextView.editable = edit;
    createTextView.textColor = textColor;
    createTextView.backgroundColor = backColor;
    //createTextView.scrollEnabled = YES;
    createTextView.font = [UIFont systemFontOfSize:size];
    return createTextView;
}

@end
