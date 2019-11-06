//
//  HttpUtil.m
//  ICanDoThis
//
//  Created by THF on 16/8/29.
//  Copyright © 2016年 thf. All rights reserved.
//http://www.zhimengzhe.com/IOSkaifa/14225.html
//http://blog.cnbang.net/tech/2371/

#import "HttpUtil.h"
#import <AFNetworking/AFNetworking.h>
#import "AFHTTPSessionManager.h"
#import "AFManager.h"
#import "Tools.h"
#import "MyUIKit.h"
#import "FCUUID.h"
#import "NSDate+EA.h"
@interface EDHttpSynObject : NSObject
@end

@implementation EDHttpSynObject
- (void)execute:(void (^)(void))block
{
    block();
}
@end


@implementation HttpUtil

+ (HttpUtil *)shared
{
    static id instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)upDataFileWithType:(NSString *)type UploadData:(NSData *)data  success:(void (^)(id data))apiSuccess
                   failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    /**
     *  文件上传的时候需要设置请求头中Content-Type类型, 必须使用URL编码,
     
     application/x-www-form-urlencoded：默认值，发送前对所有发送数据进行url编码，支持浏览器访问，通常文本内容提交常用这种方式。
     multipart/form-data：多部分表单数据，支持浏览器访问，不进行任何编码，通常用于文件传输（此时传递的是二进制数据） 。
     text/plain：普通文本数据类型，支持浏览器访问，发送前其中的空格替换为“+”，但是不对特殊字符编码。
     application/json：json数据类型，浏览器访问不支持 。
     text/xml：xml数据类型，浏览器访问不支持。
     
     multipart/form-data 必须进行设置,
     */
    // 1. 创建URL
    NSString *urlStr = @"url";
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlStr];
    // 2. 创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 设置请求的为POST
    request.HTTPMethod = @"POST";
    
    // 3.构建要上传的数据
    
    
    // 设置request的body
    request.HTTPBody = data;
    
    // 设置请求 Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data.length] forHTTPHeaderField:@"Content-Length"];
    // 设置请求 Content-Type
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",@"Xia"] forHTTPHeaderField:@"Content-Type"];
    
    // 4. 创建会话
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            // 上传成功
            apiSuccess(response);
        }else {
            // 上传失败, 打印error信息
            NSLog(@"error --- %@", error.localizedDescription);
            
        }
    }];
    // 恢复线程 启动任务
    [uploadTask resume];
    
}


+ (void)upLoadToUrlString:(NSString *)url parameters:(NSDictionary *)parameters fileData:(NSData *)fileData type:(NSString *)type mimeType:(NSString *)mimeType  progress:(void (^)(NSProgress * progress ))progress success:(void (^)(NSURLSessionDataTask*task , id responseData))success failure:(void (^)(NSURLSessionDataTask *task, NSError* error))failure {
    
    //1.获取单例的网络管理对象
    
    AFHTTPSessionManager *manager = [AFManager shareManager];;
    //2.根据style 的类型 去选择返回值得类型
    manager.requestSerializer= [AFHTTPRequestSerializer serializer];
    manager.responseSerializer= [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.f;
    //AFCreateMultipartFormBoundary
    NSString * filename ;
    NSString * endName ;
    NSString * indexs ;
    if([type isEqualToString:@"A"]){
        endName = @"amr";
        indexs = [Tools getObjForKey:@"AINDEX"] ==nil? @"0":[Tools getObjForKey:@"AINDEX"];
    }else{
        endName = @"jpg";
        indexs = [Tools getObjForKey:@"PINDEX"] ==nil? @"0":[Tools getObjForKey:@"PINDEX"];
    }
    filename = [NSString stringWithFormat:@"%@_%@_%@_%@.%@",[Tools getObjForKey:@"ID"],[NSDate date].uploadyyyyMMddHHmmssString,type,indexs,endName];
    //3.设置相应数据支持的类型
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain",@"image/jpeg",@"audio/amr", @"application/javascript",@"application/json",@"application/xhtml", @"application/x-www-form-urlencoded", nil]];
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:fileData name:@"file" fileName:filename mimeType:mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(task, responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(task, error);
        }
    }];
}







