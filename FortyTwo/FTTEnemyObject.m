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


@interface FTTEnemyObject ()

@property (nonatomic) FTTUserObject *userObject;

@end


@implementation FTTEnemyObject


static CGSize FTTUniverseSize;
static NSUInteger FTTTimeToUserParam;


+ (void)registerUniverseSize:(CGSize)size {
  FTTUniverseSize = size;
}

+ (void)registerTimeToUserParam:(NSUInteger)param {
  FTTTimeToUserParam = param;
}


- (instancetype)initWithTargetUserObject:(FTTUserObject *)userObject {
  self = [super init];

  if (self) {
    self.userObject = userObject;
  }

  return self;
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


- (void)resetSpeed {
  CGFloat timeToUser = rand() % FTTTimeToUserParam + FTTTimeToUserParam;

  self.speedX = (self.userObject.position.x - self.position.x) / timeToUser;
  self.speedY = (self.userObject.position.y - self.position.y) / timeToUser;
}


- (void)move {
  CGFloat newX = self.position.x + self.speedX;
  CGFloat newY = self.position.y + self.speedY;

  if (newX <= 0 || newX >= FTTUniverseSize.width || newY <= 0 || newY >= FTTUniverseSize.height) {
    [self.delegate enemyObject:self didMissTarget:self.userObject];
    [self resetPosition];
    [self resetSpeed];
  } else {
    self.position = CGPointMake(newX, newY);
  }
}


- (BOOL)hitTarget {
  if (ABS(self.position.x - self.userObject.position.x) < self.userObject.width &&
      ABS(self.position.y - self.userObject.position.y) < self.userObject.width) {
    return YES;
  }

  return NO;
}


@end
