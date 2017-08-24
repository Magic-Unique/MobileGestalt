//
//  UIApplication+MobileGestalt.h
//  MUMobileGestalt-Demo
//
//  Created by Shuang Wu on 2017/8/24.
//  Copyright © 2017年 unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (MobileGestalt)

- (void)mumg_openURL:(NSURL *)URL completed:(void(^)(BOOL success))completed;

@end
