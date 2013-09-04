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
#import "FTTUniverse.h"
#import "FTTUserObject.h"
#import "FTTEnemyObject.h"

// keyboard control
#import "FTTMKeyboardInputSource.h"


@interface FTTMGameViewController ()

// views
@property (nonatomic) FTTMUniverseView *universeView;

// models
@property (nonatomic) FTTUniverse *universe;

// game play
@property (nonatomic) FTTFrameManager *frameManager;
@property (nonatomic) FTTMKeyboardInputSource *keyboardInputSource;

@property (nonatomic) BOOL gamePlaying;

@property (nonatomic) NSTimeInterval cumulatedCurrentGamePlayTime;
@property (nonatomic) NSTimeInterval resumedTimestamp;

@end


@implementation FTTMGameViewController

+ (void)initialize {
  [FTTObject registerDefaultObjectWidth:5];
  [FTTUserObject registerDefaultSpawnPosition:CGPointMake(240, 180)];
  [FTTEnemyObject registerUniverseSize:CGSizeMake(480, 360)];
  [FTTEnemyObject registerTimeToUserParam:90];
}

- (id)init {
  self = [super init];

  if (self) {
    [self restartGame];
  }

  return self;
}


# pragma mark - game play


- (void)restartGame {
  self.keyboardInputSource = [[FTTMKeyboardInputSource alloc] init];
  self.nextResponder = self.keyboardInputSource;

  self.universeView = [[FTTMUniverseView alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)];
  self.view = self.universeView;

  self.universe = [[FTTUniverse alloc] initWithWidth:480 height:360];
  self.universeView.dataSource = self.universe;

  self.frameManager = [[FTTFrameManager alloc] initWithFrameRate:42];
  self.frameManager.delegate = self;
  [self.frameManager start];

  self.gamePlaying = YES;
}

- (void)updateTimestampsWithTimeInterval:(NSTimeInterval)timestamp {
  if (self.resumedTimestamp == 0) {
    self.resumedTimestamp = timestamp;
  }
  self.cumulatedCurrentGamePlayTime = timestamp - self.resumedTimestamp;
}

- (void)updateUniverse {
  [self.universeView setNeedsDisplay:YES];
}

- (void)detectCollision {
  if (self.universe.userIsHit) {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
      [self youAreDead];
    }];
  }
}

- (void)youAreDead {
  @synchronized(self) {
    if (self.gamePlaying) {
      [self stopGame];

      NSLog(@"you are dead");
    }
  }
}

- (void)stopGame {
  [self.frameManager pause];

  self.gamePlaying = NO;
}


# pragma mark - FTTFrameManagerDelegate


- (void)frameManagerDidUpdateFrame {
  [self updateTimestampsWithTimeInterval:[NSDate timeIntervalSinceReferenceDate]];

  [self.universe updateUserWithSpeedVector:self.keyboardInputSource.userSpeedVector];
  [self.universe tick];

  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    [self updateUniverse];
  }];

  [self detectCollision];
}


@end
