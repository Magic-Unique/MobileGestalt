//
//  MGTask.m
//  MobileGestaltDemo
//
//  Created by 吴双 on 2019/4/10.
//  Copyright © 2019 Magic-Unique. All rights reserved.
//

#import "MGTask.h"
#import "MGError.h"
#import <GCDWebServer/GCDWebServerDataRequest.h>
#import <GCDWebServer/GCDWebServerDataResponse.h>

@implementation MGTask

+ (instancetype)taskWithRequest:(MGRequest *)request completion:(MGCompletion)completion {
    MGTask *task = [[MGTask alloc] init];
    task->_request = request;
    task->_completion = [completion copy];
    return task;
}

- (void)applicationWillEnterForeground {
    if (!_response && !_error) {
        [self markError:MGCancelByUserError()];
    }
}

- (void)markError:(NSError *)error {
    _error = error;
    _response = nil;
}

- (void)markResponse:(MGResponse *)response {
    _error = nil;
    _response = response;
}

- (void)sendCompletion {
    if (_completion) {
        if (_error || _response) {
            !_completion?:_completion(_request, _response, _error);
        }
    }
}

@end
