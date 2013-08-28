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

// game play
@property (nonatomic) BOOL gamePlaying;

@property (nonatomic) NSTimeInterval cumulatedCurrentGamePlayTime;
@property (nonatomic) NSTimeInterval resumedTimestamp;

@property (nonatomic) NSTimer *timer;

@end


@implementation FTTMGameViewController


+ (void)initialize {
  [FTTObject registerDefaultObjectWidth:5];
  [FTTUserObject registerDefaultSpawnPosition:CGPointMake(240, 180)];
  [FTTEnemyObject registerUniverseSize:CGSizeMake(480, 360)];
  [FTTEnemyObject registerTimeToUserParam:60];
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

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0/42 target:self selector:@selector(simulateFrame) userInfo:nil repeats:YES];
    self.gamePlaying = YES;
  }

  return self;
}


- (void)simulateFrame {
  [self updateTimestampsWithTimeInterval:[NSDate timeIntervalSinceReferenceDate]];
  [self moveEnemies];

  [NSThread sleepForTimeInterval:1.0 / 42];

  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    [self updateUniverse];
  }];

  [self detectCollision];
}


- (void)updateTimestampsWithTimeInterval:(NSTimeInterval)timestamp {
  if (self.resumedTimestamp == 0) {
    self.resumedTimestamp = timestamp;
  }
  self.cumulatedCurrentGamePlayTime = timestamp - self.resumedTimestamp;
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

- (void)moveEnemies {
  for (int i = 0; i < 42; i++) {
    FTTEnemyObject *enemy = self.enemies[i];

    [enemy moveTowardsUserObject:self.userObject];
  }
}

- (void)updateUniverse {
  [self.universeView setNeedsDisplay:YES];
}


- (void)detectCollision {
  for (int i = 0; i < 42; i++) {
    FTTEnemyObject *enemy = self.enemies[i];

    if ([enemy hitUserObject:self.userObject]) {
      [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self youAreDead];
      }];

      break;
    }
  }
}

- (void)youAreDead {
  @synchronized(self) {
    [self.timer invalidate];

    if (self.gamePlaying) {
      self.gamePlaying = NO;

      NSLog(@"you are dead");
//      if (self.gameCenterEnabled) {
//        [self reportScore];
//      }
//
//      [self showGameOverAlert];
    }
  }
}


# pragma mark - keyboard event handling

- (void)keyDown:(NSEvent *)theEvent {
  // Arrow keys are associated with the numeric keypad
  if ([theEvent modifierFlags] & NSNumericPadKeyMask) {
    [self interpretKeyEvents:[NSArray arrayWithObject:theEvent]];
  } else {
    [super keyDown:theEvent];
  }
}

- (void)moveUp:(id)sender {
  self.userObject.position = [self updatedPlanePositionWithSpeedX:0 speedY:-1];
  [self detectCollision];
}

- (void)moveDown:(id)sender {
  self.userObject.position = [self updatedPlanePositionWithSpeedX:0 speedY:1];
  [self detectCollision];
}

- (void)moveLeft:(id)sender {
  self.userObject.position = [self updatedPlanePositionWithSpeedX:-1 speedY:0];
  [self detectCollision];
}

- (void)moveRight:(id)sender {
  self.userObject.position = [self updatedPlanePositionWithSpeedX:1 speedY:0];
    [self detectCollision];
}

@end