- (void)postToURL:(NSString *)URL types:(NSString *)types datas:(NSData *)datas block:(http_block)block
{
    NSOperationQueue * queue = [NSOperationQueue mainQueue];
    NSURLRequest *request = [self multipartFormRequestWithURL:URL method:@"POST" types:types datas:datas];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (data) {//请求成功
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"%@",dict);
            
            //判断后，在界面提示登录信息
            NSString *error=dict[@"error"];
            if (error) {
                [Tools showMessage:error];
            }else
            {
                NSString *success=dict[@"success"];
                [Tools showMessage:success];
            }
        }else   //请求失败
        {
            [Tools showMessage:@"网络繁忙，请稍后重试！"];
        }
    }];
}

//ImageUploader
//http://www.jianshu.com/p/a0e3c77d3164
//http://www.jianshu.com/p/a0e3c77d3164
//https://segmentfault.com/q/1010000000400069
- (NSURLRequest *)multipartFormRequestWithURL:(NSString *)URL method:(NSString *)method  types:(NSString *)types datas:(NSData *)datas
{
    
    NSString *stringBoundary = @"-----------------------------168051315714673199762127628619";
    NSString *endItemBoundary = [NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary];
    
    NSMutableData *data = [NSMutableData data];
    
    [data appendData:[[NSString stringWithFormat:@"--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString * filename ;
    NSString * endName ;
    NSString * indexs ;
    if([types isEqualToString:@"A"]){
        endName = @"amr";
        indexs = [Tools getObjForKey:@"AINDEX"] ==nil? 0:[Tools getObjForKey:@"AINDEX"];
    }else{
        endName = @"jpg";
        indexs = [Tools getObjForKey:@"PINDEX"];
    }
    filename = [NSString stringWithFormat:@"%@_%@_%@_%@.%@",[Tools getObjForKey:@"ID"],[NSDate date].yyyyMMddString,types,indexs,endName];
    
    NSString *txt = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", @"file", filename];
    [data appendData:[txt dataUsingEncoding:NSUTF8StringEncoding]];
    txt = [NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", types];
    [data appendData:[txt dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:datas];
    
    //   [data appendData:[endItemBoundary dataUsingEncoding:NSUTF8StringEncoding]];
    
    [data appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; charset=utf-8; boundary=%@", stringBoundary];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URL]];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"en-US,en;q=0.5" forHTTPHeaderField:@"Content-Length"];
    [request addValue:@"multipart/form-data" forHTTPHeaderField:@"ENCTYPE"];
    [request setValue:@"application/json,text/html,audio/amr,image/jpeg,application/xhtml" forHTTPHeaderField:@"Accept"];
    request.HTTPMethod = @"POST";
    request.HTTPBody = data;
    return request;
}

- (void)response:(NSData *)data block:(http_block)block
{
    if (nil != data){
        id jd = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        if ([jd isKindOfClass:NSDictionary.class]){
            NSDictionary *dic = (NSDictionary *)jd;
            NSString *msg  = [self remakeMessage:dic[@"msg"]];
            NSString *code = [self remakeCode:dic[@"code"]];
            if (0 == code.length) {
                block(HTTPErrorCode_UnkownError, nil, msg);
            } else if ([@"0" isEqualToString:code]){
                block(HTTPErrorCode_Success, [self remakeResult:dic[@"result"]], msg);
            } else {
                block(code.integerValue, nil, msg);
            }
        } else {
            //程序异常
            block(HTTPErrorCode_UnkownError, nil, nil);
        }
    } else {
        block(HTTPErrorCode_Failed, nil, nil);
    }
}

- (NSString *)remakeCode:(id)code
{
    if ([code isKindOfClass:NSString.class]) {
        return code;
    }
    return @"";
}

- (id)remakeResult:(id)result
{
    return [result isKindOfClass:NSString.class] ? nil : result;
}

- (NSString *)remakeMessage:(id)message
{
    if ([message isKindOfClass:NSString.class]) {
        return message;
    }
    return nil;
}


+ (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书  AFNetworking会自动去搜索mainBundle下的所有cer结尾的文件并放进内存，所以以下两行可以不用写
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"yan_server" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    //FIXME:SSL双向认证,原来没有使用certSet
    //    NSSet *certSet = [NSSet setWithObject:certData];
    //    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:certSet];
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
   // securityPolicy.pinnedCertificates = @[certData];
    
    return securityPolicy;
}


+(void)postURL:(NSString *)url
    parameters:(id)parameters
       success:(void (^)(id data))apiSuccess
       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSLog(@"postToUrl:%@ \nparameters:%@",url,parameters);
    if ([parameters isMemberOfClass:[NSObject class]]) {
        parameters = nil;
    }
    NSDictionary * dic;
    if ([url isEqualToString:@"/shgkapp/shgkapi/v1/Zxjc/Zxjcpclbxq.do"]) {
        dic = @{@"version":@"1.0",
                @"from":@"terminal",
                @"timestamp":[self getNowTimestamp],
                @"imei":[FCUUID uuidForDevice],
                @"data":parameters};
    }else{
        dic = @{@"version":@"1.0",
                @"from":@"terminal",
                @"timestamp":[self getNowTimestamp],
                @"imei":[FCUUID uuidForDevice],
                @"token":@"",
                @"data":parameters == nil?@"":parameters};
    }
    if(parameters != nil){
        if([url containsString:@"getSigninBz"]||
           [url containsString:@"getXtyhDw"]||
           [url containsString:@"Ltdhjl"]||
           [url containsString:@"atLog"]||
           [url containsString:@"scxtxx"]){
            //隐藏LoadHud
        }else{
            [Tools showLoadHud];
        }
    }
    
    url = [NSString stringWithFormat:@"%@%@",BASE_URL,url];
    
    AFHTTPSessionManager *manager = [AFManager shareManager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 40.f;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json",@"text/plain",@"text/json",@"text/html",@"image/jpeg", nil];
    NSLog(@"%@",manager.responseSerializer.acceptableContentTypes);
    //https ssl 验证。
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(parameters != nil){
            [Tools hideHud];
        }
        if (apiSuccess) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if([[dict objectForKey:@"resultCode"]integerValue] == 0){
              apiSuccess([dict objectForKey:@"data"]);
            }else if([[dict objectForKey:@"resultCode"]integerValue] == 109){//辣鸡代码
                NSMutableDictionary * newDic = [NSMutableDictionary dictionaryWithDictionary:[dict objectForKey:@"data"]];
                [newDic setObject:@"109" forKey:@"resultCode"];
                apiSuccess(newDic);
            }else{
                [Tools showMessage:[dict objectForKey:@"resultMessage"]];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if(parameters != nil){
            [Tools hideHud];
        }
        if (failure) {
            if([url containsString:@"getSigninBz"]||
               [url containsString:@"getXtyhDw"]||
               [url containsString:@"Ltdhjl"]||
               [url containsString:@"atLog"]||
               [url containsString:@"scxtxx"]){
                //隐藏LoadHud
            }else{
                [Tools showMessage:@"请求失败,请稍后再试!"];
            }
            
            failure(task,error);
            NSLog(@"%@",[error localizedDescription]);
            NSLog(@"error ==%@", [error userInfo][@"com.alamofire.serialization.response.error.string"]);
            NSLog(@"%@",[[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding]);
        }
    }];
}

+(void)getURL:(NSString *)url
   parameters:(NSDictionary *)parameters
      success:(void (^)(id data))apiSuccess
      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSLog(@"postToUrl:%@ \nparameters:%@",url,parameters);
    
    url = [NSString stringWithFormat:@"%@%@",BASE_URL,url];
    
    AFHTTPSessionManager *manager = [AFManager shareManager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json",@"text/plain", @"text/json",@"text/html", nil];

    [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"Result:%@ ",responseObject);
        
        if (apiSuccess) {
            apiSuccess(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(task,error);
        }
    }];
}

//上传文件
+(void)UpLoadWith:(NSString *)url
       parameters:(NSDictionary *)parameters
       imageArray:(NSMutableArray *)images
        nameArray:(NSMutableArray *)names
          success:(void (^)(id data))apiSuccess
          failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    
    NSDictionary * dic = @{@"version":@"1.0",
                           @"from":@"terminal",
                           @"timestamp":[self getNowTimestamp],
                           @"data":parameters == nil?@"":parameters};
    
    if(parameters != nil){
        
        [Tools showLoadHud];
    }
    
    url = [NSString stringWithFormat:@"%@%@",BASE_URL,url];
    
    AFHTTPSessionManager *manager = [AFManager shareManager];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json",@"text/plain", @"text/json",@"text/html", nil];
    //https ssl 验证。
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFormData:[Tools toJSONData:dic] name:@"detail"];
        
        int i = 0;
        //根据当前系统时间生成图片名称
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        NSString *dateString = [formatter stringFromDate:date];
        
        for (__strong UIImage *image in images) {
            NSString *fileName = [NSString stringWithFormat:@"%@%d.png",dateString,i];
//            image = [Tools imageWithImageSimple:image scaledToSize:CGSizeMake(120, 120)];
            NSData *imageData;
            if ([image isKindOfClass:[NSData class]]) {
                NSData *data = (NSData *)image;
               image =  [UIImage imageWithData:data];
            }
            if([image isKindOfClass:[UIImage class]]){
                    imageData = UIImageJPEGRepresentation(image, 0.5);
                [formData appendPartWithFileData:imageData name:names[i] fileName:fileName mimeType:@"image/jpg/png/jpeg"];
            }
            i ++;
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"Result:%@ ",responseObject);
        
        [Tools hideHud];
        [Tools showMessage:@"请求成功"];
        if (apiSuccess) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if([[dict objectForKey:@"resultCode"]integerValue] == 0){
                apiSuccess([dict objectForKey:@"data"]);
            }else if([[dict objectForKey:@"resultCode"]integerValue] == 110 ||
                       [[dict objectForKey:@"resultCode"]integerValue] == 111){//辣鸡代码
                NSMutableDictionary * newDic = [NSMutableDictionary dictionaryWithDictionary:[dict objectForKey:@"data"]];
                [newDic setObject:[[dict objectForKey:@"resultCode"] stringValue] forKey:@"resultCode"];
                apiSuccess(newDic);
            }else{
                [Tools showMessage:[dict objectForKey:@"resultMessage"]];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [Tools hideHud];
        [Tools showMessage:@"请求失败"];
        if (failure) {
            failure(task,error);
        }
    }];
}

+(void)getAvatar:(NSString *)url
        parameters:(id)parameters
              success:(void (^)(id data))apiSuccess
                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSLog(@"postToUrl:%@ \nparameters:%@",url,parameters);
    
    NSDictionary * dic = @{@"version":@"1.0",
                           @"from":@"terminal",
                           @"timestamp":[self getNowTimestamp],
                           @"data":parameters == nil?@"":parameters};
    
    url = [NSString stringWithFormat:@"%@%@",BASE_URL,url];
    
    AFHTTPSessionManager *manager = [AFManager shareManager];;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 12.f;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json",@"text/plain",@"text/json",@"text/html",@"image/jpeg", nil];
    //https ssl 验证。
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (apiSuccess) {
            apiSuccess(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {}];
}

+ (void)uploadPhoneData:(NSDictionary *)dic{
    
    NSDictionary * dicc = @{@"version":@"1.0",
                            @"from":@"terminal",
                            @"timestamp":[self getNowTimestamp],
                            @"data":dic == nil?@"":dic};
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,@"/shgkapp/shgkapi/v1/atLog.do"];
    
    AFHTTPSessionManager *manager = [AFManager shareManager];;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.f;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json",@"text/plain", @"text/json",@"text/html",@"image/jpeg", nil];
    //https ssl 验证。
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    [manager POST:urlStr parameters:dicc progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"系统日志上传失败");
            NSLog(@"%@",[error localizedDescription]);
            NSLog(@"error ==%@", [error userInfo][@"com.alamofire.serialization.response.error.string"]);
           NSLog(@"%@",[[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding]);
    }];
}


