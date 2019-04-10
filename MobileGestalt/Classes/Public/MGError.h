//
//  MGError.h
//  MobileGestaltDemo
//
//  Created by Magic-Unique on 2019/4/8.
//  Copyright © 2019 Magic-Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSErrorDomain MGErrorDomain;

typedef NS_ENUM(NSInteger, MGErrorCode) {
    MGErrorCodeSucceed,                     ///<    Unused
    MGErrorCodeServerIsNotRunning,          ///<    GCDWebServer can not running before open *.mobileconfig.
    MGErrorCodeCannotBeginBackgroundTask,   ///<    MGSession can not begin a background task before open URL of *.mobileconfig
    MGErrorCodeCannotOpenMobileConfigURL,   ///<    Failed when UIApplication open URL of *.mobileconfig
    MGErrorCodeMobileConfigDataIsNil,       ///<    Can not respond *.mobileconfig request, because the data for response is nil.
    MGErrorCodeBackgroundTaskTimeout,       ///<    User does not install *.mobileconfig and make app in background so long.
    MGErrorCodeCancelByUser,                ///<    User reopen the app without installed *.mobileconfig
};

FOUNDATION_EXTERN NSError *MGServerIsnotRunningError(void);
FOUNDATION_EXTERN NSError *MGCannotBeginBackgroundTaskError(void);
FOUNDATION_EXTERN NSError *MGCannotOpenMobileConfigURLError(void);
FOUNDATION_EXTERN NSError *MGMobileConfigDataIsNilError(void);
FOUNDATION_EXTERN NSError *MGBackgroundTaskTimeoutError(void);
FOUNDATION_EXTERN NSError *MGCancelByUserError(void);
