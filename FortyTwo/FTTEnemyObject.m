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


static inline CGFloat FTTObjectWidth() {
  if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
    return 8;
  }

  return 5;
}


@implementation FTTEnemyObject


- (void)resetPosition {
  FTTEnemySpawnLocation location = rand() % 4;

  CGPoint center;

  switch (location) {
    case FTTEnemySpawnLocationTop: {
      center = CGPointMake(rand() % self.deviceWidth, 0);
      break;
    }
    case FTTEnemySpawnLocationLeft: {
      center = CGPointMake(0, rand() % self.deviceHeight);
      break;
    }
    case FTTEnemySpawnLocationBottom: {
      center = CGPointMake(rand() % self.deviceWidth, self.deviceHeight);
      break;
    }
    case FTTEnemySpawnLocationRight: {
      center = CGPointMake(self.deviceWidth, rand() % self.deviceHeight);
      break;
    }
  }

  self.position = center;
}


- (void)resetSpeedWithUserObject:(FTTUserObject *)userObject {
  CGFloat timeToUser = rand() % 90 + 90; // fps is 42, so this better be 90 ~ 180?

  self.speedX = (userObject.position.x - self.position.x) / timeToUser;
  self.speedY = (userObject.position.y - self.position.y) / timeToUser;
}


- (void)moveTowardsUserObject:(FTTUserObject *)userObject {
  CGFloat newX = self.position.x + self.speedX;
  CGFloat newY = self.position.y + self.speedY;

  if (newX <= 0 || newX >= self.deviceWidth || newY <= 0 || newY >= self.deviceHeight) {
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


# pragma mark - private


- (NSUInteger)deviceWidth {
  return [UIScreen mainScreen].bounds.size.width;
}


- (NSUInteger)deviceHeight {
  return [UIScreen mainScreen].bounds.size.height;
}


@end
