//
//  DeviceInformationCollector.h
//  LogDeviceInfo
//
//  Created by Dimitar Danailov on 7/12/17.
//  Copyright © 2017 Dimitar Danailov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInformationCollector : NSObject

@property (strong, nonatomic) NSString *deviceId;
@property (strong, nonatomic) NSString *deviceName;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *deviceSystem;
@property (strong, nonatomic) NSString *deviceSystemVersion;
@property (strong, nonatomic) NSString *ipAddress;

@end
