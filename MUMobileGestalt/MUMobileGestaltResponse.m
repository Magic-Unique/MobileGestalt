//
//  MUMobileGestaltResponse.m
//  MUMobileGestalt-Demo
//
//  Created by Shuang Wu on 2017/8/24.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "MUMobileGestaltResponse.h"

static NSDictionary *JSONFromASCIIData(NSData *data) {
    NSRange rangeBegin = [data rangeOfData:[@"<?xml version=\"1.0\"" dataUsingEncoding:NSASCIIStringEncoding] options:0 range:NSMakeRange(0, data.length)];
    NSRange rangeEnd = [data rangeOfData:[@"</plist>" dataUsingEncoding:NSASCIIStringEncoding] options:0 range:NSMakeRange(0, data.length)];
    NSData *plistData = [data subdataWithRange:NSMakeRange(rangeBegin.location, rangeEnd.location + rangeEnd.location - rangeBegin.location)];
    NSDictionary *plistDict = [NSPropertyListSerialization propertyListWithData:plistData options:0 format:NULL error:NULL];
    return plistDict;
}

@implementation MUMobileGestaltResponse

- (instancetype)initWithData:(NSData *)data {
    NSDictionary *JSON = JSONFromASCIIData(data);
    if (JSON) {
        self = [self initWithJSON:JSON];
    } else {
        self = [self initWithDescription:@"Fetch data failed." reason:@"Can not analyse the data." suggestion:@"Close all application and try it again."];
    }
    return self;
}

- (instancetype)initWithJSON:(NSDictionary *)JSON {
    self = [self initWithJSON:JSON error:nil];
    return self;
}

- (instancetype)initWithDescription:(NSString *)description reason:(NSString *)reason suggestion:(NSString *)suggestion {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[NSLocalizedDescriptionKey] = description;
    userInfo[NSLocalizedFailureReasonErrorKey] = reason;
    userInfo[NSLocalizedRecoverySuggestionErrorKey] = suggestion;
    NSError *error = [NSError errorWithDomain:@"com.unique.mobilegestalt" code:1 userInfo:[userInfo copy]];
    self = [self initWithJSON:nil error:error];
    return self;
}

- (instancetype)initWithJSON:(NSDictionary *)JSON error:(NSError *)error {
    self = [super init];
    if (self) {
        _JSON = [JSON copy];
        _error = [error copy];
    }
    return self;
}

- (NSString *)contentOf:(MUMobileGestaltAttribute)attribute {
    switch (attribute) {
        case MUMobileGestaltAttributeUDID:
            return self.JSON[@"UDID"];
            break;
        case MUMobileGestaltAttributeIMEI:
            return self.JSON[@"IMEI"];
            break;
        case MUMobileGestaltAttributeProduct:
            return self.JSON[@"PRODUCT"];
            break;
        case MUMobileGestaltAttributeICCID:
            return self.JSON[@"ICCID"];
            break;
        case MUMobileGestaltAttributeVersion:
            return self.JSON[@"VERSION"];
            break;
        default:
            break;
    }
    return nil;
}

@end
