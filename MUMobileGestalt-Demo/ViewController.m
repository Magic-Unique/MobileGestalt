//
//  ViewController.m
//  MUMobileGestalt-Demo
//
//  Created by Shuang Wu on 2017/8/8.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "ViewController.h"
#import "MUMobileGestaltRequest.h"
#import "MUMobileGestaltSession.h"

@interface ViewController ()

@property (nonatomic, strong) MUMobileGestaltSession *session;

@end

@implementation ViewController

- (MUMobileGestaltSession *)session {
    if (!_session) {
        _session = [[MUMobileGestaltSession alloc] init];
    }
    return _session;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    MUMobileGestaltRequest *request = [[MUMobileGestaltRequest alloc] init];
    [self.session request:request completed:^NSURL *(MUMobileGestaltSession *session, MUMobileGestaltRequest *request, MUMobileGestaltResponse *response) {
        if (response.error) {
            NSLog(@"%@", response.error);
        } else {
            NSLog(@"%@", response.JSON);
        }
        return [NSURL URLWithString:@"mobilegestalt://"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
