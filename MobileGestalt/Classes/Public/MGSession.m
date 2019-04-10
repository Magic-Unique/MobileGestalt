//
//  MGSession.m
//  MobileGestaltDemo
//
//  Created by Magic-Unique on 2019/4/7.
//  Copyright © 2019 Magic-Unique. All rights reserved.
//

#import "MGSession.h"
#import <UIKit/UIKit.h>
#import <GCDWebServer/GCDWebServer.h>
#import <GCDWebServer/GCDWebServerDataRequest.h>
#import <GCDWebServer/GCDWebServerDataResponse.h>

#import "MGRequest.h"
#import "MGRequest+Private.h"
#import "MGTask.h"
#import "MGError.h"

#define MGWeak(obj)     __weak typeof(obj) weak_##obj = obj
#define MGStrong(obj)   __strong typeof(weak_##obj) obj = weak_##obj;

#define MGLog(...) do { if (self.configuration.log) { NSLog(@"MobileGestalt: %@", [NSString stringWithFormat:__VA_ARGS__]); }} while(0);

void MGRunInMain(void (^block)(void)) {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

void MGOpenURL(NSURL *URL, void (^completed)(BOOL success)) {
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:completed];
    } else {
        BOOL success = NO;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        success = [[UIApplication sharedApplication] openURL:URL];
#pragma clang diagnostic pop
        !completed?:completed(success);
    }
}

@interface MGSession () <GCDWebServerDelegate>

@property (nonatomic, strong, readonly) GCDWebServer *server;

@property (nonatomic, strong, readonly) MGTask *task;
@property (nonatomic, assign, readonly) UIBackgroundTaskIdentifier bgTaskId;

@end

@implementation MGSession

+ (instancetype)sessionWithConfiguration:(MGSessionConfiguration *)configuration {
    NSParameterAssert(configuration);
    return [[self alloc] initWithConfiguration:configuration];
}

+ (instancetype)defaultSession {
    return [self sessionWithConfiguration:[MGSessionConfiguration defaultConfiguration]];
}

- (instancetype)initWithConfiguration:(MGSessionConfiguration *)configuration {
    self = [super init];
    if (self) {
        _configuration = configuration;
        _server = [[GCDWebServer alloc] init];
        [self __initHandler];
        
        NSError *error = nil;
        BOOL result = NO;
        NSUInteger port = configuration.port;
        do {
            result = [self.server startWithOptions:@{GCDWebServerOption_Port:@(port),
                                                     GCDWebServerOption_BindToLocalhost:@YES,
                                                     GCDWebServerOption_AutomaticallySuspendInBackground:@NO} error:&error];
            if (result) {
                MGLog(@"Server is running in port %@", @(self.server.port));
                break;
            } else {
                MGLog(@"Server can not running in port %@", @(port));
            }
            port++;
        } while (port < configuration.port + configuration.portOffset);
        _enable = result;
        if (!result) {
            _error = error;
            MGLog(@"Server can not running");
        } else {
            [self installUIApplicationDelegate:YES];
        }
    }
    return self;
}

- (void)dealloc {
    if (self.server.isRunning) {
        [self.server stop];
    }
    [self installUIApplicationDelegate:NO];
}

- (void)installUIApplicationDelegate:(BOOL)install {
    if (install) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidEnterBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillEnterForeground:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)applicationDidEnterBackground:(NSNotification *)notification {
}

- (void)applicationWillEnterForeground:(NSNotification *)notification {
    [self.task applicationWillEnterForeground];
    [self __completion];
    
    if (self.bgTaskId != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:self.bgTaskId];
        self->_bgTaskId = UIBackgroundTaskInvalid;
    }
}

- (void)request:(MGRequest *)request completed:(MGCompletion)completed {
    if (![request isKindOfClass:[MGRequest class]] && [request isMemberOfClass:[MGRequest class]]) {
        NSAssert(NO, @"Request must subclass of MGRequest, use +[MGRequest requestWith...] to create instance.");
    }
    _task = [MGTask taskWithRequest:request completion:completed];
    
    MGWeak(self);
    MGRunInMain(^{
        MGStrong(self);
        
        if (!self.server.isRunning) {
            [self __markError:MGServerIsnotRunningError()];
            [self __completion];
            return ;
        }
        
        //  Begin background task
        self->_bgTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithName:@"com.unique.MobileGestalt" expirationHandler:^{
            MGStrong(self);
            self->_bgTaskId = UIBackgroundTaskInvalid;
            [self __markError:MGBackgroundTaskTimeoutError()];
            [self __completion];
        }];
        if (self.bgTaskId == UIBackgroundTaskInvalid) {
            [self __markError:MGCannotBeginBackgroundTaskError()];
            [self __completion];
            return ;
        }
        
        MGOpenURL([NSURL URLWithString:[self __mobileConfigURL]], ^(BOOL success) {
            if (!success) {
                MGStrong(self)
                [self __markError:MGCannotOpenMobileConfigURLError()];
                [self __completion];
            }
        });
    });
}

