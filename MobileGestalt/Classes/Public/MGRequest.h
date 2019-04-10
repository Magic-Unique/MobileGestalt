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
@property (nonatomic, strong, nonnull) NSArray<MGAttribute> *attributes;

/**
 Profile display name
 
 Default is CFBundleDisplayName
 */
@property (nonatomic, strong, nonnull) NSString *displayName;

/**
 Profile organization
 
 Default is `Mobile Gestalt`
 */
@property (nonatomic, strong, nullable) NSString *organization;

/**
 Profile description
 
 Default is `Install the profile to get your device info.`
 */
@property (nonatomic, strong, nullable) NSString *explain;

/**
 Profile unique identifier
 
 Default is `{NSBundle.mainBundle.bundleIdentifier}.mobilegestalt`
 */
@property (nonatomic, strong, nonnull) NSString *identifier;

/**
 Profile version
 
 Default is 1.
 */
@property (nonatomic, assign) NSInteger version;

/**
 Profile UUID
 */
@property (nonatomic, strong, nonnull) NSUUID *UUID;


/**
 Create custom request with default value

 @param title DisplayName
 @param subtitle Organization
 @param description Explain
 @return MGRequest
 */
+ (instancetype _Nonnull)requestWithTitle:(NSString * _Nonnull)title subtitle:(NSString * _Nullable)subtitle description:(NSString * _Nullable)description;

/**
 Create request with *.mobileconfig URL

 @param URL NSURL
 @return MGRequest
 */
+ (instancetype _Nonnull)requestWithMobileConfigURL:(NSURL * _Nonnull)URL;

/**
 Create request with *.mobileconfig data

 @param data NSData
 @return MGRequest
 */
+ (instancetype _Nonnull)requestWithMobileConfigData:(NSData * _Nonnull)data;

@end

@interface MGResponse : NSObject

/**
 Device info.
 */
@property (nonatomic, strong, readonly, nonnull) NSDictionary<MGAttribute, NSString *> *data;

@property (nonatomic, strong, readonly, nullable) NSString *UDID;
@property (nonatomic, strong, readonly, nullable) NSString *IMEI;
@property (nonatomic, strong, readonly, nullable) NSString *ICCID;    ///< Maybe nil
@property (nonatomic, strong, readonly, nullable) NSString *Version;
@property (nonatomic, strong, readonly, nullable) NSString *Product;

+ (instancetype _Nonnull)responseWithData:(NSData * _Nonnull)data;

@end
