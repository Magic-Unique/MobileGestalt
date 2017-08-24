# MUMobileGestalt

Get iOS device UDID with public API on iOS 10 and before.

## How it works?

The library use *.mobileconfig file to get device information. You can read the [documents](https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/iPhoneOTAConfiguration/ConfigurationProfileExamples/ConfigurationProfileExamples.html) by Apple to learn about.

## What can we get?

* UDID
* IMEI
* Products (Like: *iPhone8,3*)
* Version (Like: *14G60*)
* ICCID (I can't got it but write in the documents by Apple)

## Can use in App Store?

>  Sorry, I don't know.

## USAGE - QUICK 

**1. Be sure you app can run in background**

Project -> Target -> Capabilities -> Open Background Modes -> Enable Audio, AirPlay, and Picture in Picture

**2. Adding framewrok**

* AVFoundation.framewrok
* AudioToolBox.framework

**3. Import Library**

I will make it support CocoaPods song.

Drag `MUMobileGestalt` , `GCDWebServer` , `MMPDeepSleepPreventer` to your project.

**4. Coding**

**Import**

```objective-c
#import "MUMobileGestaltRequest.h"
#import "MUMobileGestaltSession.h"
```

**Useage**

```objective-c

MUMobileGestaltRequest *request = [[MUMobileGestaltRequest alloc] init];
[self.session request:request completed:^NSURL *(MUMobileGestaltSession *session, MUMobileGestaltRequest *request, MUMobileGestaltResponse *response) {
	if (response.error) {
		NSLog(@"%@", response.error);
	} else {
		NSLog(@"%@", response.JSON);
	}
  	// Adding the unique URL scheme, and return it here to jump back from SettingsApp
	return [NSURL URLWithString:@"mobilegestalt://"];
}];
```

