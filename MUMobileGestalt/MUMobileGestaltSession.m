//
//  MUMobileGestaltSession.m
//  MUMobileGestalt-Demo
//
//  Created by Shuang Wu on 2017/8/8.
//  Copyright © 2017年 unique. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MUMobileGestaltSession.h"

#import "UIApplication+MobileGestalt.h"

#import "GCDWebServer.h"
#import "GCDWebServerDataRequest.h"
#import "GCDWebServerDataResponse.h"
#import "MMPDeepSleepPreventer.h"

@interface MUMobileGestaltSession ()

@property (nonatomic, strong, readonly) GCDWebServer *server;

@property (nonatomic, strong, readonly) MMPDeepSleepPreventer *preventer;

@property (nonatomic, strong, readonly) MUMobileGestaltRequest *currentRequest;

@property (nonatomic, copy, readonly) MUMobileGestaltSessionCompletion currentCompletion;

@end

@implementation MUMobileGestaltSession

+ (instancetype)session {
    return [[self alloc] init];
}

- (void)dealloc {
    [self stop];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        __weak MUMobileGestaltSession *_weakSelf = self;
        _preventer = [[MMPDeepSleepPreventer alloc] init];
        _server = [[GCDWebServer alloc] init];
        [_server addHandlerForMethod:@"GET"
                                path:@"/mobilegestalt/request.mobileconfig"
                        requestClass:[GCDWebServerDataRequest class]
                        processBlock:^GCDWebServerResponse *(GCDWebServerDataRequest* request) {
                            NSData *responseData = _weakSelf.currentRequest.requestData;
                            GCDWebServerDataResponse *dataResponse = [[GCDWebServerDataResponse alloc] initWithData:responseData contentType:@"application/x-apple-aspen-config"];
                            return dataResponse;
                        }];
        [_server addHandlerForMethod:@"POST"
                                path:MUMobileGestaltServerRegisterPath
                        requestClass:[GCDWebServerDataRequest class]
                        processBlock:^GCDWebServerResponse *(GCDWebServerDataRequest *request) {
                            //   存储 UDID
                            MUMobileGestaltResponse *response = [[MUMobileGestaltResponse alloc] initWithData:request.data];
                            NSURL *redirectURL = nil;
                            
                            if (_weakSelf.currentCompletion) {
                                redirectURL = _weakSelf.currentCompletion(_weakSelf, _weakSelf.currentRequest, response);
                            }
                            
                            //   从设置跳回微信
                            GCDWebServerResponse *serverResponse = nil;
                            if (redirectURL) {
                                serverResponse = [[GCDWebServerResponse alloc] initWithRedirect:redirectURL permanent:YES];
                            } else {
                                serverResponse = [[GCDWebServerResponse alloc] initWithStatusCode:200];
                            }
                            
                            return serverResponse;
                        }];
    }
    return self;
}

- (BOOL)startServerIfNeed {
    [self.preventer startPreventSleep];
    if (self.server.isRunning) {
        return YES;
    } else {
        NSError *error = nil;
        [self.server startWithOptions:@{GCDWebServerOption_Port:@8088,
                                        GCDWebServerOption_BindToLocalhost:@YES,
                                        GCDWebServerOption_AutomaticallySuspendInBackground:@NO} error:&error];
        if (error) {
            return NO;
        } else {
            return YES;
        }
    }
}

- (void)stop {
    [self.preventer stopPreventSleep];
    [self.server stop];
}

- (void)request:(MUMobileGestaltRequest *)request completed:(MUMobileGestaltSessionCompletion)completed {
    MUMobileGestaltSessionCompletion _completed = [completed copy];
    _currentRequest = request;
    _currentCompletion = _completed;
    BOOL start = [self startServerIfNeed];
    if (start == NO) {
        MUMobileGestaltResponse *response = [[MUMobileGestaltResponse alloc] initWithDescription:@"Can not get the device info."
                                                                                          reason:@"Can not start the server at http://localhost:8080/"
                                                                                      suggestion:@"Close all application and try it again"];
        dispatch_async(dispatch_get_main_queue(), ^{
            !_completed?nil:_completed(self, request, response);
        });
    } else {
        [[UIApplication sharedApplication] mumg_openURL:[NSURL URLWithString:MUMobileGestaltServerMobileConfigURL] completed:^(BOOL success) {
            if (!success) {
                MUMobileGestaltResponse *response = [[MUMobileGestaltResponse alloc] initWithDescription:@"Can not get the device info."
                                                                                                  reason:@"Can not open the url."
                                                                                              suggestion:@"Close all application and try it again"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    !_completed?nil:_completed(self, request, response);
                });
            }
        }];
    }
}

@end
