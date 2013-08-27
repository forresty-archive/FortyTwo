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

static CGSize FTTUniverseSize;

+ (void)registerUniverseSize:(CGSize)size {
  FTTUniverseSize = size;
}

- (void)resetPosition {
  FTTEnemySpawnLocation location = rand() % 4;

  CGPoint center;

  switch (location) {
    case FTTEnemySpawnLocationTop: {
      center = CGPointMake(rand() % (NSUInteger)FTTUniverseSize.width, 0);
      break;
    }
    case FTTEnemySpawnLocationLeft: {
      center = CGPointMake(0, rand() % (NSUInteger)FTTUniverseSize.height);
      break;
    }
    case FTTEnemySpawnLocationBottom: {
      center = CGPointMake(rand() % (NSUInteger)FTTUniverseSize.width, (NSUInteger)FTTUniverseSize.height);
      break;
    }
    case FTTEnemySpawnLocationRight: {
      center = CGPointMake(FTTUniverseSize.width, rand() % (NSUInteger)FTTUniverseSize.height);
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

  if (newX <= 0 || newX >= FTTUniverseSize.width || newY <= 0 || newY >= FTTUniverseSize.height) {
    [self resetPosition];
    [self resetSpeedWithUserObject:userObject];
  } else {
    self.position = CGPointMake(newX, newY);
  }
}


- (BOOL)hitUserObject:(FTTUserObject *)userObject {
  if (ABS(self.position.x - userObject.position.x) < userObject.width &&
      ABS(self.position.y - userObject.position.y) < userObject.width) {
    return YES;
  }

  return NO;
}


@end
