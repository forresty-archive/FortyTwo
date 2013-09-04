//
//  FTTUniverse.m
//  FortyTwo
//
//  Created by Forrest Ye on 9/4/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import "FTTUniverse.h"

#import "FTTUserObject.h"
#import "FTTEnemyObject.h"

#import "FTTSpeedVector.h"


@interface FTTUniverse ()

// models
@property (nonatomic) FTTUserObject *userObject;
@property (nonatomic) NSMutableArray *enemies;

@property (nonatomic) FTTSpeedVector *userSpeedVector;

@end


@implementation FTTUniverse

+ (void)initialize {
  [FTTObject registerDefaultObjectWidth:5];
  [FTTUserObject registerDefaultSpawnPosition:CGPointMake(240, 180)];
  [FTTEnemyObject registerUniverseSize:CGSizeMake(480, 360)];
  [FTTEnemyObject registerTimeToUserParam:90];
}

- (id)init {
  self = [super init];

  if (self) {
    self.userObject = [[FTTUserObject alloc] init];

    self.enemies = [NSMutableArray arrayWithCapacity:42];

    for (int i = 0; i < 42; i++) {
      FTTEnemyObject *enemy = [[FTTEnemyObject alloc] initWithTargetUserObject:self.userObject];

      [self.enemies addObject:enemy];
    }
  }

  return self;
}

- (void)tick {
  [self moveUserObject];
  [self moveEnemies];
}


- (BOOL)userIsHit {
  for (int i = 0; i < 42; i++) {
    FTTEnemyObject *enemy = self.enemies[i];

    if ([enemy hitTarget]) {
      return YES;
    }
  }

  return NO;
}

- (void)updateUserWithSpeedVector:(FTTSpeedVector *)speedVector {
  self.userSpeedVector = speedVector;
}


- (CGPoint)updatedPlanePositionWithSpeedX:(CGFloat)speedX speedY:(CGFloat)speedY {
  CGFloat speed = 4;

  CGFloat newX = self.userObject.position.x + speedX * speed;
  CGFloat newY = self.userObject.position.y - speedY * speed;

  newX = MAX(0, newX);
  newX = MIN(480, newX);
  newY = MAX(0, newY);
  newY = MIN(360, newY);
  CGPoint newCenterForPlane = CGPointMake(newX, newY);

  return newCenterForPlane;
}

- (void)moveUserObject {
  self.userObject.position = [self updatedPlanePositionWithSpeedX:self.userSpeedVector.x speedY:self.userSpeedVector.y];
}

- (void)moveEnemies {
  for (int i = 0; i < 42; i++) {
    FTTEnemyObject *enemy = self.enemies[i];

    [enemy move];
  }
}


# pragma mark - FTTMUniverseViewDataSource


- (CGPoint)positionOfUserObject {
  return self.userObject.position;
}

- (NSArray *)positionsOfEnemyObjects {
  NSMutableArray *positions = [NSMutableArray arrayWithCapacity:42];
  for (FTTEnemyObject *enemy in self.enemies) {
    [positions addObject:NSStringFromPoint(enemy.position)];
  }

  return positions;
}


@end
