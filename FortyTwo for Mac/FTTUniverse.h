//
//  FTTUniverse.h
//  FortyTwo
//
//  Created by Forrest Ye on 9/4/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FTTUniverseViewDataSource.h"


@class FTTSpeedVector;


@interface FTTUniverse : NSObject <FTTUniverseViewDataSource>

- (instancetype)initWithWidth:(NSUInteger)width height:(NSUInteger)height;

- (void)tick;

- (BOOL)userIsHit;

- (void)updateUserWithSpeedVector:(FTTSpeedVector *)speedVector;

@end
