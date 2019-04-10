//
//  MGUtils.h
//  MobileGestaltDemo
//
//  Created by Magic-Unique on 2019/4/8.
//  Copyright © 2019 Magic-Unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MGRequest, MGResponse, NSError;

typedef NSString *MGAttribute;

FOUNDATION_EXTERN MGAttribute MGAttributeUDID;
FOUNDATION_EXTERN MGAttribute MGAttributeIMEI;
FOUNDATION_EXTERN MGAttribute MGAttributeICCID;
FOUNDATION_EXTERN MGAttribute MGAttributeVersion;
FOUNDATION_EXTERN MGAttribute MGAttributeProduct;

typedef void(^MGCompletion)(MGRequest *request, MGResponse *response, NSError *error);
