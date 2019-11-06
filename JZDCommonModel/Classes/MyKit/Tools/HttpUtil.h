//
//  HttpUtil.h
//  ICanDoThis
//
//  Created by THF on 16/8/29.
//  Copyright © 2016年 thf. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HTTPErrorCode) {
    HTTPErrorCode_Failed = -1, //失败
    HTTPErrorCode_Success,//成功
    HTTPErrorCode_UnkownError      = 104,//程序异常未知错误
    HTTPErrorCode_SessionExpired   = 1003,//session过期
    HTTPErrorCode_PasswordError    = 2003,//密码错误
    HTTPErrorCode_CaptchaExpried   = 2007,//验证码过期
};

typedef void (^http_block) (HTTPErrorCode code, id response, NSString *message);

@interface HttpUtil : NSObject

+ (HttpUtil *)shared;

//同步上传
+ (void)upLoadToUrlString:(NSString *)url parameters:(NSDictionary *)parameters fileData:(NSData *)fileData type:(NSString *)type mimeType:(NSString *)mimeType  progress:(void (^)(NSProgress * progress ))progress success:(void (^)(NSURLSessionDataTask*task , id responseData))success failure:(void (^)(NSURLSessionDataTask *task, NSError* error))failure;

//value格式 key+value file格式 key+name+type+path
- (void)postToURL:(NSString *)URL types:(NSString *)types datas:(NSData *)datas block:(http_block)block;




+(void)postURL:(NSString *)url
    parameters:(id)parameters
       success:(void (^)(id data))apiSuccess
       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

+(void)getURL:(NSString *)url
   parameters:(NSDictionary *)parameters
      success:(void (^)(id data))apiSuccess
      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

//上传文件
+(void)UpLoadWith:(NSString *)url
       parameters:(NSDictionary *)parameters
       imageArray:(NSMutableArray *)images
        nameArray:(NSMutableArray *)names
          success:(void (^)(id data))apiSuccess
          failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

//获取头像流
+(void)getAvatar:(NSString *)url
    parameters:(id)parameters
       success:(void (^)(id data))apiSuccess
       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

+ (void)uploadPhoneData:(NSDictionary *)dic;

+(void)obtainDownloadFileAddressTransferURL:(NSString *)fileurl success:(void (^)(id data))apiSuccess
                                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

+(void)requestPostCheckPgyUpdataWithApi:(NSString *)url success:(void (^)(id data))apiSuccess
                                failure:(void (^)(NSError *error))failure;
@end
