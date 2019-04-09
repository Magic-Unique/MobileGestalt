//
//  MGRequest.m
//  MobileGestaltDemo
//
//  Created by Magic-Unique on 2019/4/7.
//  Copyright © 2019 Magic-Unique. All rights reserved.
//

#import "MGRequest.h"

@interface MGCustomRequest : MGRequest

@end

@interface MGNormalRequest : MGRequest

@property (nonatomic, strong, readonly) NSURL *fileURL;

@property (nonatomic, strong, readonly) NSData *fileData;

@end

@implementation MGRequest

+ (instancetype)request {
    return [MGCustomRequest request];
}

+ (instancetype)requestWithAttributes:(NSArray<MGAttribute> *)attributes {
    NSParameterAssert(attributes);
    return [MGCustomRequest requestWithAttributes:attributes];
}

+ (instancetype)requestWithMobileConfigURL:(NSURL *)URL {
    NSParameterAssert(URL);
    return [MGNormalRequest requestWithMobileConfigURL:URL];
}

+ (instancetype)requestWithMobileConfigData:(NSData *)data {
    NSParameterAssert(data);
    return [MGNormalRequest requestWithMobileConfigData:data];
}

@end

@implementation MGCustomRequest

+ (MGCustomRequest *)request {
    NSArray<MGAttribute> *attributes = @[MGAttributeUDID,
                                         MGAttributeIMEI,
                                         MGAttributeICCID,
                                         MGAttributeVersion,
                                         MGAttributeProduct];
    return [self requestWithAttributes:attributes];
}

+ (instancetype)requestWithAttributes:(NSArray<MGAttribute> *)attributes {
    NSParameterAssert(attributes);
    MGCustomRequest *request = [[self alloc] init];
    request.attributes = attributes;
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

@implementation MGNormalRequest

+ (instancetype)requestWithMobileConfigURL:(NSURL *)URL {
    NSParameterAssert(URL);
    return [[self alloc] initWithMobileConfigURL:URL];
}

+ (instancetype)requestWithMobileConfigData:(NSData *)data {
    NSParameterAssert(data);
    return [[self alloc] initWithMobileConfigData:data];
}

- (instancetype)initWithMobileConfigURL:(NSURL *)URL {
    self = [super init];
    if (self) {
        _fileURL = URL;
    }
    return self;
}

- (instancetype)initWithMobileConfigData:(NSData *)data {
    self = [super init];
    if (self) {
        _fileData = data;
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
