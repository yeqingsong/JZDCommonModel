//
//  UIButton+extraData.m
//  WarmHomeGZ
//
//  Created by tangyunchuan on 2019/1/31.
//

#import "UIButton+extraData.h"
#import <objc/runtime.h> /*或者 #import <objc/message.h>*/
static NSString *extraImageData = @"extraImageData";

@implementation UIButton (extraData)
/**
 setter方法
 */
- (void)setExtraImageData:(NSData *)extraImageData{
    objc_setAssociatedObject(self, &extraImageData, extraImageData, OBJC_ASSOCIATION_RETAIN);
}

/**
 getter方法
 */
- (NSString *)extraImageData {
    return objc_getAssociatedObject(self, &extraImageData);
}
@end
