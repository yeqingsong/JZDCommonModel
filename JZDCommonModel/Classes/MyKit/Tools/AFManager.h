//
//  AFManager.h
//  WarmHomeGZ
//
//  Created by huafangT on 2018/1/30.
//

#import <AFNetworking/AFNetworking.h>

@interface AFManager : AFHTTPSessionManager

+(AFHTTPSessionManager *)shareManager;

@end
