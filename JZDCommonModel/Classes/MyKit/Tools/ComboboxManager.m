//
//  ComboboxManager.m
//  WarmHomeGZ
//
//  Created by huafangT on 2017/12/6.
//

#import "ComboboxManager.h"
#import "QPActionSheet.h"
#import "NSObject+CurrentC.h"
#import "HttpUtil.h"
#import "Tools.h"
@interface ComboboxManager()<QPActionSheetDelegate>

@property (nonatomic, strong) UIViewController *currentVC;

@property (nonatomic)UIButton * sender;

@property (nonatomic)NSMutableArray * dataArray;
@property (nonatomic)NSMutableArray * nameArray;
@property (nonatomic)NSMutableArray * codeArray;
@property(assign, nonatomic)NSUInteger index;

// 选中后的回调
@property (nonatomic, copy) SelectCodeBlock selectBlock;

@end

@implementation ComboboxManager

- (void)startWorkWithType:(NSString *)listType AndSender:(UIButton *)sender SelectBlock:(SelectCodeBlock)selectBlock{
    self.sender = sender;
    self.selectBlock = selectBlock;
    
//    if(self.nameArray.count >0){
//        QPActionSheet *sheet = [[QPActionSheet alloc] initWithTitleArray:self.nameArray andDelegate:self];
//        [sheet show];
//    }else{JSBHZQK
    NSDictionary *dic ;
    if ([listType isEqualToString:@"RYDQXZ_LB"]) {
       dic =  @{@"listType":listType,
                @"extra":self.extra ? self.extra : @""
                };
    }else{
        dic =  @{@"listType":listType};
    }
    
        [HttpUtil postURL:@"/shgkapp/shgkapi/v1/public/combobox.do" parameters:@{@"listType":listType} success:^(id data) {
            self.dataArray = data;
            if(self.dataArray.count == 0){
                [Tools showMessage:@"暂无数据"];
                return ;
            }
            [self.nameArray removeAllObjects];
            [self.codeArray removeAllObjects];
     
            for (NSDictionary * dic in self.dataArray){
                if ([listType isEqualToString:@"RYDQXZ_LB"]) {
                    if ([self.extra isEqualToString:[dic objectForKey:@"parentMetaEntryCode"]]) {
                        [self.nameArray addObject:[dic objectForKey:@"metaEntryName"]];
                        [self.codeArray addObject:[dic objectForKey:@"metaEntryCode"]];
                    }
                }else{
                    [self.nameArray addObject:[dic objectForKey:@"metaEntryName"]];
                    [self.codeArray addObject:[dic objectForKey:@"metaEntryCode"]];
                }
                
            }
            QPActionSheet *sheet = [[QPActionSheet alloc] initWithTitleArray:self.nameArray andDelegate:self];
            [sheet show];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
}

#pragma mark -
#pragma mark QPActionSheet Delegate
- (void)selectAtIndexPath:(NSUInteger)index withSheet:(AHKActionSheet *)sheet{
    [self.sender setTitle:self.nameArray[index] forState:UIControlStateNormal];
    if(self.selectBlock) {
        self.selectBlock(self.codeArray[index]);
    }
}

+ (ComboboxManager *)shareInstance{
    static ComboboxManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
    });
    return manager;
}

- (UIViewController *)currentVC{
    if(!_currentVC){
        _currentVC = self.getCurrentViewController;
    }
    return _currentVC;
}

- (NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)codeArray{
    if(!_codeArray){
        _codeArray = [NSMutableArray array];
    }
    return _codeArray;
}

- (NSMutableArray *)nameArray{
    if(!_nameArray){
        _nameArray = [NSMutableArray array];
    }
    return _nameArray;
}

@end
