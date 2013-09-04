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


@interface FTTUniverse ()

// models
@property (nonatomic) FTTUserObject *userObject;
@property (nonatomic) NSMutableArray *enemies;

@end

static CGFloat FTTMUserObjectSpeed = 0.5;


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
  switch (self.userObjectVerticalHeading) {
    case FTTMUserObjectVerticalHeadingUp: {
      self.userObject.position = [self updatedPlanePositionWithSpeedX:0 speedY:-FTTMUserObjectSpeed];
      break;
    }
    case FTTMUserObjectVerticalHeadingDown: {
      self.userObject.position = [self updatedPlanePositionWithSpeedX:0 speedY:FTTMUserObjectSpeed];
      break;
    }
    default:
      break;
  }

  switch (self.userObjectHorizontalHeading) {
    case FTTMUserObjectHorizontalHeadingLeft: {
      self.userObject.position = [self updatedPlanePositionWithSpeedX:-FTTMUserObjectSpeed speedY:0];
      break;
    }
    case FTTMUserObjectHorizontalHeadingRight: {
      self.userObject.position = [self updatedPlanePositionWithSpeedX:FTTMUserObjectSpeed speedY:0];
      break;
    }
    default:
      break;
  }
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
