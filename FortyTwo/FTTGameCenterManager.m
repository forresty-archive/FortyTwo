//
//  FTTAchievementManager.m
//  FortyTwo
//
//  Created by Forrest Ye on 9/6/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import "FTTGameCenterManager.h"

// FFToolkit
#import "FFGameCenterManager.h"


@interface FTTGameCenterManager ()

@property (nonatomic) FFGameCenterManager *gameCenterManager;

@end

@implementation FTTGameCenterManager


+ (instancetype)defaultManager {
  static FTTGameCenterManager *_instance = nil;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _instance = [[self alloc] init];
  });

  return _instance;
}


- (id)init {
  self = [super init];

  if (self) {
    self.gameCenterManager = [FFGameCenterManager sharedManager];
  }

  return self;
}

- (void)reportTimeLasted:(NSTimeInterval)timeLasted {
  [self.gameCenterManager reportScore:timeLasted * 100
             forLeaderBoardIdentifier:@"com.forresty.FortyTwo.timeLasted"];
}

- (void)lasted42Seconds {
  [self.gameCenterManager reportAchievementWithIdentifier:@"FortyTwo.FortyTwo"];
}

- (void)usedABluePill {
  [self.gameCenterManager reportAchievementWithIdentifier:@"FortyTwo.BluePill"];
}

- (void)dodgedABullet {

}

- (void)diedOnce {

}

- (void)launchedGameToday {

}

@end
