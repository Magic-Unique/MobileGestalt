//
//  MUMobileGestaltUtils.m
//  MUMobileGestalt-Demo
//
//  Created by Shuang Wu on 2017/8/24.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "MUMobileGestaltUtils.h"

NSArray *JSONFromAttributtes(MUMobileGestaltAttribute attributes) {
    NSMutableArray *JSON = [NSMutableArray array];
#define AppendAttribute(key, value) if ((attributes & MUMobileGestaltAttribute##key) == MUMobileGestaltAttribute##key) {[JSON addObject:@#value];}
    AppendAttribute(UDID, UDID)
    AppendAttribute(IMEI, IMEI);
    AppendAttribute(ICCID, ICCID);
    AppendAttribute(Version, VERSION)
    AppendAttribute(Product, PRODUCT)
#undef AppendAttribute
    return [JSON copy];
}

NSString *const MUMobileGestaltServerMobileConfigURL = @"http://localhost:8088/mobilegestalt/request.mobileconfig";

NSString *const MUMobileGestaltServerRegisterPath = @"/udid/check";
NSString *const MUMobileGestaltServerRegisterURL = @"http://localhost:8088/udid/check";

@implementation MUMobileGestaltUtils

@end
