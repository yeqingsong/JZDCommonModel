//
//  UITableView+EA.h
//  WarmHome
//
//  Created by huafangT on 16/10/28.
//
//

#import <UIKit/UIKit.h>

@interface UITableView (EA)

//初始化样式
- (void)initStyles:(BOOL)clearSeparator;

- (id)cellWithClass:(Class)classs style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier;

@end
