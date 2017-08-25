//
//  MUMobileGestaltRequest.m
//  MUMobileGestalt-Demo
//
//  Created by Shuang Wu on 2017/8/8.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "MUMobileGestaltRequest.h"
#import "NSString+MUUUID.h"
#import "MUMobileGestaltUtils.h"

@implementation MUMobileGestaltRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        _URL = MUMobileGestaltServerRegisterURL;
        _attributes = MUMobileGestaltAttributeAll;
        _displayName = [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        _organization = NSBundle.mainBundle.bundleIdentifier;
        _UUID = [NSString mumg_UUIDWithBundleIdentifier:NSBundle.mainBundle.bundleIdentifier];
        _identifier = @"com.unique.mobilegestalt";
        _explain = @"Register the device.";
        _version = 1;
    }
    return self;
}

- (NSData *)requestData {
    if (_requestData) {
        return _requestData;
    } else if (_requestFile) {
        return [NSData dataWithContentsOfFile:_requestFile];
    } else {
        NSData *data = [NSPropertyListSerialization dataWithPropertyList:self.requestObject format:NSPropertyListXMLFormat_v1_0 options:0 error:NULL];
        return data;
    }
}

- (NSDictionary *)requestObject {
    if (_requestObject) {
        return _requestObject;
    } else {
        NSMutableDictionary *mobileConfig = [NSMutableDictionary dictionary];
        mobileConfig[@"PayloadOrganization"] = self.organization;
        mobileConfig[@"PayloadDisplayName"] = self.displayName;
        mobileConfig[@"PayloadVersion"] = @(self.version);
        mobileConfig[@"PayloadUUID"] = self.UUID;
        mobileConfig[@"PayloadIdentifier"] = self.identifier;
        mobileConfig[@"PayloadDescription"] = self.explain;
        mobileConfig[@"PayloadType"] = @"Profile Service";
        mobileConfig[@"PayloadContent"] = @{
                                            @"URL": self.URL,
                                            @"DeviceAttributes": JSONFromAttributtes(self.attributes)
                                            };
        return [mobileConfig copy];
        
    }
}

@end
