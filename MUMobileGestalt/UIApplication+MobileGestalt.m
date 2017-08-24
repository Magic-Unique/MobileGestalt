//
//  UIApplication+MobileGestalt.m
//  MUMobileGestalt-Demo
//
//  Created by Shuang Wu on 2017/8/24.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "UIApplication+MobileGestalt.h"

@implementation UIApplication (MobileGestalt)

- (void)mumg_openURL:(NSURL *)URL completed:(void (^)(BOOL))completed {
    completed = [completed copy];
    if (UIDevice.currentDevice.systemVersion.floatValue >= 10.0) {
        [self openURL:URL options:@{} completionHandler:completed];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        BOOL result = [self openURL:URL];
#pragma clang diagnostic pop
        dispatch_async(dispatch_get_main_queue(), ^{
            !completed?:completed(result);
        });
    }
}

@end
