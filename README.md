# MobileGestalt

Get iOS device UDID with public API

## How it works?

The library use *.mobileconfig file to get device information. You can read the [documents](https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/iPhoneOTAConfiguration/ConfigurationProfileExamples/ConfigurationProfileExamples.html) by Apple to learn about.

## What can we get?

* UDID
* IMEI
* ICCID (I can't got it but write in the documents by Apple)
* Products (Like: **iPhone8,3**)
* Version (Like: **14G60**)

## Can use in App Store?

>  Sorry, I don't know.

## USAGE - QUICK 

### 1. Install

1. Use CocoaPods `pod 'MobileGestalt'`
2. Use Source, drag *MobileGestalt* to your project

Import 

```objc
#import <MobileGestalt/MobileGestalt.h>
```

### 2. Add URL Scheme

Add an unique URLScheme to your *Info.plist*.

Such as: `mobilegestalt`

### 3. Create a session

```objc
MGSessionConfiguration *configuration = [MGSessionConfiguration defaultConfiguration];
configuration.port = 10418;
configuration.portOffset = 3;	// Use port 10418~10421

configuration.port = 0; //	Use random port
self.session = [MGSession sessionWithConfiguration:configuration];
```

### 4. Create a request

```objc
//	Create a custom request
MGRequest *request = [MGRequest request];
request.attributes = @[MGAttributeUDID, MGAttributeIMEI, MGAttributeICCID, MGAttributeVersion, MGAttributeProduct];
request.displayName = @"Title for Profile";
request.organization = @"Subtitle for Profile";
request.explain = @"Description for Profile";
request.identifier = @"com.unique.mobilegestalt";

//	Create a signed request in remote
MGRequest *request = [MGRequest requestWithMobileConfigURL:aRemoteURL];

//	Create a signed request in local
MGRequest *request = [MGRequest requestWithMobileConfigData:aNSData];

```

### 5. Send request

```objc
[self.session request:request completed:^(MGRequest *request, MGResponse *response, NSError *error) {
	if (error) {
		NSLog(@"%@", error);
	} else {
		NSLog(@"%@", response.data);
	}
}];
```

