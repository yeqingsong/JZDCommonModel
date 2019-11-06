//
//  UIResponder+Router.m
//  WarmHome
//
//  Created by 方 on 16/12/26.
//
//

#import "UIResponder+Router.h"

@implementation UIResponder (Router)

- (void)routerEvent:(id)info
{
    [self.nextResponder routerEvent:info];
}

@end
