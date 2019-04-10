//
//  MGError.m
//  MobileGestaltDemo
//
//  Created by Magic-Unique on 2019/4/8.
//  Copyright © 2019 Magic-Unique. All rights reserved.
//

#import "MGError.h"

NSErrorDomain MGErrorDomain = @"com.unique.mobilegestalt";

NSError *MGMakeError(MGErrorCode code, NSString *reason, NSString *suggestion) {
    return [NSError errorWithDomain:MGErrorDomain code:code userInfo:({
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[NSLocalizedDescriptionKey] = @"Cannot request mobile gestalt.";
        userInfo[NSLocalizedFailureReasonErrorKey] = reason;
        userInfo[NSLocalizedRecoverySuggestionErrorKey] = suggestion;
        [userInfo copy];
    })];
}

NSError *MGServerIsnotRunningError(void) {
    return MGMakeError(MGErrorCodeServerIsNotRunning, @"The server is not running", @"Change port and create a new session");
}

NSError *MGCannotBeginBackgroundTaskError(void) {
    return MGMakeError(MGErrorCodeCannotBeginBackgroundTask, @"Can not begin background task.", @"Add background running mode to Info.plist file.");
}

NSError *MGCannotOpenMobileConfigURLError(void) {
    return MGMakeError(MGErrorCodeCannotOpenMobileConfigURL, @"Call -[UIApplication openURL:] failed.", @"Restart app or reboot device, then try again.");
}

NSError *MGBackgroundTaskTimeoutError(void) {
    return MGMakeError(MGErrorCodeBackgroundTaskTimeout, @"Background task was expired.", @"Install file quickly.");
}

NSError *MGCancelByUserError(void) {
    return MGMakeError(MGErrorCodeCancelByUser, @"Cancel by user.", @"Install profile in Preferences.");
}
