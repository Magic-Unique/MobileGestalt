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

#import "MUTableView.h"

@interface ViewController ()

@property (nonatomic, strong) MUMobileGestaltSession *session;

@property (nonatomic, strong) MUTableView *tableViewInfo;

@end

@implementation ViewController

- (MUMobileGestaltSession *)session {
    if (!_session) {
        _session = [[MUMobileGestaltSession alloc] init];
    }
    return _session;
}

- (instancetype)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Mobile Gestalt";
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableViewInfo.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewInfo.sections[section].rows.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.tableViewInfo.sections[section].header;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return self.tableViewInfo.sections[section].footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CELL"];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        cell.backgroundColor = UIColor.whiteColor;
    }
    cell.textLabel.text = self.tableViewInfo.sections[indexPath.section].rows[indexPath.row].title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (MUTableView *)tableViewInfo {
    if (!_tableViewInfo) {
        _tableViewInfo = [MUTableView mobileGestaltTableView];
    }
    return _tableViewInfo;
}

@end
