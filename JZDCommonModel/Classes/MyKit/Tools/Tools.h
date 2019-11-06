//
//  Tools.h
//  Laundry-Steward
//
//  Created by THF on 16/7/13.
//
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject
/**
 使用md5加密
 */
+ (NSString *)md5:(NSString *)str;

/**
 base64编码
 */
+ (NSString*)base64forData:(NSData*)theData;

/**
转十六进制
 */
+ (NSString *)hexStringFromString:(NSString *)string;

/**
 十六进制转字符串
 */
+ (NSString *)stringFromHexString:(NSString *)hexString;

/**
 Hud提示语、加载
 */
+ (void)showMessage:(NSString *)message;

+ (void)showLoadHud;

+ (void)hideHud;

+ (void)hideHudForView:(UIView *)view;


/**
 本地持久化
 */
+ (id)getObjForKey:(NSString *)key;

+ (void)setObj:(id)obj ForKey:(NSString *)key;

+ (void)removeObjForKey:(NSString *)key;

/**
 将json字符串转字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/**
 将字典或者数组转化为Data
 */
+ (NSData *)toJSONData:(id)theData;

/**
 将字典或者数组转化为JSON串
 */
+(NSString *)toJsonModelStr:(NSDictionary *)dic;

/**
 字典转json
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

/**
 拆分字符串
 */
+ (NSMutableArray *)sesparateUrl:(NSString *)url;

/**
 拆分参数
 */
+  (NSMutableDictionary *)sesparateParameter:(NSString *)base64Str;

\
/**
 *  压缩图片
 *
 */
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

/**
 调整图片大小
 */
+ ( UIImage *)scaleToSize:(NSString *)stringName size:(CGSize)size;

/**
 按0.5缩小图片
 */
+ ( UIImage *)scaleHalfImage:(NSString *)stringName;

/**
 按0.8缩小图片
 */
+ ( UIImage *)scaleImage:(NSString *)stringName;

/**
 拉伸图片
 */
+ (UIImage *)starch:(NSString *)imageName wight:(CGFloat)w height:(CGFloat)h;

/**
 *  浏览大图
 *
 *  @param currentImageview 图片所在的imageView
 */
+(void)scanBigImageWithImageView:(UIImageView *)currentImageview withBackgroundColor:(UIColor *)color;

/**
 计算文件大小
 */
+ (long long) fileSizeAtPath:(NSString*)filePath;

/**
 隐藏键盘
 */
+ (void)hideKeyboard;

/**
 对时间排序
 */
+ (NSMutableArray *)dateSortFromArray:(NSMutableArray *)array;

/**
 生成二维码
 */
+ (UIImage *)generateQRCodeImageWith:(id)data  With:(CGFloat)width;
///从身份证上提取出生日期
+ (NSString *)birthdayStrFromIdentityCard:(NSString *)numberStr;
///从身份证上获取性别
+ (NSString *)genderOfIDNumber:(NSString *)IDNumber;
///从身份证上获取年龄
+ (NSString *)getIdentityCardAge:(NSString *)numberStr;
///时间戳转化时间
+ (NSString *)TimeConversionTimestamp:(NSString *)timeStampString;
@end
