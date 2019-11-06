//
//  Tools.m
//  Laundry-Steward
//
//  Created by THF on 16/7/13.
//
//

#import "Tools.h"
#import "MBProgressHUD.h"
#import "CIImage+Extension.h"
#import <CommonCrypto/CommonDigest.h>
#import "UIViewExt.h"
#import "MyUIKit.h"
@implementation Tools


/**
 使用md5加密
 */
+(NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


/**
 base64编码
 */
+ (NSString*)base64forData:(NSData*)theData {
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i,i2;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        for (i2=0; i2<3; i2++) {
            value <<= 8;
            if (i+i2 < length) {
                value |= (0xFF & input[i+i2]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    NSString * base64Str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //转16进制
    NSString * hexStr = [self hexStringFromString:base64Str];
    return hexStr;
}

//将NSString转换成十六进制的字符串则可使用如下方式:
+ (NSString *)convertStringToHexStr:(NSString *)str {
    if (!str || [str length] == 0) {
        return @"";
    }
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}

/**
 字符串转十六进制
 */
+ (NSString *)hexStringFromString:(NSString *)string
{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr]; 
    } 
    return hexStr; 
}

/**
 十六进制转字符串
 */
+ (NSString *)stringFromHexString:(NSString *)hexString
{
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr] ;
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    return unicodeString;
}


/**
 Hud提示语、加载
 */
+ (MBProgressHUD *)shareMBHUD
{
    static MBProgressHUD * hud;
    static dispatch_once_t oneceToken;
    dispatch_once(&oneceToken, ^{
        hud = [[MBProgressHUD alloc]init];
    });
    return hud;
}

+ (void)showMessage:(NSString *)message
{
    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.userInteractionEnabled = NO;
    
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = message;
    hud.detailsLabelFont = [UIFont systemFontOfSize:16];
    hud.margin = 10.f;
    hud.yOffset = 0.0f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:2];
}

+ (void)showLoadHud
{
    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.userInteractionEnabled = YES;//YES才为不可点
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载中";
    hud.graceTime = 0.6;//加载在0.6s内完成则不显示加载
    hud.margin = 10.f;
    hud.yOffset = 0.0f;
    hud.removeFromSuperViewOnHide = YES;
}

+ (void)hideHud
{
   [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:NO];
}

+ (void)hideHudForView:(UIView *)view
{
    [MBProgressHUD hideHUDForView:view animated:YES];
}

/**
 本地持久化
 */
+ (id)getObjForKey:(NSString *)key
{
    NSUserDefaults * s = [NSUserDefaults standardUserDefaults];
    return  [s objectForKey:key] == nil?@"":[s objectForKey:key];
}

+ (void)setObj:(id)obj ForKey:(NSString *)key
{
    NSUserDefaults * s = [NSUserDefaults standardUserDefaults];
    [s setObject:obj forKey:key];
    [s synchronize];
}

+ (void)removeObjForKey:(NSString *)key
{
    NSUserDefaults * s = [NSUserDefaults standardUserDefaults];
    [s removeObjectForKey:key];
    [s synchronize];
}

/**
 将json字符串转字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err){
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

/**
 将字典或者数组或NSString转化为Data
 */
+ (NSData *)toJSONData:(id)theData{
    
    NSError *parseError = nil;
    NSData *jsonData = nil;
    if([theData isKindOfClass:[NSString class]]){
         jsonData= [theData dataUsingEncoding:NSUTF8StringEncoding];
    }else{
        if (theData) {
            jsonData = [NSJSONSerialization dataWithJSONObject:theData options:NSJSONWritingPrettyPrinted error:&parseError];
        }
        
    }
    if ([jsonData length]!= 0){
        return jsonData;
    }else{
        return [NSData data];
    }
}

/**
 将字典或者数组转化为JSON字符串
 */
+(NSString *)toJsonModelStr:(NSDictionary *)dic
{
    if ([NSJSONSerialization isValidJSONObject:dic])
    {
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString * jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        jsonStr = [jsonStr stringByAppendingString:@"\n"];
        return jsonStr;
    }
    return nil;
}

