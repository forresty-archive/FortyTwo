//
//  FTTMGameViewController.h
//  FortyTwo
//
//  Created by Forrest Ye on 8/28/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// frame control
#import "FFFrameManager.h"

#import "FTTMKeyboardInputSourceDelegate.h"


@interface FTTMGameViewController : NSViewController <FFFrameManagerDelegate, FTTMKeyboardInputSourceDelegate>

@property (nonatomic) BOOL gamePlaying;

- (void) stopGame;

@end
