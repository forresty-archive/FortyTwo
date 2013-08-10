//
//  FTTGameViewController.h
//  FortyTwo
//
//  Created by Forrest Ye on 8/10/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FTTGameViewController : UIViewController <UIAlertViewDelegate>


+ (instancetype)sharedInstance;

- (void)pauseGame;


@end
