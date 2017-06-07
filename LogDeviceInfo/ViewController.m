//
//  ViewController.m
//  LogDeviceInfo
//
//  Created by Dimitar Danailov on 6/7/17.
//  Copyright © 2017 Dimitar Danailov. All rights reserved.
//

#import <sys/utsname.h>
#import <mach/mach.h>
#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *deviceIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ipAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *memoryUsageLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceMemoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *OSVersionStringLabel;

@end

@implementation ViewController

@synthesize deviceID = _deviceID;
@synthesize deviceName = _deviceName;
@synthesize memoryUsage = _memoryUsage;
@synthesize deviceMemory = _deviceMemory;
@synthesize OSVersionString = _OSVersionString;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _deviceIdLabel.text = [self deviceID];
    _deviceNameLabel.text = [self deviceName];
    
    // Memory Usage
    _memoryUsageLabel.text = [NSString stringWithFormat:@"%f", [self memoryUsage]];
    
    //Physical Memory
    _deviceMemoryLabel.text = [NSString stringWithFormat:@"%f", [self deviceMemory]];
    
    // OS String version
    // _OSVersionStringLabel.text = [self OSVersionStringLabel];
    
    _ipAddressLabel.text = @"Hello";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Device ID
// https://stackoverflow.com/questions/5468629/device-id-from-an-iphone-app
- (NSString *) deviceID {
    NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    return uniqueIdentifier;
}


// Device Name
// https://stackoverflow.com/questions/11197509/ios-how-to-get-device-make-and-model
- (NSString *) deviceName {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

// Memory Usage
// https://stackoverflow.com/questions/787160/programmatically-retrieve-memory-usage-on-iphone
- (Float32) memoryUsage {
    Float32 memoryUsage = 0.0f;
    
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(),
                                   TASK_BASIC_INFO,
                                   (task_info_t)&info,
                                   &size);
    
    if (kerr == KERN_SUCCESS) {
        memoryUsage = ((CGFloat)info.resident_size / 1000000); // MB
    }
    
    
    return memoryUsage;
}

// Physical Memory
// https://developer.apple.com/documentation/foundation/nsprocessinfo#//apple_ref/occ/instm/NSProcessInfo/physicalMemory
// https://stackoverflow.com/questions/20211650/total-ram-size-of-an-ios-device
- (Float32) deviceMemory {
    return ([NSProcessInfo processInfo].physicalMemory / 1000000); // МБ
}

- (NSString *) OSVersionString {
    return [NSProcessInfo processInfo].operatingSystemVersionString;
}
    
@end
