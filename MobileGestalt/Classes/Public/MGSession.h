//
//  MGSession.h
//  MobileGestaltDemo
//
//  Created by Magic-Unique on 2019/4/7.
//  Copyright © 2019 Magic-Unique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGUtils.h"

@class MGRequest, MGResponse;

@interface MGSessionConfiguration : NSObject

/**
 Local server port, default is 10418. Set 0 to use random port.
 */
@property (nonatomic, assign) NSUInteger port;

/**
 Local server port offset. Default is 0 (not offset)
 
 If port is not usable, MGSession will use offset-port. Range is [port, port + portOffset]
 */
@property (nonatomic, assign) NSUInteger portOffset;

/**
 Local server *.mobileconfig path. Default: /MobileGestalt/mdm.mobileconfig
 */
@property (nonatomic, copy) NSString *mobileConfigPath;

/**
 Local server register path, Default: /MobileGestalt/register
 
 Register path must writen in *.mobileconfig file with key `PayloadContent.URL`.
 For MGCustomRequest: it will pass to request.
 For MGNormalRequest, you must use a *.mobileconfig with this registerPath,
 */
@property (nonatomic, copy) NSString *registerPath;

/**
 Callback URL scheme.
 
 Add an URLScheme to Info.plist, and pass it here. It will auto jump back after user install profile.
 */
@property (nonatomic, strong) NSString *callbackScheme;

@property (nonatomic, assign) BOOL log;

/**
 Configuration with default value

 @return MGSessionConfiguration
 */
+ (instancetype)defaultConfiguration;

@end

@interface MGSession : NSObject

/**
 Configuration
 */
@property (nonatomic, strong, readonly) MGSessionConfiguration *configuration;

/**
 Enable
 
 If the server was failed in starting, enable will be NO, any request can not work.
 */
@property (nonatomic, assign, readonly) BOOL enable;

/**
 Error
 
 Server error for starting.
 */
@property (nonatomic, strong, readonly) NSError *error;

/**
 Server port
 */
@property (nonatomic, assign, readonly) NSUInteger port;

/**
 Create session with configuration

 @param configuration MGSessionConfiguration
 @return MGSession
 */
+ (instancetype)sessionWithConfiguration:(MGSessionConfiguration *)configuration;

/**
 Create session with default configuration

 @return MGSession
 */
+ (instancetype)defaultSession;

/**
 Send request

 @param request MGRequest
 @param completed Completion
 */
- (void)request:(MGRequest *)request completed:(MGCompletion)completed;

@end
