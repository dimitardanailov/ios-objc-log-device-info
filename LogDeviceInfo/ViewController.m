//
//  ViewController.m
//  LogDeviceInfo
//
//  Created by Dimitar Danailov on 6/7/17.
//  Copyright © 2017 Dimitar Danailov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/utsname.h>
#import <mach/mach.h>
#import "ViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>

#import "DeviceInformationCollector.h"

struct cpuMonitor {
    uint64_t totalSystemTime;
    uint64_t totalUserTime;
    uint64_t totalIdleTime;
};

struct cpuPrintInfo {
    Float32 totalSystemTime;
    Float32 totalUserTime;
    Float32 totalIdleTime;
};

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *deviceIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ipAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *memoryUsageLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceMemoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *OSVersionStringLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cpuTotalSystemTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cpuTotalUserTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cpuTotalIdleTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceHostNameLabel;

@end

@implementation ViewController

@synthesize deviceID = _deviceID;
@synthesize deviceName = _deviceName;
@synthesize memoryUsage = _memoryUsage;
@synthesize deviceMemory = _deviceMemory;
@synthesize OSVersionString = _OSVersionString;
@synthesize deviceUserName = _deviceUserName;
@synthesize cpuActiveProcessors = _cpuActiveProcessors;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DeviceInformationCollector *deviceCollector =
        [[DeviceInformationCollector alloc] init];
    
    NSLog(@"DeviceInformationCollector ----------- ");
    NSLog(@"Device Id -  %@", deviceCollector.deviceId);
    NSLog(@"Device name -  %@", deviceCollector.deviceName);
    NSLog(@"Username -  %@", deviceCollector.username);
    NSLog(@"Device system - %@", deviceCollector.deviceSystem);
    NSLog(@"Device system version - %@", deviceCollector.deviceSystemVersion);
     NSLog(@" ip address - %@", deviceCollector.ipAddress);
    NSLog(@"----------- ");
    
    _deviceIdLabel.text = deviceCollector.deviceId;
    _deviceNameLabel.text = deviceCollector.deviceName;
    
    // Memory Usage
    _memoryUsageLabel.text = [NSString stringWithFormat:@"%f", [self memoryUsage]];
    
    //Physical Memory
    _deviceMemoryLabel.text = [NSString stringWithFormat:@"%f", [self deviceMemory]];
    
    // Device username
    _deviceUserNameLabel.text = deviceCollector.username;
    
    // CPU
    struct cpuPrintInfo cpuInfo = [self createCpuPercentInfo];
    _cpuTotalSystemTimeLabel.text = [NSString stringWithFormat:@"%f %%", cpuInfo.totalSystemTime];
    _cpuTotalUserTimeLabel.text = [NSString stringWithFormat:@"%f %%", cpuInfo.totalUserTime];
    _cpuTotalIdleTimeLabel.text = [NSString stringWithFormat:@"%f %%", cpuInfo.totalIdleTime];
    
    // CPU Cores
    NSUInteger cpuCores = [NSProcessInfo processInfo].activeProcessorCount;
    NSString *valueActiveCPUCores = [NSString stringWithFormat:@"%li",  cpuCores];
    NSLog(@"The number of active processing cores available on the computer.: %@", valueActiveCPUCores);
    
    NSUInteger processorCount = [NSProcessInfo processInfo].processorCount;
    NSString *cpuCoresValue = [NSString stringWithFormat:@"%li",  processorCount];
    NSLog(@"The number of processing cores available on the computer.: %@", cpuCoresValue);
    
    // https://stackoverflow.com/questions/448162/determine-device-iphone-ipod-touch-with-iphone-sdk
    NSLog(@"Device model: %@", [UIDevice currentDevice].model);
    NSLog(@"Device name: %@", [UIDevice currentDevice].name);

    // OS String version
    // _OSVersionStringLabel.text = [self OSVersionStringLabel];
    
    _ipAddressLabel.text = deviceCollector.ipAddress;
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

- (NSString *) deviceUserName {
    return NSUserName();
}

- (struct cpuPrintInfo) createCpuPercentInfo {
    struct cpuMonitor delta;
    calcCpuUsage(&delta);
    
    uint64_t total = delta.totalSystemTime + delta.totalUserTime + delta.totalIdleTime;
    double onePercent = total / 100.0f;
    
    struct cpuPrintInfo info;
    info.totalSystemTime = (double) delta.totalSystemTime / (double) onePercent;
    info.totalUserTime = (double) delta.totalUserTime / (double) onePercent;
    info.totalIdleTime = (double) delta.totalIdleTime / (double) onePercent;
    
    return info;
}

void calcCpuUsage(struct cpuMonitor *delta) {
    // Starting marker
    struct cpuMonitor startingMarker;
    cpuMonitor(&startingMarker);
    sleep(1);
    
    // Еnd point
    struct cpuMonitor endMarker;
    cpuMonitor(&endMarker);
    
    delta->totalSystemTime = endMarker.totalSystemTime - startingMarker.totalSystemTime;
    delta->totalUserTime = endMarker.totalUserTime - startingMarker.totalUserTime;
    delta->totalIdleTime = endMarker.totalIdleTime - startingMarker.totalIdleTime;
}

// https://stackoverflow.com/questions/20471920/how-to-get-total-cpu-idle-time-in-objective-c-c-on-os-xs
void cpuMonitor(struct cpuMonitor *cpu) {
    processor_cpu_load_info_t cpuLoad;
    mach_msg_type_number_t processorMsgCount;
    natural_t processorCount;
    
    uint64_t totalSystemTime = 0;
    uint64_t totalUserTime = 0;
    uint64_t totalIdleTime = 0;
    
    kern_return_t err = host_processor_info(
                                            mach_host_self(),
                                            PROCESSOR_CPU_LOAD_INFO,
                                            &processorCount,
                                            (processor_info_array_t *)&cpuLoad,
                                            &processorMsgCount
                                            );
    
    uint64_t system = 0, user = 0, idle = 0;
    
    for (natural_t i = 0; i < processorCount; i++) {
        // Calc load types and totals, with guards against 32-bit overflow
        // (values are natural_t)
        system = 0, user = 0, idle = 0;
        
        system = cpuLoad[i].cpu_ticks[CPU_STATE_SYSTEM];
        user = cpuLoad[i].cpu_ticks[CPU_STATE_USER] + cpuLoad[i].cpu_ticks[CPU_STATE_NICE];
        idle = cpuLoad[i].cpu_ticks[CPU_STATE_IDLE];
        
        totalSystemTime += system;
        totalUserTime += user;
        totalIdleTime += idle;
    }
    
    cpu->totalSystemTime = totalSystemTime;
    cpu->totalUserTime = totalUserTime;
    cpu->totalIdleTime = totalIdleTime;
}
@end