/**
字典转json
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:nil error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma - mark 拆分url,只返回参数
+ (NSMutableArray *)sesparateUrl:(NSString *)url
{
    int count = 0;
    NSMutableArray * allArr = [NSMutableArray array];
    NSArray * arr = [NSArray array];
    for (int i = 1; i <20; i++) {
        
        NSString * pStr = [NSString stringWithFormat:@"p%d=",i];
        if([url rangeOfString:pStr].location!= NSNotFound){
            count++;
        }
    }
    
    url = [[url componentsSeparatedByString:@"p1="]lastObject];
    
    for(int i = 1; i <= count; i++){
        arr = [url componentsSeparatedByString:[NSString stringWithFormat:@"&p%d=",i+1]];
        url = [arr lastObject];
        NSString * urlStr = [arr.firstObject stringByReplacingOccurrencesOfString:@"|" withString:@"%7c"];
        [allArr addObject:urlStr];
    }
    return allArr;
}

//拆分参数
+  (NSMutableDictionary *)sesparateParameter:(NSString *)base64Str
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    NSArray * array = [base64Str componentsSeparatedByString:@","];
    
    for(NSString * str in array){
        NSArray * a = [str componentsSeparatedByString:@":"];
        [dic setObject:a.lastObject forKey:a.firstObject];
    }
    
    return dic;
}


+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

/**
 *  压缩图片
 */
+ (UIImage *)scaleImage:(UIImage *)image withScale:(CGFloat)scale
{
    CGSize size = CGSizeMake(image.size.width * scale, image.size.height *scale);
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

/**
 调整图片大小
 */
+ (UIImage *)scaleToSize:(NSString *)stringName size:(CGSize)size{
    
    UIImage *img = [UIImage imageNamed:stringName];
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
    
}

/**
 按0.5缩小图片
 */
+ ( UIImage *)scaleHalfImage:(NSString *)stringName {
    
    UIImage *img = [UIImage imageNamed:stringName];
    CGSize size = img.size;
    size = CGSizeMake(size.width * 0.5, size.height * 0.5);
    
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

/**
 按0.8缩小图片
 */
+ ( UIImage *)scaleImage:(NSString *)stringName {
    
    UIImage *img = [UIImage imageNamed:stringName];
    CGSize size = img.size;
    size = CGSizeMake(size.width * 0.8, size.height * 0.8);
    
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

/**
 拉伸图片
 */
+ (UIImage *)starch:(NSString *)imageName wight:(CGFloat)w height:(CGFloat)h
{
    UIImage *image =[UIImage imageNamed:imageName];
    image = [image stretchableImageWithLeftCapWidth:w topCapHeight:h];
    return image;
}

/**
 *  浏览大图
 *
 *  @param currentImageview 图片所在的imageView
 */
static CGRect oldFrame;//原始尺寸
static UIView * backgroundView;

+(void)scanBigImageWithImageView:(UIImageView *)currentImageview withBackgroundColor:(UIColor *)color{
    //当前imageview的图片
    UIImage *image = currentImageview.image;
    if(!image){
        [Tools showMessage:@"暂无图片显示"];
        return;
    }
    //当前视图
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //背景
   backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    //当前imageview的原始尺寸->将像素currentImageview.bounds由currentImageview.bounds所在视图转换到目标视图window中，返回在目标视图window中的像素值
    //oldFrame = [currentImageview convertRect:currentImageview.bounds toView:window];
    oldFrame = backgroundView.frame;
    [backgroundView setBackgroundColor:color];
    //此时视图不会显示
    [backgroundView setAlpha:0];
    //将所展示的imageView重新绘制在Window中
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:oldFrame];
    [imageView setImage:image];
    [imageView setTag:0];
    [backgroundView addSubview:imageView];
    //将原始视图添加到背景视图中
    [window addSubview:backgroundView];
    
    
    //添加点击事件同样是类方法 -> 作用是再次点击回到初始大小
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImageView:)];
    [backgroundView addGestureRecognizer:tapGestureRecognizer];
    
    //缩放手势
    UIPinchGestureRecognizer * pinGestureRecognizer = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchAct:)];
    [backgroundView addGestureRecognizer:pinGestureRecognizer];
    
    //拖拉
    UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAct:)];
    [backgroundView addGestureRecognizer:panGestureRecognizer];
    
    //动画放大所展示的ImageView
    
    [UIView animateWithDuration:0.4 animations:^{
        CGFloat y,width,height;
        y = ([UIScreen mainScreen].bounds.size.height - image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width) * 0.5;
        //宽度为屏幕宽度
        width = [UIScreen mainScreen].bounds.size.width;
        //高度 根据图片宽高比设置
        height = image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width;
        [imageView setFrame:CGRectMake(0, y, width, height)];
        //重要！ 将视图显示出来
        [backgroundView setAlpha:1];
    } completion:^(BOOL finished) {
        
    }];
}

