//
//  FTTMGameViewController.h
//  FortyTwo
//
//  Created by Forrest Ye on 8/28/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "FTTMUniverseView.h"

#import "FTTFrameManager.h"


@interface FTTMGameViewController : NSViewController <FTTMUniverseViewDataSource, FTTFrameManagerDelegate>

- (void) stopGame;

@end
