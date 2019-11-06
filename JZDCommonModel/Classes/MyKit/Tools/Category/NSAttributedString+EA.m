//
//  NSAttributedString+EA.m
//  AshineDoctor
//
//  Created by Lipeng on 15-8-13.
//  Copyright (c) 2015年 esuizhen. All rights reserved.
//

#import "NSAttributedString+EA.h"

@implementation NSAttributedString(EA)
- (CGSize)eaSizeWithMaxWidth:(CGFloat)width
{
    CGSize size = [self boundingRectWithSize:CGSizeMake(width,MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                     context:nil].size;
    return CGSizeMake(ceil(size.width), ceil(size.height));
}

- (CGFloat)eaHeightWithMaxWidth:(CGFloat)width
{
    return [self eaSizeWithMaxWidth:width].height;
}

@end
