//
//  NSAttributedString+EA.h
//  AshineDoctor
//
//  Created by Lipeng on 15-8-13.
//  Copyright (c) 2015年 esuizhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString(EA)
//获取尺寸
- (CGSize)eaSizeWithMaxWidth:(CGFloat)width;
//获取高度
- (CGFloat)eaHeightWithMaxWidth:(CGFloat)width;

@end
