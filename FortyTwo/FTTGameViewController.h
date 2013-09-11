//
//  FTTGameViewController.h
//  FortyTwo
//
//  Created by Forrest Ye on 8/10/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FTTShoutDetector.h"

#import "FFFrameManager.h"

#import "FTTEnemyObject.h"

@interface FTTGameViewController : UIViewController <UIAlertViewDelegate, FTTShoutDetectorDelegate, FFFrameManagerDelegate, FTTEnemyObjectDelegate>

- (void)pauseGame;

@end
