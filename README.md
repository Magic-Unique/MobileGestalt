# MUMobileGestalt

Get iOS device UDID with public API on iOS 12 and before.

## How it works?

MUMobileGestalt use `*.mobileconfig` file to get device information (MDM). You can read the [documents](https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/iPhoneOTAConfiguration/ConfigurationProfileExamples/ConfigurationProfileExamples.html) by Apple to learn about.

## What can we get?

* UDID
* IMEI
* Products (Like: *iPhone8,3*)
* Version (Like: *14G60*)
* ICCID (I can't got it but written in the documents by Apple)

## Can use on App Store?

>  Sorry, I don't know.

## USAGE - QUICK 

**1. Be sure your app can run in background**

Project -> Target -> Capabilities -> Open Background Modes -> Enable Audio, AirPlay, and Picture in Picture

**2. Adding framewroks**

* AVFoundation.framewrok
* AudioToolBox.framework

**3. Import Library**

I will make it support CocoaPods soon.

Drag `MUMobileGestalt` , `GCDWebServer` , `MMPDeepSleepPreventer` to your project.

**4. Add URL Scheme if you want**

Add an unique url scheme that screen can jump back from Preferences.app automatic after installing `*.mobileconfig` file.

**5. Coding**

**Import Headers**

```objective-c
#import "MUMobileGestaltRequest.h"
#import "MUMobileGestaltSession.h"
```

**Useage**

```objective-c

MUMobileGestaltRequest *request = [[MUMobileGestaltRequest alloc] init];
self.session = [[MUMobileGestaltSession session]
__weak typeof(self) _weak_self = self;
[self.session request:request completed:^NSURL *(MUMobileGestaltSession *session, MUMobileGestaltRequest *request, MUMobileGestaltResponse *response) {
	__strong typeof(self) self = _weak_self;
	if (response.error) {
		NSLog(@"%@", response.error);
	} else {
		NSLog(@"%@", response.JSON);
	}
	self.session = nil;
  	// Adding the unique URL scheme, and return it here to jump back from SettingsApp
	return [NSURL URLWithString:@"mobilegestalt://"];
}];
```

