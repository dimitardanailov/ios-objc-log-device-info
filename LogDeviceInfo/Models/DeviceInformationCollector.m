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

#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <ifaddrs.h>
#include <net/if.h>
#include <netdb.h>

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
        self.ipAddress = [self ipAddress];
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

- (NSString *) ipAddress {
    return [DeviceInformationCollector getNetworkData];
}

/*!
 * Getting a List of All IP Addresses in Apple's Technical Note TN1145 mentions 3 methods for getting the status of the network interfaces:
 *
 * - System Configuration Framework
 * - Open Transport API
 * - BSD sockets
 *
 * Source: https://stackoverflow.com/questions/12690622/detect-any-connected-network
 * \returns string with network data
 */
+ (NSMutableString *) getNetworkData
{
    NSMutableString *networkData = [[NSMutableString alloc]init];
    
    struct ifaddrs *allInterfaces;
    
    // Get list of all interfaces on the local machine:
    if (getifaddrs(&allInterfaces) == 0) {
        struct ifaddrs *interface;
        
        // For each interface ...
        for (interface = allInterfaces; interface != NULL; interface = interface->ifa_next) {
            unsigned int flags = interface->ifa_flags;
            struct sockaddr *addr = interface->ifa_addr;
            
            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if ((flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING)) {
                if (addr->sa_family == AF_INET || addr->sa_family == AF_INET6) {
                    
                    // Convert interface address to a human readable string:
                    char host[NI_MAXHOST];
                    getnameinfo(addr, addr->sa_len, host, sizeof(host), NULL, 0, NI_NUMERICHOST);
                    
                    // Generate interface information
                    [networkData appendString:[NSString stringWithFormat:@"interface:%s, address:%s | ", interface->ifa_name, host]];
                    
                    // NSString *string = "interface:%s, address:%s\n", interface->ifa_name, host;
                    printf("interface:%s, address:%s\n", interface->ifa_name, host);
                }
            }
        }
    }
    
    freeifaddrs(allInterfaces);
    
    return networkData;
}

@end
