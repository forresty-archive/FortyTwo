//
//  FTTAchievementManager.h
//  FortyTwo
//
//  Created by Forrest Ye on 9/6/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FTTGameCenterManager : NSObject

+ (instancetype)defaultManager;

- (void)reportTimeLasted:(NSTimeInterval)timeLasted;

// first time: "FortyTwo"
- (void)lasted42Seconds;

// first time: "the blue pill"
// 42 times: "high and dry"
- (void)usedABluePill;

// 4200 times: "the one"
- (void)dodgedABullet;

// 42 times: "meaning of life"
- (void)diedOnce;

// 42 different days: "groundhog day"
- (void)launchedGameToday;

@end
