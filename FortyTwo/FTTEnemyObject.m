//
//  FTTEnemy.m
//  FortyTwo
//
//  Created by Forrest Ye on 8/11/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import "FTTEnemyObject.h"

#import "FTTUserObject.h"


typedef NS_ENUM(NSUInteger, FTTEnemySpawnLocation) {
  FTTEnemySpawnLocationTop,
  FTTEnemySpawnLocationLeft,
  FTTEnemySpawnLocationBottom,
  FTTEnemySpawnLocationRight,
};


@implementation FTTEnemyObject


- (void)resetPosition {
  FTTEnemySpawnLocation location = rand() % 4;

  CGPoint center;

  switch (location) {
    case FTTEnemySpawnLocationTop: {
      center = CGPointMake(rand() % DeviceWidth(), 0);
      break;
    }
    case FTTEnemySpawnLocationLeft: {
      center = CGPointMake(0, rand() % DeviceHeight());
      break;
    }
    case FTTEnemySpawnLocationBottom: {
      center = CGPointMake(rand() % DeviceWidth(), DeviceHeight());
      break;
    }
    case FTTEnemySpawnLocationRight: {
      center = CGPointMake(DeviceWidth(), rand() % DeviceHeight());
      break;
    }
  }

  self.position = center;
}


- (void)resetSpeedWithUserObject:(FTTUserObject *)userObject {
  CGFloat timeToUser = rand() % 90 + 90; // fps is 42, so this better be 90 ~ 180?

  if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
    timeToUser = rand() % 60 + 60;
  }

  self.speedX = (userObject.position.x - self.position.x) / timeToUser;
  self.speedY = (userObject.position.y - self.position.y) / timeToUser;
}


- (void)moveTowardsUserObject:(FTTUserObject *)userObject {
  CGFloat newX = self.position.x + self.speedX;
  CGFloat newY = self.position.y + self.speedY;

  if (newX <= 0 || newX >= DeviceWidth() || newY <= 0 || newY >= DeviceHeight()) {
    [self resetPosition];
    [self resetSpeedWithUserObject:userObject];
  } else {
    self.position = CGPointMake(newX, newY);
  }
}


- (BOOL)hitUserObject:(FTTUserObject *)userObject {
  if (ABS(self.position.x - userObject.position.x) < FTTObjectWidth() &&
      ABS(self.position.y - userObject.position.y) < FTTObjectWidth()) {
    return YES;
  }

  return NO;
}


@end
