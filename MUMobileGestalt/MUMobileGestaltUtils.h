//
//  MUMobileGestaltUtils.h
//  MUMobileGestalt-Demo
//
//  Created by Shuang Wu on 2017/8/24.
//  Copyright © 2017年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MUMobileGestaltAttribute) {
    MUMobileGestaltAttributeUDID       = 1 << 0,
    MUMobileGestaltAttributeIMEI       = 1 << 1,
    MUMobileGestaltAttributeICCID      = 1 << 2,
    MUMobileGestaltAttributeVersion    = 1 << 3,
    MUMobileGestaltAttributeProduct    = 1 << 4,
    MUMobileGestaltAttributeAll        = 0x1F,
};

FOUNDATION_EXTERN NSArray *JSONFromAttributtes(MUMobileGestaltAttribute attributes);

FOUNDATION_EXTERN NSString *const MUMobileGestaltServerMobileConfigURL;

FOUNDATION_EXTERN NSString *const MUMobileGestaltServerRegisterPath;
FOUNDATION_EXTERN NSString *const MUMobileGestaltServerRegisterURL;

@interface MUMobileGestaltUtils : NSObject

@end
