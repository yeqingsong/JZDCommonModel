//
//  DeviceProxy.m
//  WarmHome
//
//  Created by huafangT on 16/11/3.
//
//

#import "DeviceProxy.h"
#import "MyKeychain.h"

#define kDeviceProxyLUIDKey @"com.goldShield.luid"

@implementation DeviceProxy
+ (NSString *)LUID
{
    MyKeychain *kc = [[MyKeychain alloc] init];
    NSString * k = [kc load:kDeviceProxyLUIDKey];
    if(!k){
        k = @"iOS模拟器";
    }
    return k;
}

+ (void)saveLUID:(NSString *)LUID
{
    MyKeychain *kc = [[MyKeychain alloc] init];
    [kc save:kDeviceProxyLUIDKey data:LUID];
}

+ (void)registerDevice
{
    if (0 == self.LUID.length) {
        CFUUIDRef uuid = CFUUIDCreate(nil);
        NSString *uuidString = (__bridge NSString*)CFUUIDCreateString(nil, uuid);
        CFRelease(uuid);
        
        [self saveLUID:uuidString];
    }
}

+ (NSString *)getPhoneModel
{
    return [[UIDevice currentDevice] model];
}

+ (NSString *)getPhoneBrand
{
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString *)getIDFV
{
   return  [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

@end
