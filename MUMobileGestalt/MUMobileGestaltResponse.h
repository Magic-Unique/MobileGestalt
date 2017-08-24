//
//  MUMobileGestaltResponse.h
//  MUMobileGestalt-Demo
//
//  Created by Shuang Wu on 2017/8/24.
//  Copyright © 2017年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUMobileGestaltUtils.h"

@interface MUMobileGestaltResponse : NSObject

@property (nonatomic, strong, readonly) NSError *error;

@property (nonatomic, strong, readonly) NSDictionary *JSON;

- (instancetype)initWithJSON:(NSDictionary *)JSON error:(NSError *)error;

- (instancetype)initWithJSON:(NSDictionary *)JSON;

- (instancetype)initWithData:(NSData *)data;

- (instancetype)initWithDescription:(NSString *)description reason:(NSString *)reason suggestion:(NSString *)suggestion;

- (NSString *)contentOf:(MUMobileGestaltAttribute)attribute;

@end
