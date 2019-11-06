//
//  NSURLRequest+Https.m
//  WarmHome
//
//  Created by 方 on 17/2/27.
//
//

#import "NSURLRequest+Https.h"

@implementation NSURLRequest (Https)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host
{
    return YES;
}

@end
