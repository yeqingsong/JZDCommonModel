//
//  AFManager.m
//  WarmHomeGZ
//
//  Created by huafangT on 2018/1/30.
//

#import "AFManager.h"

@implementation AFManager

+(AFHTTPSessionManager *)shareManager {
    static AFHTTPSessionManager *manager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
    });
    
    return manager;
}

@end
