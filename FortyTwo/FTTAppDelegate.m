//
//  FTTAppDelegate.m
//  FortyTwo
//
//  Created by Forrest Ye on 8/10/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import "FTTAppDelegate.h"

#import "FTTGameViewController.h"


@implementation FTTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  self.gameViewController = [[FTTGameViewController alloc] init];

  self.window.rootViewController = self.gameViewController;

  self.window.backgroundColor = [UIColor whiteColor];

  [self.window makeKeyAndVisible];

  return YES;
}

@end
