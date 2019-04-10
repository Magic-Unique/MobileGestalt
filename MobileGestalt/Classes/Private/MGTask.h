//
//  MGTask.h
//  MobileGestaltDemo
//
//  Created by 吴双 on 2019/4/10.
//  Copyright © 2019 Magic-Unique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGUtils.h"

@interface MGTask : NSObject

@property (nonatomic, strong, readonly) MGRequest *request;
@property (nonatomic, copy, readonly) MGCompletion completion;

@property (nonatomic, strong, readonly) MGResponse *response;
@property (nonatomic, strong, readonly) NSError *error;

@property (nonatomic, assign) UIBackgroundTaskIdentifier bgTaskId;

+ (instancetype)taskWithRequest:(MGRequest *)request completion:(MGCompletion)completion;

- (void)applicationWillEnterForeground;

- (void)markError:(NSError *)error;
- (void)markResponse:(MGResponse *)response;
- (void)sendCompletion;

@end
