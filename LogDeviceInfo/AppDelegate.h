//
//  AppDelegate.h
//  LogDeviceInfo
//
//  Created by Dimitar Danailov on 6/7/17.
//  Copyright © 2017 Dimitar Danailov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

