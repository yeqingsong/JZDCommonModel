//
//  MyUIKit.h
//  ICanDoThis
//
//  Created by THF on 16/8/19.
//  Copyright © 2016年 thf. All rights reserved.
//


#pragma mark -
#pragma mark Base URL
#if DEBUG
//#define BASE_URL @"https://192.168.1.89:46888"//明朝测试 (本地内网环境)
//#define BASE_URL @"https://unis-ct.3322.org:46888"//南京测试
//#define BASE_URL @"https://101.254.233.218:8448"//明朝测试（外网环境）//now

//#define BASE_URL @"https://101.254.233.218:8449"//明朝测试（外网环境）//now 8448
#define BASE_URL @"https://113.108.173.202:46888"//正式
#else
#define BASE_URL @"https://113.108.173.202:46888"//正式
#endif


#define PGY_APPID @"e5d09c2323c3ef8ef6a1efac239e041c"

#pragma mark -
#pragma mark  用户配置相关的key

//个人信息
#define USERMODEL @"userModel"
#define USERAVATAR  @"userAvatar"

//手机信息
#define LATITUDE  @"latitude"
#define LONGITUDE @"longitude"
#define ADDRESS @"address"
#define USERID @"userId"
#define MODEL @"model"
#define BRAND @"brand"
#define DEVICEID @"deviceId"
#define MAC @"mac"

#define DATATYPEPERSONNELSTATISTICS @"人员统计"
#define DATATYPEAPPLIICATION @"我的应用"
#define DATATYPEMANAGEMENT @"数据管理"
#define DATATYPEDRUGRESOURCES @"禁毒资源"

#define DATAONE @"1"
#define DATATWO @"2"
#define DATATHREE @"3"
#define DATAFOUR @"4"

//上传照片
#define UploadUrl(ServerIP) [NSString stringWithFormat:@"http://%@:8081/guardsysweb/file/upload/", ServerIP]

#define GZ_DB @"GZDataBase"  //数据库名
#define TABLE_RECORDER @"tbl_recorder" //表名

//表名
#define t_schedule @"t_schedule"   //日程表
#define t_digestmd5 @"t_digestmd5" //MD5摘要表


//通知
#define kReceivePush       @"kReceivePush"
#define kWeatherLogin     @"kWeatherLogin"
#define kHideBottomBar   @"kHideBottomBar"
#define kDidLogin            @"kDidLogin"       
#define kMessageRefresh  @"kMessageRefresh"
#define kChangeSelectItem @"kChangeSelectItem"

#pragma mark -
#pragma mark - 判断版本

// 判断是否是iPhone X
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// 状态栏高度
#define STATUS_BAR_HEIGHT (iPhoneX ? 44.f : 20.f)
// 导航栏高度
#define NAVIGATION_BAR_HEIGHT (iPhoneX ? 88.f : 64.f)
// tabBar高度
#define TAB_BAR_HEIGHT (iPhoneX ? (49.f+34.f) : 49.f)
// home indicator
#define HOME_INDICATOR_HEIGHT (iPhoneX ? 34.f : 0.f)

#define VERSION_BRAND ([[UIDevice currentDevice] model])   //iphone

#define VERSION ([[UIDevice currentDevice] systemVersion])   //10.1

#define VERSION_NAME  ([[UIDevice currentDevice] systemName]) //iOS

#define VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define TLog(_var) ({ NSString *name = @#_var; NSLog(@"%@: %@ -> %p : %@  %d", name, [_var class], _var, _var, (int)[_var retainCount]); })


#pragma mark -
#pragma mark - 颜色和字体
#define  random(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define randomColor random(arc4random_uniform(240),arc4random_uniform(240),arc4random_uniform(240))

#define UIColorFromHexWithAlpha(hexValue,a) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:a]
#define UIColorFromHex(hexValue) UIColorFromHexWithAlpha(hexValue,1.0)
#define UIColorFromRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define UIColorFromRGB(r,g,b) UIColorFromRGBA(r,g,b,1.0)

#define AppTextColor UIColorFromRGBA(27.0, 118.0, 208.0, 1)

#define font(s) [UIFont systemFontOfSize:s+1]

#define font_bold(s) [UIFont boldSystemFontOfSize:s+1]

#pragma mark -
#pragma mark weakSelf
/**
 Synthsize a weak or strong reference.
 
 Example:
 @weakify(self)
 [self doSomething^{
 @strongify(self)
 if (!self) return;
 ...
 }];
 
 */
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

#pragma mark -
#pragma mark Frame Geometry

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define WIDTH(view) view.frame.size.width
#define HEIGHT(view) view.frame.size.height
#define LEFT(view) view.frame.origin.x
#define TOP(view) view.frame.origin.y
#define BOTTOM(view) (view.frame.origin.y + view.frame.size.height)
#define RIGHT(view) (view.frame.origin.x + view.frame.size.width)

//屏幕比例
#define KWidth_ScaleW ScreenWidth/375.0f
#define KWidth_ScaleH ScreenHeight/667.0f

#define KWFloat(a) a * KWidth_ScaleW
#define KHFloat(a) a * KWidth_ScaleH
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self
#pragma mark - 
#pragma mark Runtime set Property

