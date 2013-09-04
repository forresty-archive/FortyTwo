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


typedef NS_ENUM(NSUInteger, FTTMUserObjectVerticalHeading) {
  FTTMUserObjectVerticalHeadingNone,
  FTTMUserObjectVerticalHeadingUp,
  FTTMUserObjectVerticalHeadingDown,
};

typedef NS_ENUM(NSUInteger, FTTMUserObjectHorizontalHeading) {
  FTTMUserObjectHorizontalHeadingNone,
  FTTMUserObjectHorizontalHeadingLeft,
  FTTMUserObjectHorizontalHeadingRight,
};

@interface FTTMGameViewController ()

// views
@property (nonatomic) FTTMUniverseView *universeView;

// models
@property (nonatomic) FTTUserObject *userObject;
@property (nonatomic) NSMutableArray *enemies;

// game play
@property (nonatomic) FTTFrameManager *frameManager;

@property (nonatomic) BOOL gamePlaying;

@property (nonatomic) FTTMUserObjectVerticalHeading userObjectVerticalHeading;
@property (nonatomic) FTTMUserObjectHorizontalHeading userObjectHorizontalHeading;

@property (nonatomic) NSTimeInterval cumulatedCurrentGamePlayTime;
@property (nonatomic) NSTimeInterval resumedTimestamp;


@end


static CGFloat FTTMUserObjectSpeed = 0.5;


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
  self.universeView = [[FTTMUniverseView alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)];
  self.view = self.universeView;
  self.userObject = [[FTTUserObject alloc] init];

  self.enemies = [NSMutableArray arrayWithCapacity:42];

  for (int i = 0; i < 42; i++) {
    FTTEnemyObject *enemy = [[FTTEnemyObject alloc] initWithTargetUserObject:self.userObject];

    [self.enemies addObject:enemy];
  }

  self.universeView.dataSource = self;

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

- (void)updateUniverse {
  [self.universeView setNeedsDisplay:YES];
}


- (void)detectCollision {
  for (int i = 0; i < 42; i++) {
    FTTEnemyObject *enemy = self.enemies[i];

    if ([enemy hitTarget]) {
      [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self youAreDead];
      }];

      break;
    }
  }
}

- (void)youAreDead {
  @synchronized(self) {
    if (self.gamePlaying) {
      [self stopGame];

      NSLog(@"you are dead");
//      if (self.gameCenterEnabled) {
//        [self reportScore];
//      }
//
//      [self showGameOverAlert];
    }
  }
}

- (void)stopGame {
  [self.frameManager pause];

  self.gamePlaying = NO;
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

- (void)keyUp:(NSEvent *)theEvent {
  [super keyUp:theEvent];
  if (theEvent.keyCode == 126 || theEvent.keyCode == 125) {
    // up or down
    self.userObjectVerticalHeading = FTTMUserObjectVerticalHeadingNone;
  } else if (theEvent.keyCode == 123 || theEvent.keyCode == 124) {
    // left or right
    self.userObjectHorizontalHeading = FTTMUserObjectHorizontalHeadingNone;
  }
}

- (void)moveUp:(id)sender {
  self.userObjectVerticalHeading = FTTMUserObjectVerticalHeadingUp;
}

- (void)moveDown:(id)sender {
  self.userObjectVerticalHeading = FTTMUserObjectVerticalHeadingDown;
}

- (void)moveLeft:(id)sender {
  self.userObjectHorizontalHeading = FTTMUserObjectHorizontalHeadingLeft;
}

- (void)moveRight:(id)sender {
  self.userObjectHorizontalHeading = FTTMUserObjectHorizontalHeadingRight;
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


# pragma mark - FTTFrameManagerDelegate


- (void)frameManagerDidUpdateFrame {
  [self updateTimestampsWithTimeInterval:[NSDate timeIntervalSinceReferenceDate]];

  [self moveUserObject];
  [self moveEnemies];

  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    [self updateUniverse];
  }];

  [self detectCollision];
}


@end