- (void)__initHandler {
    MGWeak(self);
    [_server addHandlerForMethod:@"GET"
                            path:self.configuration.mobileConfigPath
                    requestClass:[GCDWebServerDataRequest class]
                    processBlock:^GCDWebServerResponse *(GCDWebServerDataRequest* request) {
                        MGStrong(self);
                        if (!self.task) {
                            MGLog(@"Current task is nil, respond with 404");
                            return [GCDWebServerResponse responseWithStatusCode:404];
                        }
                        
                        if ([self.task.request isKindOfClass:[MGURLRequest class]]) {
                            MGURLRequest *_request = (MGURLRequest *)self.task.request;
                            if (_request.URL) {
                                return [GCDWebServerResponse responseWithRedirect:_request.URL permanent:YES];
                            }
                        }
                        
                        NSData *data = nil;
                        if ([self.task.request isKindOfClass:[MGCustomRequest class]]) {
                            MGCustomRequest *_request = (MGCustomRequest *)self.task.request;
                            data = [self __mobileConfigDataWithRequest:_request];
                        } else if ([self.task.request isKindOfClass:[MGDataRequest class]]) {
                            MGDataRequest *_request = (MGDataRequest *)self.task.request;
                            if (_request.data) {
                                data = _request.data;
                            }
                        }
                        if (!data) {
                            [self __markError:MGMobileConfigDataIsNilError()];
                            return [GCDWebServerDataResponse responseWithStatusCode:404];
                        }
                        return [[GCDWebServerDataResponse alloc] initWithData:data contentType:@"application/x-apple-aspen-config"];
                    }];
    [_server addHandlerForMethod:@"POST"
                            path:self.configuration.registerPath
                    requestClass:[GCDWebServerDataRequest class]
                    processBlock:^GCDWebServerResponse *(GCDWebServerDataRequest *request) {
                        MGStrong(self);
                        if (!self.task) {
                            MGLog(@"Current task is nil, respond with 404");
                            return [GCDWebServerResponse responseWithStatusCode:404];
                        }
                        
                        MGResponse *response = [MGResponse responseWithData:request.data];
                        [self __markResponse:response];
                        
                        NSString *URL = nil;
                        if (self.configuration.callbackScheme) {
                            NSString *scheme = self.configuration.callbackScheme;
                            NSMutableArray *datas = [NSMutableArray array];
                            [response.data enumerateKeysAndObjectsUsingBlock:^(MGAttribute key, NSString *obj, BOOL *stop) {
                                [datas addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
                            }];
                            NSString *parames = [datas componentsJoinedByString:@"&"];
                            URL = [NSString stringWithFormat:@"%@://mobilegestalt?%@", scheme, parames];
                            URL = [URL stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
                        } else {
                            URL = UIApplicationOpenSettingsURLString;
                        }
                        
                        return [[GCDWebServerResponse alloc] initWithRedirect:[NSURL URLWithString:URL] permanent:YES];
                    }];
}

- (void)__markError:(NSError *)error {
    MGLog(@"Receive error %@", error);
    [self.task markError:error];
}

- (void)__markResponse:(MGResponse *)response {
    MGLog(@"Receive informations %@", response.data);
    [self.task markResponse:response];
}

- (void)__completion {
    [self.task sendCompletion];
    _task = nil;
}

- (NSData *)__mobileConfigDataWithRequest:(MGCustomRequest *)request {
    NSMutableDictionary *mobileConfig = [NSMutableDictionary dictionary];
    mobileConfig[@"PayloadOrganization"] = request.organization;
    mobileConfig[@"PayloadDisplayName"] = request.displayName;
    mobileConfig[@"PayloadVersion"] = @(request.version);
    mobileConfig[@"PayloadUUID"] = request.UUID.UUIDString;
    mobileConfig[@"PayloadIdentifier"] = request.identifier;
    mobileConfig[@"PayloadDescription"] = request.explain;
    mobileConfig[@"PayloadType"] = @"Profile Service";
    mobileConfig[@"PayloadContent"] = @{@"URL": [self __registerURL], @"DeviceAttributes": request.attributes};
    NSData *data = [NSPropertyListSerialization dataWithPropertyList:mobileConfig format:NSPropertyListXMLFormat_v1_0 options:0 error:NULL];
    return data;
}

- (NSString *)__mobileConfigURL {
    NSString *URL = [NSString stringWithFormat:@"http://127.0.0.1:%@%@", @(self.server.port), self.configuration.mobileConfigPath];
    return URL;
}

- (NSString *)__registerURL {
    NSString *URL = [NSString stringWithFormat:@"http://127.0.0.1:%@%@", @(self.server.port), self.configuration.registerPath];
    return URL;
}

- (NSUInteger)port {
    if (self.enable) {
        return self.server.port;
    } else {
        return 0;
    }
}

@end

@implementation MGSessionConfiguration

+ (instancetype)defaultConfiguration {
    MGSessionConfiguration *configuration = [[MGSessionConfiguration alloc] init];
#if DEBUG == 1
    configuration.log = YES;
#endif
    return configuration;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.port = 10418;
        self.portOffset = 0;
        self.mobileConfigPath = @"/MobileGestalt/mdm.mobileconfig";
        self.registerPath = @"/MobileGestalt/register";
        self.callbackScheme = @"mobilegestalt";
    }
    return self;
}

@end
