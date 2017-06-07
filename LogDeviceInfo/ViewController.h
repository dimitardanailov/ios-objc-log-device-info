//
//  ViewController.h
//  LogDeviceInfo
//
//  Created by Dimitar Danailov on 6/7/17.
//  Copyright © 2017 Dimitar Danailov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) NSString *deviceID;

@property (strong, nonatomic) NSString *deviceName;

@property (strong, nonatomic) NSString *OSVersionString;

@property (strong, nonatomic) NSString *ipAddress;

@property (strong, nonatomic) NSString *localUserInformation;

@property (strong, nonatomic) NSString *memoryProfile;

@property (strong, nonatomic) NSString *operatingSystem;

@property (nonatomic) Float32 memoryUsage;

@property (nonatomic) Float32 deviceMemory;

@end