#ifndef YYSYNTH_DYNAMIC_PROPERTY_OBJECT
#define YYSYNTH_DYNAMIC_PROPERTY_OBJECT(_getter_, _setter_, _association_, _type_) \
- (void)_setter_ : (_type_)object { \
[self willChangeValueForKey:@#_getter_]; \
objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_ ## _association_); \
[self didChangeValueForKey:@#_getter_]; \
} \
- (_type_)_getter_ { \
return objc_getAssociatedObject(self, @selector(_setter_:)); \
}
#endif



#pragma mark -
#pragma mark Center View

static inline void CenterView(UIView *v, UIView *superV)
{
    CGPoint origin = CGPointMake((WIDTH(superV)-WIDTH(v))/2,
                                 (HEIGHT(superV)-HEIGHT(v))/2);
    
    v.frame = CGRectMake(origin.x, origin.y, WIDTH(v), HEIGHT(v));
}

static inline void CenterViewX(UIView *v, UIView *superV)
{
    CGPoint origin = CGPointMake((WIDTH(superV)-WIDTH(v))/2,
                                 TOP(v));
    
    v.frame = CGRectMake(origin.x, origin.y, WIDTH(v), HEIGHT(v));
}


#pragma mark -
#pragma mark 提示框

static inline void ShowHud(NSString * infoString,BOOL isSuccess)
{
    __block UIView * bgView            = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor             = [UIColor blackColor];
    bgView.alpha                       = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    
    __block UIView * whiteView         = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 280, 130)];
    whiteView.backgroundColor          = [UIColor whiteColor];
    CenterView(whiteView, bgView);
    whiteView.layer.cornerRadius       = 10;
    whiteView.layer.masksToBounds      = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:whiteView];
    
    
    __block UIImageView * blackImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:isSuccess == YES?@"common_success_icon.png" :@"common_jinggao_icon.png" ]];
    blackImgView.frame                 = CGRectMake(0,30, 30, 30);
    CenterViewX(blackImgView, whiteView);
    [whiteView addSubview:blackImgView];
    
    __block UITextView * infoView       = [[UITextView alloc]initWithFrame:CGRectMake(0, 80,270, 65)];
    if(infoString.length > 32){
        infoView.frame = CGRectMake(0,60,270,65);
    }
    infoView.userInteractionEnabled = NO;
    CenterViewX(infoView, whiteView);
    infoView.textAlignment            = NSTextAlignmentCenter;
    infoView.text                     = infoString;
    infoView.font                     = [UIFont systemFontOfSize:16];
    infoView.textColor                = UIColorFromHex(0x333333);
    [whiteView addSubview:infoView];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        bgView.alpha = 0.3;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            bgView.alpha       = 0;
            infoView.alpha    = 0;
            blackImgView.alpha = 0;
            whiteView.alpha    = 0;
            bgView.alpha       = 0;
            
        } completion:^(BOOL finished) {
            
            [infoView removeFromSuperview];
            [blackImgView removeFromSuperview];
            [whiteView removeFromSuperview];
            [bgView removeFromSuperview];
        }];
    }];
}

#pragma mark -
#pragma mark Get Text Height

static inline CGSize GetTextSize(NSString *txtContent, UIFont *f, CGFloat txtWidth)
{
    CGSize s;
    
    if (VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") == YES)
    {
        //给一个比较大的高度，宽度不变
        CGSize size = CGSizeMake(txtWidth,CGFLOAT_MAX);
        //    获取当前文本的属性
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:f, NSFontAttributeName, nil];
        //ios7方法，获取文本需要的size，限制宽度
        s = [txtContent boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
    }
    else
    {
        s = [txtContent sizeWithFont:f constrainedToSize:CGSizeMake(txtWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    }
    return s;
}


#pragma mark -
#pragma mark 暂无数据

static inline void ShowNoDataView(UIView *superV, NSString *imgName ,NSString *txt,BOOL isHidde)
{
    if (isHidde == YES)
    {
        [[superV viewWithTag:NSIntegerMax-1] removeFromSuperview];
        
        return ;
    }
    
    if ([superV viewWithTag:NSIntegerMax-1])
        return ;
    
    UIView *backView         = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenHeight)];
    backView.tag             = NSIntegerMax - 1;
    backView.backgroundColor = [UIColor colorWithWhite:0.969 alpha:1.000];
    
    // 文字
    CGFloat h           = GetTextSize(txt, [UIFont systemFontOfSize:15], ScreenWidth - 50).height;
    UILabel *label      = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 50, h + 30)];
    CenterView(label, backView);
    label.textAlignment = NSTextAlignmentCenter;
    label.text          = txt;
    label.numberOfLines = 0;
    label.textColor     = UIColorFromHex(0x9a9a9a);
    label.font          = [UIFont systemFontOfSize:15];
    [backView addSubview:label];
    
    // 图片 Y : TOP(label) - 50 - 20
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,100 , 150 , 250)];
    imageView.contentMode  = UIViewContentModeScaleAspectFill;
    CenterViewX(imageView, backView);
    imageView.image        = [UIImage imageNamed:imgName];
    [backView addSubview:imageView];
    
    [superV addSubview:backView];
}



#pragma mark -
#pragma mark 来自SDWebImage

#define dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}


#pragma mark -
#pragma mark 获取图片路径
#define HFAppImageFile(url) [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[url lastPathComponent]]



#define k_gray_127 UIColorFromRGBA(127, 127, 127, 1)
#define k_gray_200 UIColorFromRGBA(200, 200, 200, 1)

#define k_white_242 UIColorFromRGBA(242, 242, 242, 1)
#define k_white_255 UIColorFromRGBA(255, 255, 255, 1)
#define k_white_252 UIColorFromRGBA(252, 252, 252, 1)

#define k_black_0       UIColorFromRGBA(0, 0, 0, 1)
#define k_black_51      UIColorFromRGBA(51, 51, 51, 1)

#define k_black_0_trans60 UIColorFromRGBA(0, 0, 0, 0.6)

#define k_red_255 UIColorFromRGBA(255, 0, 0, 1)
#define k_blue_229 UIColorFromRGBA(48, 169, 229, 1)
#define k_green_ UIColorFromRGBA(0, 255, 0, 1)

