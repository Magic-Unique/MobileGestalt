//
//  MUTableViewRow.h
//  MUMobileGestalt-Demo
//
//  Created by Shuang Wu on 2017/8/25.
//  Copyright © 2017年 unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUTableViewRow : NSObject <UITableViewDelegate>

@property (nonatomic, strong) NSString *title;

- (instancetype)initWithTitle:(NSString *)title;
+ (instancetype)rowWithTitle:(NSString *)title;

@end
