//
//  MUMobileGestaltRequest.h
//  MUMobileGestalt-Demo
//
//  Created by Shuang Wu on 2017/8/8.
//  Copyright © 2017年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUMobileGestaltUtils.h"

/**
 *  Mobile Gestalt Request
 *
 *  Create a request to get device info.
 *  You can choose one of the 4 method to create *.mobileconfig file.
 */


@interface MUMobileGestaltRequest : NSObject

/**
 *  Method 1: OC Properties
 *  Create a mobile config file with these properties, and the file is not be signed. If you want to use a signed file, choose one of Method 3,4
 */


@property (nonatomic, strong) NSString *URL;

@property (nonatomic, assign) MUMobileGestaltAttribute attributes;

@property (nonatomic, strong) NSString *organization;

@property (nonatomic, strong) NSString *displayName;

@property (nonatomic, strong) NSString *UUID;

@property (nonatomic, strong) NSString *identifier;

@property (nonatomic, strong) NSString *explain;

@property (nonatomic, assign) NSInteger version;






@property (nonatomic, strong) NSDictionary *requestObject;





/**
 *  Method 3
 */

@property (nonatomic, strong) NSData *requestData;



@property (nonatomic, strong) NSString *requestFile;


@end
