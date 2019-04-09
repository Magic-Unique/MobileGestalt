//
//  ViewController.m
//  MobileGestaltDemo
//
//  Created by Magic-Unique on 2019/4/7.
//  Copyright © 2019 Magic-Unique. All rights reserved.
//

#import "ViewController.h"
#import "MobileGestalt.h"
#import <Masonry/Masonry.h>

#define UDK_DATA @"com.unique.mobilegestalt.demo.data"

@interface ViewController ()

@property (nonatomic, strong, readonly) MGSession *session;

@property (nonatomic, strong) NSDictionary *data;

@property (nonatomic, strong) NSError *error;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MGSessionConfiguration *configuration = [MGSessionConfiguration defaultConfiguration];
    configuration.port = 10418;
    _session = [MGSession sessionWithConfiguration:configuration];
    
    if (self.session.error) {
        self.error = self.session.error;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sections = 1;
    if (self.data || self.error) {
        sections++;
    }
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return self.data ? 5 : 3;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"OPERATION";
    } else {
        if (self.data) {
            return @"DEVICE INFORMATION";
        } else {
            return @"ERROR";
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GET" forIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Get Device Information (no sign)";
        } else {
            cell.textLabel.text = @"Get Device Information (sign)";
        }
        return cell;
    } else if (self.data) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"INFO" forIndexPath:indexPath];
        NSArray *titles = @[MGAttributeUDID, MGAttributeIMEI, MGAttributeICCID, MGAttributeProduct, MGAttributeVersion];
        NSString *key = titles[indexPath.row];
        cell.textLabel.text = key;
        cell.detailTextLabel.text = self.data[key];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ERROR" forIndexPath:indexPath];
        NSArray *titles = @[@"Description", @"Reason", @"Suggestion"];
        NSMutableDictionary *subtitles = [NSMutableDictionary dictionary];
        subtitles[@"Description"] = self.error.localizedDescription;
        subtitles[@"Reason"] = self.error.localizedFailureReason;
        subtitles[@"Suggestion"] = self.error.localizedRecoverySuggestion;
        
        NSString *key = titles[indexPath.row];
        cell.textLabel.text = key;
        cell.detailTextLabel.text = subtitles[key];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        MGRequest *request = nil;
        if (indexPath.row == 0) {
            request = [MGRequest request];
            request.organization = @"Magic-Unique";
            request.displayName = @"MobileGestalt";
            request.explain = @"Get device UDID.";
        } else {
            NSString *path = [NSBundle.mainBundle pathForResource:@"sign" ofType:@"mobileconfig"];
            NSData *data = [NSData dataWithContentsOfFile:path];
            request = [MGRequest requestWithMobileConfigData:data];
        }
        [self.session request:request completed:^(MGRequest *request, MGResponse *response, NSError *error) {
            self.data = nil;
            self.error = nil;
            if (response.data) {
                self.data = response.data;
            } else {
                self.error = error;
            }
            [self.tableView reloadData];
        }];
    }
}

@end
