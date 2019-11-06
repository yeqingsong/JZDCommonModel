//
//  CameraManager.h
//  aaaaa
//
//  Created by huafangT on 17/7/25.
//  Copyright © 2017年 huafangT. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CameraManagerDelegate <NSObject>

- (UIImage *)getFuckImg;

@end

typedef void(^PickImgBlock)(UIImage * img);

@interface CameraManager : NSObject

+ (CameraManager *)shareInstance;

- (void)startWork:(PickImgBlock)imgBlock;
+ (NSData *)compressImage:(UIImage *)image ToMaxSize:(NSInteger)size;
@end
