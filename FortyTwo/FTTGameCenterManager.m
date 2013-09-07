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
#import "FFSimpleKeyValueStore.h"
#import "FFSimpleArrayStore.h"


@interface FTTGameCenterManager ()

@property (nonatomic) FFGameCenterManager *gameCenterManager;
@property (nonatomic) FFSimpleKeyValueStore *keyValueStore;
@property (nonatomic) FFSimpleArrayStore *datesGameLaunched;

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
    self.keyValueStore = [FFSimpleKeyValueStore defaultStore];

    self.datesGameLaunched = [FFSimpleArrayStore storeWithIdentifier:@"FortyTwo.datesGameLaunched"];
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

  NSString *numberOfTimesUsedABluePill = @"FortyTwo.numberOfTimesUsedABluePill";

  [self.keyValueStore increaseNSUIntegerValueForKey:numberOfTimesUsedABluePill];

  double percentComplete = [self.keyValueStore getNSUIntegerValueWithKey:numberOfTimesUsedABluePill] * 100.0 / 42.0;

  [self.gameCenterManager reportAchievementWithIdentifier:@"FortyTwo.HighAndDry"
                                          percentComplete:percentComplete];
}

- (void)dodgedABullet {
  // TODO: bullet count could be fast, FFSimpleKeyValueStore will not be good enough for now
}

- (void)diedOnce {
  NSString *numberOfDeathsKey = @"FortyTwo.numberOfDeaths";

  [self.keyValueStore increaseNSUIntegerValueForKey:numberOfDeathsKey];

  double percentComplete = [self.keyValueStore getNSUIntegerValueWithKey:numberOfDeathsKey] * 100.0 / 42.0;

  [self.gameCenterManager reportAchievementWithIdentifier:@"FortyTwo.MeaningOfLife"
                                          percentComplete:percentComplete];
}

- (void)launchedGameToday {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyyMMdd"];
  NSString *formattedDateString = [dateFormatter stringFromDate:[NSDate date]];

  NSUInteger numberOfDatesGameLaunched = self.datesGameLaunched.count;
  [self.datesGameLaunched addObject:formattedDateString skipIfDuplicated:YES];

  // only report if count increases
  if (self.datesGameLaunched.count > numberOfDatesGameLaunched) {
    [self.gameCenterManager reportAchievementWithIdentifier:@"FortyTwo.GroundhogDay"
                                            percentComplete:self.datesGameLaunched.count * 100.0 / 42.0];
  }
}

@end
