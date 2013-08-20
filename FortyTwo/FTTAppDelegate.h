//
//  FTTAppDelegate.h
//  FortyTwo
//
//  Created by Forrest Ye on 8/10/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <UIKit/UIKit.h>


@class FTTGameViewController;


@interface FTTAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic) UIWindow *window;

@property (strong, nonatomic) FTTGameViewController *gameViewController;

@end
