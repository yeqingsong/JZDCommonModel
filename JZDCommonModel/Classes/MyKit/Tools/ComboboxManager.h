//
//  ComboboxManager.h
//  WarmHomeGZ
//
//  Created by huafangT on 2017/12/6.
//

#import <Foundation/Foundation.h>

//返回形式：code
typedef void(^SelectCodeBlock)(NSString * codeStr);

@interface ComboboxManager : NSObject
///满足一些特殊判断
@property (nonatomic,copy)NSString *extra;

+ (ComboboxManager *)shareInstance;

- (void)startWorkWithType:(NSString *)listType AndSender:(UIButton *)sender SelectBlock:(SelectCodeBlock)selectBlock;


@end
