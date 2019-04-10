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

FOUNDATION_EXTERN MGAttribute _Nonnull MGAttributeUDID;
FOUNDATION_EXTERN MGAttribute _Nonnull MGAttributeIMEI;
FOUNDATION_EXTERN MGAttribute _Nonnull MGAttributeICCID;
FOUNDATION_EXTERN MGAttribute _Nonnull MGAttributeVersion;
FOUNDATION_EXTERN MGAttribute _Nonnull MGAttributeProduct;

typedef void(^MGCompletion)(MGRequest * _Nonnull request, MGResponse * _Nullable response, NSError * _Nullable error);
