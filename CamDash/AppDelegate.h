//
//  AppDelegate.h
//  CamDash
//
//  Created by Arpit Panda on 18/01/19.
//  Copyright © 2019 Arpit Panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

