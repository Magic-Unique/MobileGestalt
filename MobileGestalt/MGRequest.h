//
//  MGRequest.h
//  MobileGestaltDemo
//
//  Created by Magic-Unique on 2019/4/7.
//  Copyright © 2019 Magic-Unique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGUtils.h"

@interface MGRequest : NSObject

/**
 The device info key.
 */
@property (nonatomic, strong) NSArray<MGAttribute> *attributes;

/**
 Profile display name
 
 Default is CFBundleDisplayName
 */
@property (nonatomic, strong) NSString *displayName;

/**
 Profile organization
 
 Default is `Mobile Gestalt`
 */
@property (nonatomic, strong) NSString *organization;

/**
 Profile description
 
 Default is `Install the profile to get your device info.`
 */
@property (nonatomic, strong) NSString *explain;

/**
 Profile unique identifier
 
 Default is `{NSBundle.mainBundle.bundleIdentifier}.mobilegestalt`
 */
@property (nonatomic, strong) NSString *identifier;

/**
 Profile version
 
 Default is 1.
 */
@property (nonatomic, assign) NSInteger version;

/**
 Profile UUID
 */
@property (nonatomic, strong) NSUUID *UUID;

/**
 Create custom request with default value

 @return MGRequest
 */
+ (instancetype)request;

/**
 Creat custom request with attributes

 @param attributes [MGAttributes]
 @return MGRequest
 */
+ (instancetype)requestWithAttributes:(NSArray<MGAttribute> *)attributes;

/**
 Create request with *.mobileconfig URL

 @param URL NSURL
 @return MGRequest
 */
+ (instancetype)requestWithMobileConfigURL:(NSURL *)URL;

/**
 Create request with *.mobileconfig data

 @param data NSData
 @return MGRequest
 */
+ (instancetype)requestWithMobileConfigData:(NSData *)data;

@end

@interface MGResponse : NSObject

/**
 Device info.
 */
@property (nonatomic, strong, readonly) NSDictionary<MGAttribute, NSString *> *data;

@property (nonatomic, strong, readonly) NSString *UDID;
@property (nonatomic, strong, readonly) NSString *IMEI;
@property (nonatomic, strong, readonly) NSString *ICCID;    ///< Maybe nil
@property (nonatomic, strong, readonly) NSString *Version;
@property (nonatomic, strong, readonly) NSString *Product;

+ (instancetype)responseWithData:(NSData *)data;

@end
