//
//  DeviceInformationCollector.m
//  LogDeviceInfo
//
//  Created by Dimitar Danailov on 7/12/17.
//  Copyright © 2017 Dimitar Danailov. All rights reserved.
//

#import <sys/utsname.h>
#import <mach/mach.h>
#import <UIKit/UIKit.h>
#import "DeviceInformationCollector.h"

@implementation DeviceInformationCollector

@synthesize deviceId = _deviceId;
@synthesize deviceName = _deviceName;
@synthesize username = _username;
@synthesize deviceSystem = _deviceSystem;
@synthesize deviceSystemVersion = _deviceSystemVersion;
@synthesize ipAddress = _ipAddress;

- (instancetype) init
{
    self = [super init];
    
    if (self) {
        self.deviceId = [self deviceId];
        self.deviceName = [self deviceName];
        self.username = [self username];
        self.deviceSystem = [self deviceSystem];
        self.deviceSystemVersion = [self deviceSystemVersion];
    }
    
    return self;
}

/*! Source: https://stackoverflow.com/questions/5468629/device-id-from-an-iphone-app
 * \returns information about device imei
 */
- (NSString *) deviceId {
    NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    return uniqueIdentifier;
}

/*! Source: https://stackoverflow.com/questions/11197509/ios-how-to-get-device-make-and-model
 * \returns information about device imei
 */
- (NSString *) deviceName {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

- (NSString *) username {
    return NSUserName();
}

- (NSString *) deviceSystem {
    return [UIDevice currentDevice].systemName;
}

- (NSString *) deviceSystemVersion {
    return [UIDevice currentDevice].systemVersion;
}

@end
