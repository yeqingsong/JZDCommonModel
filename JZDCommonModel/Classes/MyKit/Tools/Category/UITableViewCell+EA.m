//
//  UITableViewCell+EA.m
//  WarmHome
//
//  Created by huafangT on 16/10/28.
//
//

#import "UITableViewCell+EA.h"
#import "MyUIKit.h"
#import<objc/runtime.h>
@implementation UITableViewCell (EA)

- (void)initStyles
{
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    self.accessoryType   = UITableViewCellAccessoryNone;
    self.selectionStyle  = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView  = nil;
    self.selectedBackgroundView = nil;
    self.contentView.backgroundColor = [UIColor clearColor];
    if ([self respondsToSelector:@selector(setSeparatorInset:)]){
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]){
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([self respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [self setPreservesSuperviewLayoutMargins:NO];
    }
}

- (void)ea_setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    self.backgroundColor = highlighted ? UIColorFromRGB(246, 246, 249) : UIColorFromRGB(255, 255, 255);
}

+ (void)loadSwizzling
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        Method originalMethod = class_getInstanceMethod(class, @selector(setHighlighted:animated:));
        Method swizzledMethod = class_getInstanceMethod(class, @selector(ea_setHighlighted:animated:));
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

@end
