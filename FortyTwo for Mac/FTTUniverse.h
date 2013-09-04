//
//  FTTUniverse.h
//  FortyTwo
//
//  Created by Forrest Ye on 9/4/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FTTMUniverseView.h"


@class FTTSpeedVector;


@interface FTTUniverse : NSObject <FTTMUniverseViewDataSource>

- (void)tick;

- (BOOL)userIsHit;

- (void)updateUserWithSpeedVector:(FTTSpeedVector *)speedVector;

@end
