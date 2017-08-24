//
//  NSString+MUUUID.h
//  MUMobileGestalt-Demo
//
//  Created by Shuang Wu on 2017/8/8.
//  Copyright © 2017年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MUUUID)

+ (instancetype)mumg_UUID;

+ (instancetype)mumg_UUIDWithBundleIdentifier:(NSString *)bundleIdentifier;

@end