/**
 *  缩放imageView尺寸
 *
 *  @param pinchGesture 缩放事件
 */
+ (void)pinchAct:(UIPinchGestureRecognizer*)pinchGesture{
    UIView *view = pinchGesture.view;
    if (pinchGesture.state == UIGestureRecognizerStateBegan || pinchGesture.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGesture.scale, pinchGesture.scale);
        if (backgroundView.frame.size.width <= oldFrame.size.width ) {
            [UIView beginAnimations:nil context:nil]; // 开始动画
            [UIView setAnimationDuration:0.5f]; // 动画时长
            /**
             *  固定一倍
             */
            backgroundView.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
            [UIView commitAnimations]; // 提交动画
        }
        if (backgroundView.frame.size.width > 2 * oldFrame.size.width) {
            [UIView beginAnimations:nil context:nil]; // 开始动画
            [UIView setAnimationDuration:0.5f]; // 动画时长
            /**
             *  固定二倍
             */
            backgroundView.transform = CGAffineTransformMake(2, 0, 0, 2, 0, 0);
            [UIView commitAnimations]; // 提交动画
        }
        if (backgroundView.x > 0 ) {
            backgroundView.x = 0 ;
        }
        if (backgroundView.y > 0){
            backgroundView.y = 0;
        }
        if(backgroundView.right <ScreenWidth){
            backgroundView.right = ScreenWidth;
        }
        if(backgroundView.bottom < ScreenHeight){
            backgroundView.bottom = ScreenHeight;
        }
        
        pinchGesture.scale = 1;
    }
}

/**
 *  拖拉imageView
 *
 *  @param panGestureRecognizer 拖拉事件
 */
+ (void) panAct:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = panGestureRecognizer.view;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
        
        [UIView beginAnimations:nil context:nil]; // 开始动画
        [UIView setAnimationDuration:0.5f]; // 动画时长
        if (backgroundView.x > 0 ) {
            backgroundView.x = 0 ;
        }
        if (backgroundView.y > 0){
            backgroundView.y = 0;
        }
        if(backgroundView.right <ScreenWidth){
            backgroundView.right = ScreenWidth;
        }
        if(backgroundView.bottom < ScreenHeight){
            backgroundView.bottom = ScreenHeight;
        }
        
        [UIView commitAnimations]; // 提交动画
    }
}

/**
 *  恢复imageView原始尺寸
 *
 *  @param tap 点击事件
 */
+(void)hideImageView:(UITapGestureRecognizer *)tap{
    UIView *backgroundView = tap.view;
    //原始imageview
    UIImageView *imageView = [tap.view viewWithTag:0];
    //恢复
    [backgroundView setAlpha:0];
    [UIView animateWithDuration:0.4 animations:^{
        [imageView setFrame:oldFrame];
    
    } completion:^(BOOL finished) {
        //完成后操作->将背景视图删掉
        [backgroundView removeFromSuperview];
    }];
}


/**
 隐藏键盘
 */
+ (void)hideKeyboard
{
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    UIResponder *responder = [win performSelector:@selector(firstResponder)];
    [responder resignFirstResponder];
}

/**
获取UUID  已废弃
 */
+ (NSString *)getUUIDString
{
    CFUUIDRef uuid = CFUUIDCreate(nil);
    NSString *uuidString = (__bridge NSString*)CFUUIDCreateString(nil, uuid);
    CFRelease(uuid);
    return uuidString;
}

/**
 计算文件大小
 */
+ (long long) fileSizeAtPath:(NSString*)filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        
    }else{
        NSLog(@"计算文件大小：文件不存在");
    }
    return 0;
}

/**
 对时间排序
 */
