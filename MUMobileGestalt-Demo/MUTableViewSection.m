//
//  MUTableViewSection.m
//  MUMobileGestalt-Demo
//
//  Created by Shuang Wu on 2017/8/25.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "MUTableViewSection.h"

@implementation MUTableViewSection

- (instancetype)initWithHeader:(NSString *)header footer:(NSString *)footer rows:(NSArray *)rows {
    self = [super init];
    if (self) {
        _header = [header copy];
        _footer = [footer copy];
        _rows = [rows copy];
    }
    return self;
}

+ (instancetype)properetySection {
    return [[self alloc] initWithHeader:@"Quick Request"
                                 footer:@"Quick request without signature."
                                   rows:@[[MUTableViewRow rowWithTitle:@"Quick Request (Default)"],
                                          [MUTableViewRow rowWithTitle:@"Quick Request (Custom)"]]];
}

+ (instancetype)dataSection {
    return [[self alloc] initWithHeader:@"Request with NSData"
                                 footer:@"Request with signature."
                                   rows:@[[MUTableViewRow rowWithTitle:@"NSData"],
                                          [MUTableViewRow rowWithTitle:@"File Path"]]];
}

@end
