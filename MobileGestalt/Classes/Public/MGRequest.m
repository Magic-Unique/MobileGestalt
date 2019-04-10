//
//  MGRequest.m
//  MobileGestaltDemo
//
//  Created by Magic-Unique on 2019/4/7.
//  Copyright © 2019 Magic-Unique. All rights reserved.
//

#import "MGRequest.h"
#import "MGRequest+Private.h"

@implementation MGRequest

+ (instancetype)requestWithTitle:(NSString *)title subtitle:(NSString *)subtitle description:(NSString *)description {
    return [MGCustomRequest requestWithTitle:title subtitle:subtitle description:description];
}

+ (instancetype)requestWithMobileConfigURL:(NSURL *)URL {
    NSParameterAssert(URL);
    return [MGURLRequest requestWithMobileConfigURL:URL];
}

+ (instancetype)requestWithMobileConfigData:(NSData *)data {
    NSParameterAssert(data);
    return [MGDataRequest requestWithMobileConfigData:data];
}

@end

@implementation MGCustomRequest

+ (instancetype)requestWithTitle:(NSString *)title subtitle:(NSString *)subtitle description:(NSString *)description {
    MGCustomRequest *request = [[self alloc] init];
    request.displayName = title;
    request.organization = subtitle;
    request.explain = description;
    return request;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.attributes = @[MGAttributeUDID,
                            MGAttributeIMEI,
                            MGAttributeICCID,
                            MGAttributeVersion,
                            MGAttributeProduct];
        self.organization = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];;
        self.displayName = @"Mobile Gestalt";
        self.UUID = [NSUUID UUID];
        self.identifier = [[[NSBundle mainBundle] bundleIdentifier] stringByAppendingString:@".mobilegestalt"];
        self.explain = @"Install the profile to get your device info.";
        self.version = 1;
    }
    return self;
}

@end

@implementation MGURLRequest

+ (instancetype)requestWithMobileConfigURL:(NSURL *)URL {
    NSParameterAssert(URL);
    return [[self alloc] initWithMobileConfigURL:URL];
}

- (instancetype)initWithMobileConfigURL:(NSURL *)URL {
    self = [super init];
    if (self) {
        _URL = URL;
    }
    return self;
}

@end

@implementation MGDataRequest

+ (instancetype)requestWithMobileConfigData:(NSData *)data {
    NSParameterAssert(data);
    return [[self alloc] initWithMobileConfigData:data];
}

- (instancetype)initWithMobileConfigData:(NSData *)data {
    self = [super init];
    if (self) {
        _data = data;
    }
    return self;
}

@end

@implementation MGResponse

+ (instancetype)responseWithData:(NSData *)data {
    NSRange rangeBegin = [data rangeOfData:[@"<?xml version=\"1.0\"" dataUsingEncoding:NSASCIIStringEncoding] options:0 range:NSMakeRange(0, data.length)];
    NSRange rangeEnd = [data rangeOfData:[@"</plist>" dataUsingEncoding:NSASCIIStringEncoding] options:0 range:NSMakeRange(0, data.length)];
    NSData *plistData = [data subdataWithRange:NSMakeRange(rangeBegin.location, rangeEnd.location + rangeEnd.location - rangeBegin.location)];
    NSDictionary *plistDict = [NSPropertyListSerialization propertyListWithData:plistData options:0 format:NULL error:NULL];
    MGResponse *response = [[self alloc] init];
    response->_data = plistDict;
    return response;
}

- (NSString *)UDID {
    return self.data[MGAttributeUDID];
}

- (NSString *)IMEI {
    return self.data[MGAttributeIMEI];
}

- (NSString *)ICCID {
    return self.data[MGAttributeICCID];
}

- (NSString *)Version {
    return self.data[MGAttributeVersion];
}

- (NSString *)Product {
    return self.data[MGAttributeProduct];
}

@end
