//
//  FTTGameViewController.h
//  FortyTwo
//
//  Created by Forrest Ye on 8/10/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FTTShoutDetector.h"

#import "FTTFrameManager.h"

#import "FTTEnemyObject.h"

@interface FTTGameViewController : UIViewController <UIAlertViewDelegate, FTTShoutDetectorDelegate, FTTFrameManagerDelegate, FTTEnemyObjectDelegate>

- (void)pauseGame;

@end