+ (NSMutableArray *)dateSortFromArray:(NSMutableArray *)array
{
    NSArray *sortDescriptors = [NSArray arrayWithObject:[[NSSortDescriptor alloc ]initWithKey:@"TIME" ascending:YES]];
    [array sortUsingDescriptors:sortDescriptors];
    return array;
}

/**
 手机号
 */
+ (BOOL) IsPhoneNumber:(NSString *)number
{
    NSString *phoneRegex1=@"1[34578]([0-9]){9}";
    NSPredicate *phoneTest1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex1];
    return  [phoneTest1 evaluateWithObject:number];
}

/**
 生成二维码
 */
+ (UIImage *)generateQRCodeImageWith:(id)data  With:(CGFloat)width
{
    // 1.创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.恢复默认设置
    [filter setDefaults];
    
    // 3.设置数据
    [filter setValue:[self toJSONData:data] forKeyPath:@"inputMessage"];
    
    // 4.生成二维码
    CIImage *outputImage = [filter outputImage];
    
    return [outputImage createNonInterpolatedWithSize:width];
}
+ (NSString *)TimeConversionTimestamp:(NSString *)timeStampString{
    // timeStampString 是服务器返回的13位时间戳
    //    NSString *timeStampString  = @"1495453213000";
    if (timeStampString.length == 0) {
        return @"";
    }
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    =[timeStampString doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString       = [formatter stringFromDate: date];
    return dateString;
}
///从身份证上提取出生日期
+ (NSString *)birthdayStrFromIdentityCard:(NSString *)numberStr
{
    NSMutableString *result = [NSMutableString stringWithCapacity:0];
    NSString *year = nil;
    
    NSString *month = nil;
    BOOL isAllNumber = YES;
    NSString *day = nil;
    
    if([numberStr length]<18) return result;
    
    //**从第6位开始 截取8个数
    
    NSString *fontNumer = [numberStr substringWithRange:NSMakeRange(6, 8)];
    //**检测前12位否全都是数字;
    
    const char *str = [fontNumer UTF8String];
    
    const char *p = str;
    
    while (*p!='\0') {
        
        if(!(*p>='0'&&*p<='9'))
            
            isAllNumber = NO;
        
        p++;
        
    }
    
    if(!isAllNumber) return result;
        
       
 
    year = [NSString stringWithFormat:@"19%@",[numberStr substringWithRange:NSMakeRange(8, 2)]];
    month = [numberStr substringWithRange:NSMakeRange(10, 2)];
    day = [numberStr substringWithRange:NSMakeRange(12,2)];

    [result appendString:year];
    
    [result appendString:@"-"];
    
    [result appendString:month];
    
    [result appendString:@"-"];
    
    [result appendString:day];
    
    //    NSLog(@"result===%@",result);
    return result;
}

+ (NSString *)genderOfIDNumber:(NSString *)IDNumber
{
    //  记录校验结果：0未知，1男，2女
    NSString* result = @"未知";
    NSString *fontNumer = nil;
    
    if (IDNumber.length == 15)
    { // 15位身份证号码：第15位代表性别，奇数为男，偶数为女。
        fontNumer = [IDNumber substringWithRange:NSMakeRange(14, 1)];
        
    }else if (IDNumber.length == 18)
    { // 18位身份证号码：第17位代表性别，奇数为男，偶数为女。
        fontNumer = [IDNumber substringWithRange:NSMakeRange(16, 1)];
    }else
    { //  不是15位也不是18位，则不是正常的身份证号码，直接返回
        return result;
    }
    
    NSInteger genderNumber = [fontNumer integerValue];
    
    if(genderNumber % 2 == 1){
//        result = 1;
        result = @"男";
    }else if (genderNumber % 2 == 0){
//        result = 2;
        result = @"女";
    }
       
    
    
    
    
    
    return result;
}
+ (NSString *)getIdentityCardAge:(NSString *)numberStr
{
    
    NSDateFormatter *formatterTow = [[NSDateFormatter alloc]init];
    [formatterTow setDateFormat:@"yyyy-MM-dd"];
    NSDate *bsyDate = [formatterTow dateFromString:[Tools birthdayStrFromIdentityCard:numberStr]];
    
    NSTimeInterval dateDiff = [bsyDate timeIntervalSinceNow];
    
    int age = trunc(dateDiff/(60*60*24))/365;
    
    return [NSString stringWithFormat:@"%d",-age];
}

@end