+(NSString *)getNowTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间
    NSLog(@"设备当前的时间:%@",[formatter stringFromDate:datenow]);
    //时间转时间戳的方法:
    NSInteger timeSp = [[NSNumber numberWithDouble:[datenow timeIntervalSince1970]] integerValue];
    NSTimeInterval time = timeSp  * 1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeStr = [NSString stringWithFormat:@"%.0f", time];
    NSLog(@"设备当前的时间戳:%ld",(long)timeStr); //时间戳的值
    return timeStr;
    
}

+(void)obtainDownloadFileAddressTransferURL:(NSString *)fileurl success:(void (^)(id data))apiSuccess
                                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFManager shareManager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 40.f;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json",@"text/plain",@"text/json",@"text/html",@"image/jpeg", nil];
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:fileurl]];
    
    NSURLSessionDownloadTask *downLoadTasks = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
//                NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *fullpath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        
                NSURL *fileUrl = [NSURL fileURLWithPath:fullpath];
        
//                NSLog(@"targetPath:%@\n fullpath:%@",targetPath,fullpath);
       
                return fileUrl;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        NSString *str = [filePath path];
        
        if (error == nil) {
            if (apiSuccess) {
                apiSuccess(str);
            }
        }else{
            if (failure) {
                failure(nil,error);
            }
        }
    }];
    
    [downLoadTasks resume];
}

