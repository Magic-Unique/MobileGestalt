//
//  MUTableViewSection.h
//  MUMobileGestalt-Demo
//
//  Created by Shuang Wu on 2017/8/25.
//  Copyright © 2017年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUTableViewRow.h"

@interface MUTableViewSection : NSObject

@property (nonatomic, strong) NSString *header;

@property (nonatomic, strong) NSString *footer;

@property (nonatomic, strong) NSArray<MUTableViewRow *> *rows;

+ (instancetype)properetySection;

+ (instancetype)dataSection;

@end
