//
//  MyKeychain.h
//  WarmHome
//
//  Created by huafangT on 16/11/3.
//
//

#import <Foundation/Foundation.h>

@interface MyKeychain : NSObject

- (id)load:(NSString *)service;

- (void)save:(NSString *)service data:(id)data;

- (void)delete:(NSString *)service;
@end
