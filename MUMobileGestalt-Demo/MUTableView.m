//
//  MUTableView.m
//  MUMobileGestalt-Demo
//
//  Created by Shuang Wu on 2017/8/25.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "MUTableView.h"

@implementation MUTableView

+ (instancetype)mobileGestaltTableView {
    return [[self alloc] initWithSections:@[[MUTableViewSection properetySection], [MUTableViewSection dataSection]]];
}

- (instancetype)initWithSections:(NSArray<MUTableViewSection *> *)sections {
    self = [super init];
    if (self) {
        _sections = [sections copy];
    }
    return self;
}

@end
