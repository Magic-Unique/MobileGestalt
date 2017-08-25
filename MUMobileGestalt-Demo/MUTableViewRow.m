//
//  MUTableViewRow.m
//  MUMobileGestalt-Demo
//
//  Created by Shuang Wu on 2017/8/25.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "MUTableViewRow.h"

@implementation MUTableViewRow

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        _title = [title copy];
    }
    return self;
}

+ (instancetype)rowWithTitle:(NSString *)title {
    return [[self alloc] initWithTitle:title];
}

@end
