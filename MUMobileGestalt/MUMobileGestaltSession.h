//
//  MUMobileGestaltSession.h
//  MUMobileGestalt-Demo
//
//  Created by Shuang Wu on 2017/8/8.
//  Copyright © 2017年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUMobileGestaltRequest.h"
#import "MUMobileGestaltResponse.h"

@class MUMobileGestaltSession;

typedef NSURL *(^MUMobileGestaltSessionCompletion)(MUMobileGestaltSession *session, MUMobileGestaltRequest *request, MUMobileGestaltResponse *response);

@interface MUMobileGestaltSession : NSObject

+ (instancetype)session;

- (void)request:(MUMobileGestaltRequest *)request completed:(MUMobileGestaltSessionCompletion)completed;

@end
