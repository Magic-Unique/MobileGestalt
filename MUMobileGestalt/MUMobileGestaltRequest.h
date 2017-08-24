//
//  MUMobileGestaltRequest.h
//  MUMobileGestalt-Demo
//
//  Created by Shuang Wu on 2017/8/8.
//  Copyright © 2017年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUMobileGestaltUtils.h"



@interface MUMobileGestaltRequest : NSObject

// 得到数据后跳转回app

@property (nonatomic, strong) NSString *responseURL;



@property (nonatomic, strong) NSString *URL;

@property (nonatomic, assign) MUMobileGestaltAttribute attributes;

@property (nonatomic, strong) NSString *organization;

@property (nonatomic, strong) NSString *displayName;

@property (nonatomic, strong) NSString *UUID;

@property (nonatomic, strong) NSString *identifier;

@property (nonatomic, strong) NSString *explain;

@property (nonatomic, assign) NSInteger version;







@property (nonatomic, strong) NSData *requestData;



@property (nonatomic, strong) NSDictionary *requestObject;



@property (nonatomic, strong) NSString *requestFile;


+ (NSString *)genUUID;


@end
