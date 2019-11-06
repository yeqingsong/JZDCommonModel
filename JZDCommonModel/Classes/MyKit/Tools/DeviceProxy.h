//
//  DeviceProxy.h
//  WarmHome
//
//  Created by huafangT on 16/11/3.
//
//

#import <Foundation/Foundation.h>

@interface DeviceProxy : NSObject

+ (void)registerDevice;
+ (NSString *)LUID;

+ (NSString *)getPhoneModel;
+ (NSString *)getPhoneBrand;
+ (NSString *)getIDFV;
@end