+(void)requestPostCheckPgyUpdataWithApi:(NSString *)url success:(void (^)(id data))apiSuccess
                                failure:(void (^)(NSError *error))failure
{
    NSDictionary *headers = @{ @"Content-Type": @"application/x-www-form-urlencoded",
                               @"User-Agent": @"PostmanRuntime/7.15.2",
                               @"Accept": @"*/*",
                               @"Cache-Control": @"no-cache",
                               @"Postman-Token": @"2f95d207-fbfd-4f7a-90e2-da2afa84cf6c,507ff478-5321-4050-88bc-b580f3e7feb6",
                               @"Host": @"www.pgyer.com",
                               @"Cookie": @"pgyx2_session=T3NlhygygwO95OV21yBAy32evXC7l48w%2FAQNdRVqJh4sp55lks083feqiY5h9IEF81Q2GmvYsDjcnUjmw%2BMyHOZjz%2BFiJF%2BOlaVr9DHzIRsNszMbQ44RRQjF3XYv4cc7iWElIWez0FCrjvlia8%2B5oV2e3C3Mex5igHHACgv8%2FnpjO6HK78sGKTkVelxjtBC04jWEO8ZKXHy%2FVt90OYPDDLmjeQ8z60WHtLN4KXug41MkQsxtacRqlyNEuvISGp5lrVtcrnxfXpU%2FM5TTm97QgCG9yuqMQPcsJVlx0MgwN9yxySytZIORop2q5%2BpvRJf%2BHD1n5oGdDJvABveQQxK1k%2B%2FPuhulF%2Bamd08b4f4kExs2RTjmW9%2FHLKWM2nWc3ksP",
                               @"Accept-Encoding": @"gzip, deflate",
                               @"Content-Length": @"96",
                               @"Connection": @"keep-alive",
                               @"cache-control": @"no-cache" };
    
    NSMutableData *postData = [[NSMutableData alloc] initWithData:[@"_api_key=2a81b0bf2872f242b0909904b36f3b29" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"&appKey=%@",PGY_APPID] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"&buildVersion=1" dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.pgyer.com/apiv2/app/check"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:20.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                    } else {
                                                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                                                        //                                                        NSLog(@"data\ndata\ndata\ndata:\n%@",dict);
                                                        
                                                        if ([[dict objectForKey:@"code"] intValue] == 0) {
                                                            apiSuccess([dict objectForKey:@"data"]);
                                                        }
                                                    }
                                                }];
    [dataTask resume];
    
}


@end
