//
//  MGRequest+Private.h
//  MobileGestaltDemo
//
//  Created by Magic-Unique on 2019/4/10.
//  Copyright © 2019 Magic-Unique. All rights reserved.
//

#import "MGRequest.h"

@interface MGCustomRequest : MGRequest

@end

@interface MGURLRequest : MGRequest

@property (nonatomic, strong, readonly) NSURL *URL;

@end

@interface MGDataRequest : MGRequest

@property (nonatomic, strong, readonly) NSData *data;

@end
