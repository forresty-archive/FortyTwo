//
//  FTTMGameViewController.m
//  FortyTwo
//
//  Created by Forrest Ye on 8/28/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import "FTTMGameViewController.h"

// views
#import "FTTMUniverseView.h"

// models
#import "FTTUserObject.h"
#import "FTTEnemyObject.h"


@interface FTTMGameViewController ()

// views
@property (nonatomic) FTTMUniverseView *universeView;

// models
@property (nonatomic) FTTUserObject *userObject;
@property (nonatomic) NSMutableArray *enemies;

@end


@implementation FTTMGameViewController


+ (void)initialize {
  [FTTObject registerDefaultObjectWidth:5];
  [FTTUserObject registerDefaultSpawnPosition:CGPointMake(240, 180)];
  [FTTEnemyObject registerUniverseSize:CGSizeMake(480, 360)];
}

- (id)init {
  self = [super init];

  if (self) {
    self.universeView = [[FTTMUniverseView alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)];
    self.view = self.universeView;
    self.userObject = [[FTTUserObject alloc] init];

    self.enemies = [NSMutableArray arrayWithCapacity:42];

    for (int i = 0; i < 42; i++) {
      FTTEnemyObject *enemy = [[FTTEnemyObject alloc] init];

      [self.enemies addObject:enemy];
    }

    self.universeView.userObject = self.userObject;
    self.universeView.enemies = self.enemies;
  }

  return self;
}


@end
