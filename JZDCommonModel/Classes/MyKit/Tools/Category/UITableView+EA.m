//
//  UITableView+EA.m
//  WarmHome
//
//  Created by huafangT on 16/10/28.
//
//

#import "UITableView+EA.h"
#import "UITableViewCell+EA.h"
#import "MyUIKit.h"
@implementation UITableView (EA)

//初始化样式
- (void)initStyles:(BOOL)clearSeparator
{
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = nil;
    self.showsVerticalScrollIndicator = NO;
    if ([self respondsToSelector:@selector(separatorInset)]){
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]){
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
    if (clearSeparator){
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.sectionIndexColor = [UIColor clearColor];
        if ([self respondsToSelector:@selector(setSectionIndexBackgroundColor:)]) {
            self.sectionIndexBackgroundColor = [UIColor clearColor];
        }
        if ([self respondsToSelector:@selector(setSectionIndexTrackingBackgroundColor:)]) {
            self.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
        }
    } else {
        self.separatorColor = UIColorFromRGB(219, 219, 219);
    }
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (id)cellWithClass:(Class)classs style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier
{
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell){
        cell = [[classs alloc] initWithStyle:style reuseIdentifier:identifier];
        [cell initStyles];
    }
    return cell;
}

@end
