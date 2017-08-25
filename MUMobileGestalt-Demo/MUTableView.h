//
//  MUTableView.h
//  MUMobileGestalt-Demo
//
//  Created by Shuang Wu on 2017/8/25.
//  Copyright © 2017年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUTableViewSection.h"

@interface MUTableView : NSObject

@property (nonatomic, strong) NSArray<MUTableViewSection *> *sections;

+ (instancetype)mobileGestaltTableView;

@end
