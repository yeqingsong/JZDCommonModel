//
//  UITextView+EA.m
//  WarmHome
//
//  Created by 方 on 17/2/8.
//
//

#import "UITextView+PlaceHolder.h"
#import <objc/runtime.h>
#import "EAViewUtil.h"
#import "MyUIKit.h"
#import "NSString+EA.h"
#import "MyGenmetry.h"
static char kPlaceHoderKey;

@implementation UITextView (PlaceHolder)

- (void)setPlaceHolder:(NSString *)placeHolder
{
    if (0 == placeHolder.length) {
        if (nil != objc_getAssociatedObject(self, &kPlaceHoderKey)){
            objc_setAssociatedObject(self, &kPlaceHoderKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [self removeObserver:self forKeyPath:@"text"];
            [self removeObserver:self forKeyPath:@"attributedText"];
            [[NSNotificationCenter defaultCenter] removeObserver:self];
        }
    } else {
        UILabel *label = objc_getAssociatedObject(self, &kPlaceHoderKey);
        if (nil == label){
            label = [EAViewUtil makeLabel:CGRectInset(self.bounds, 5, 5)];
            [EAViewUtil setLabel:label :NSTextAlignmentLeft :UIColorFromRGBA(127, 127, 127, 1) :self.font];
            label.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
            label.numberOfLines = 0;
            [self addSubview:label];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTextDidchanged:) name:UITextViewTextDidChangeNotification object:nil];
            [self addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];
            [self addObserver:self forKeyPath:@"attributedText" options:NSKeyValueObservingOptionNew context:NULL];
            objc_setAssociatedObject(self, &kPlaceHoderKey, label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        label.text = placeHolder;
        
        CGFloat height = [placeHolder eaSizeWithFont:self.font maxWidth:CGViewGetWidth(label)].height;
        CGViewChangeHeight(label, height);
        [self checkZeroLength];
    }
}

- (NSString *)placeHolder
{
    UILabel *label = objc_getAssociatedObject(self, &kPlaceHoderKey);
    return label.text;
}

- (void)checkZeroLength
{
    if (0 != self.text.length || 0 != self.attributedText.string.length) {
        [objc_getAssociatedObject(self, &kPlaceHoderKey) setHidden:YES];
    } else {
        [objc_getAssociatedObject(self, &kPlaceHoderKey) setHidden:NO];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self checkZeroLength];
}

- (void)onTextDidchanged:(NSNotification *)notify
{
    if (notify.object == self) {
        [self checkZeroLength];
    }
}


@end
