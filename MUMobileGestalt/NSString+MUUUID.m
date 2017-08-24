//
//  NSString+MUUUID.m
//  MUMobileGestalt-Demo
//
//  Created by Shuang Wu on 2017/8/8.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "NSString+MUUUID.h"
#import <CommonCrypto/CommonDigest.h>

#define Random(l) [self mumg_randomIdentifier:l]
#define Substr(f,l) [md5 substringWithRange:NSMakeRange(f, l)]

@implementation NSString (MUUUID)

+ (instancetype)mumg_UUID {
    return [self stringWithFormat:@"%@-%@-%@-%@-%@", Random(8), Random(4), Random(4), Random(4), Random(12)];
}

+ (instancetype)mumg_randomIdentifier:(NSUInteger)length {
    NSString *format = @"0123456789ABCDEF";
    NSMutableString *identifier = [NSMutableString stringWithCapacity:length];
    for (NSUInteger i = 0; i < length; i++) {
        NSUInteger index = arc4random()%format.length;
        NSString *ch = [format substringWithRange:NSMakeRange(index, 1)];
        [identifier appendString:ch];
    }
    return [identifier copy];
}

+ (instancetype)mumg_UUIDWithBundleIdentifier:(NSString *)bundleIdentifier {
    NSString *md5 = [bundleIdentifier mumg_MD5];
    NSString *uuid = [NSString stringWithFormat:@"%@-%@-%@-%@-%@", Substr(0, 8), Substr(8, 4), Substr(12, 4), Substr(16, 4), Substr(20, 12)];
    return uuid;
}

- (instancetype)mumg_MD5 {
    const char *cStr =[self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
