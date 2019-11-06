//
//  QPActionSheet.m
//  AshineDoctor
//
//  Created by JiangYue on 15/3/9.
//  Copyright (c) 2015年 esuizhen. All rights reserved.
//

#import "QPActionSheet.h"
#import "MyUIKit.h"
@implementation QPActionSheet

/**
 *  ActionSheet
 *
 *  @param titles 标题数组
 *
 */
- (id)initWithTitleArray:(NSArray *)titles andDelegate:(id <QPActionSheetDelegate>)delegate
{
    if (self = [super init])
    {
        self.delete = delegate;
        
        self.actionSheet = [[AHKActionSheet alloc] initWithTitle:nil];
        
        self.actionSheet.blurTintColor = [UIColor colorWithWhite:0.0f alpha:0.15f];
        self.actionSheet.blurRadius = 8.0f;
        self.actionSheet.buttonHeight = 50.0f;
        self.actionSheet.cancelButtonHeight = 50.0f;
        self.actionSheet.animationDuration = 0.5f;
        self.actionSheet.cancelButtonShadowColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
        self.actionSheet.separatorColor = [UIColor lightGrayColor];
        self.actionSheet.selectedBackgroundColor = [UIColor colorWithRed:0.937 green:0.937 blue:0.957 alpha:1.000];
        UIFont *defaultFont = [UIFont systemFontOfSize:17.0f];
        self.actionSheet.buttonTextAttributes = @{ NSFontAttributeName : defaultFont,
                                                   NSForegroundColorAttributeName : UIColorFromHex(0x487db8)};
        self.actionSheet.destructiveButtonTextAttributes = @{ NSFontAttributeName : defaultFont,
                                                              NSForegroundColorAttributeName : [UIColor redColor]};
        self.actionSheet.cancelButtonTextAttributes = @{ NSFontAttributeName : defaultFont,
                                                         NSForegroundColorAttributeName : UIColorFromHex(0x5c5d61)};
        self.actionSheet.buttonTextCenteringEnabled = [NSNumber numberWithBool:YES];
        
        __weak id obj = self.delete;
        for (NSString *title in titles)
        {
            [self.actionSheet addButtonWithTitle:title image:nil type:AHKActionSheetButtonTypeDefault handler:^(AHKActionSheet *actionSheet) {
                
                [obj selectAtIndexPath:actionSheet.selectedIndex withSheet:actionSheet];
            }];
        }
    }
    
    return self;
}

/**
 *  显示ActionSheet
 */
- (void)show
{
    self.actionSheet.tag = self.tag;
    [self.actionSheet show];
}

@end
