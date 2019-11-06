//
//  NSMutableArray+SafeAdd.m
//  PgySDKDemo
//
//  Created by 方 on 2017/11/13.
//  Copyright © 2017年 Scott Lei. All rights reserved.
//

#import "NSMutableArray+SafeAdd.h"
#import<objc/runtime.h>
@implementation NSMutableArray (SafeAdd)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    
    Method orginalMethod = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(addObject:));
    Method newMethod = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(newAddobject:));
    method_exchangeImplementations(orginalMethod, newMethod);
    });
}

- (void)newAddobject:(id)obj {
    if (obj != nil) {
        [self newAddobject:obj];
    }else{
        [self newAddobject:@""];
    }
}

@end
