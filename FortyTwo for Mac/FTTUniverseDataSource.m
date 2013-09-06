//
//  FTTUniverseDataSource.m
//  FortyTwo
//
//  Created by Forrest Ye on 9/4/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import "FTTUniverseDataSource.h"

// models
#import "FTTUniverse.h"
#import "FTTUserObject.h"
#import "FTTEnemyObject.h"


@interface FTTUniverseDataSource ()

@property (nonatomic) FTTUniverse *universe;

@end


@implementation FTTUniverseDataSource


- (instancetype)initWithUniverse:(FTTUniverse *)universe {
  self = [self init];

  if (self) {
    self.universe = universe;
  }

  return self;
}


# pragma mark - FTTMUniverseViewDataSource

# pragma mark - position of objects


- (CGPoint)positionOfUserObject {
  return self.universe.userObject.position;
}

- (NSArray *)positionsOfEnemyObjects {
  NSMutableArray *positions = [NSMutableArray arrayWithCapacity:42];

  for (FTTEnemyObject *enemy in self.universe.enemies) {
    [positions addObject:[NSString stringWithFormat:@"{%f, %f}", enemy.position.x, enemy.position.y]];
  }

  return positions;
}


# pragma mark - bomb


- (CGFloat)percentCompleteOfBombRecharge {
  return 42;
}

- (BOOL)bombAvailable {
  return NO;
}

- (BOOL)bombDeployed {
  return NO;
}


@end
