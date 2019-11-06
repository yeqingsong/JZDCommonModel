//
//  CameraManager.m
//  aaaaa
//
//  Created by huafangT on 17/7/25.
//  Copyright © 2017年 huafangT. All rights reserved.
//

#import "CameraManager.h"
#import "QPActionSheet.h"
#import <Photos/Photos.h>
#import "NSObject+CurrentC.h"
#import "Tools.h"
@interface CameraManager()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,QPActionSheetDelegate>

@property(nonatomic, strong)UIImagePickerController * pickerView;

@property (nonatomic, strong)UIViewController *currentVC;

@property(nonatomic, copy)PickImgBlock imgBlock;

@end

@implementation CameraManager

- (void)dealloc{
    
}

- (void)startWork:(PickImgBlock)imgBlock{
    self.imgBlock = imgBlock;
    QPActionSheet *sheet = [[QPActionSheet alloc] initWithTitleArray:@[@"拍照", @"从相册选择"] andDelegate:self];
    [sheet show];
}

#pragma mark -
#pragma mark QPActionSheet Delegate
- (void)selectAtIndexPath:(NSUInteger)index withSheet:(AHKActionSheet *)sheet{
    UIImagePickerControllerSourceType sourceType = index == 0?UIImagePickerControllerSourceTypeCamera:UIImagePickerControllerSourceTypePhotoLibrary;
    [self picSourceType:sourceType];
}

- (void)picSourceType:(UIImagePickerControllerSourceType)sourceType{
    if(sourceType == UIImagePickerControllerSourceTypeCamera){
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [Tools showMessage:@"您的设备不支持拍照功能"];
            return;
        }
    }
    
     PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied) {
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString *appName = [infoDict objectForKey:@"CFBundleDisplayName"];
         NSString *message = [NSString stringWithFormat:@"请前往 -> [设置 - 隐私 - 相机/照片 - %@ 打开访问开关", appName];
        [Tools showMessage:message];
        return;
    }
    
    self.pickerView.delegate = self;
    self.pickerView.sourceType = sourceType;
    if ([self.currentVC respondsToSelector:@selector(presentViewController:animated:completion:)]){
        [self.currentVC presentViewController:_pickerView animated:YES completion:nil];
    }
}

#pragma mark -
#pragma mark imagePick Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *pickerImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [[UIApplication sharedApplication] setStatusBarStyle:0    animated:YES];
    [picker dismissViewControllerAnimated:YES completion:^void{
        if(self.imgBlock){
            self.imgBlock(pickerImage);
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIImagePickerController *)pickerView{
    if(!_pickerView){
        _pickerView = [[UIImagePickerController alloc]init];
    }
    return _pickerView;
}

- (UIViewController *)currentVC{
    
    _currentVC = self.getCurrentViewController;
    
    return _currentVC;
}

+ (NSData *)compressImage:(UIImage *)image ToMaxSize:(NSInteger)size {
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSInteger maxFileSize = size * 1024;
    
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    
    while ([imageData length] > maxFileSize && compression > maxCompression)
    {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    return imageData;
}


+ (CameraManager *)shareInstance
{
    static CameraManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}


@end
