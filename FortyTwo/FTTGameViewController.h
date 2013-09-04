//
//  FTTGameViewController.h
//  FortyTwo
//
//  Created by Forrest Ye on 8/10/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FTTUniverseView.h"

#import "FTTShoutDetector.h"


@interface FTTGameViewController : UIViewController <UIAlertViewDelegate, FTTUniverseViewDataSource, FTTShoutDetectorDelegate>

- (void)pauseGame;

@end
