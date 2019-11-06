//
//  QPActionSheet.h
//  AshineDoctor
//
//  Created by JiangYue on 15/3/9.
//  Copyright (c) 2015年 esuizhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AHKActionSheet.h"

@protocol QPActionSheetDelegate <NSObject>

- (void)selectAtIndexPath:(NSUInteger)index withSheet:(AHKActionSheet *)sheet;

@end

@interface QPActionSheet : NSObject

@property (nonatomic, strong) AHKActionSheet *actionSheet;
@property (nonatomic, assign) id <QPActionSheetDelegate> delete;
@property (nonatomic, assign) NSUInteger tag;
@property (nonatomic, strong) NSArray *dataArray;

/**
 *  ActionSheet
 *
 *  @param titles 标题数组
 *
 */
- (id)initWithTitleArray:(NSArray *)titles andDelegate:(id <QPActionSheetDelegate>)delegate;
/**
 *  显示ActionSheet
 */
- (void)show;

@end
