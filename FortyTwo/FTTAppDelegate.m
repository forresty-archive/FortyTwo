//
//  FTTAppDelegate.m
//  FortyTwo
//
//  Created by Forrest Ye on 8/10/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import "FTTAppDelegate.h"

#import "FTTGameViewController.h"

// 3-party
#import "Flurry.h"
#import "TestFlight.h"


@implementation FTTAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [Flurry startSession:@"7K3SWS7SVPTPMFDGVWZC"];
  [TestFlight takeOff:@"14cef1d7-e6ac-4951-90d7-267deefd0a84"];

  [UIApplication sharedApplication].idleTimerDisabled = YES;

  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  self.gameViewController = [[FTTGameViewController alloc] init];

  self.window.rootViewController = self.gameViewController;

  self.window.backgroundColor = [UIColor blackColor];

  [self.window makeKeyAndVisible];

  return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
  [self.gameViewController pauseGame];
}


@end
