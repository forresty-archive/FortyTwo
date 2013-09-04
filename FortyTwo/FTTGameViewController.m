//
//  FTTGameViewController.m
//  FortyTwo
//
//  Created by Forrest Ye on 8/10/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import "FTTGameViewController.h"

// frameworks
// -- motion
#import <CoreMotion/CoreMotion.h>
// -- vibration
#import <AVFoundation/AVFoundation.h>

// views
#import "FTTUniverseView.h"

// models
#import "FTTUserObject.h"
#import "FTTEnemyObject.h"

#import "FTTDefines.h"

// FFToolkit
#import "FFGameCenterManager.h"


@interface FTTGameViewController ()

// motion control
@property (nonatomic) CMMotionManager *motionMannager;
@property (nonatomic) NSOperationQueue *backgroundQueue;

// shout detection
@property (nonatomic) FTTShoutDetector *shoutDetector;
@property (nonatomic) BOOL bombDeployed;

// views
@property (nonatomic) FTTUniverseView *universeView;

// models
@property (nonatomic) FTTUserObject *userObject;
@property (nonatomic) NSMutableArray *enemies;

// game center
@property (nonatomic) FFGameCenterManager *gameCenterManager;

// game play
@property (nonatomic) BOOL gamePlaying;
@property (nonatomic) BOOL gameStarted;

@property (nonatomic) NSTimeInterval cumulatedCurrentGamePlayTime;
@property (nonatomic) NSTimeInterval resumedTimestamp;

@property (nonatomic) NSTimeInterval cumulatedBombCooldownTime;

@end


@implementation FTTGameViewController


+ (void)initialize {
  [FTTObject registerDefaultObjectWidth:FTTObjectWidth()];
  [FTTUserObject registerDefaultSpawnPosition:CGPointMake(DeviceWidth() / 2, DeviceHeight() / 2)];
  [FTTEnemyObject registerUniverseSize:CGSizeMake(DeviceWidth(), DeviceHeight())];

  if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
    [FTTEnemyObject registerTimeToUserParam:60];
  } else {
    [FTTEnemyObject registerTimeToUserParam:90];
  }

}

- (instancetype)init {
  self = [super init];

  if (self) {
    self.motionMannager = [[CMMotionManager alloc] init];
    self.motionMannager.accelerometerUpdateInterval = 1.0 / 42; // 42 fps baby

    self.backgroundQueue = [[NSOperationQueue alloc] init];
    self.backgroundQueue.maxConcurrentOperationCount = 1;
  }

  return self;
}


- (void)viewDidLoad {
  [super viewDidLoad];

  self.gameCenterManager = [FFGameCenterManager sharedManager];

  [self setupPlane];
  [self setupEnemies];
  self.shoutDetector = [[FTTShoutDetector alloc] init];
  self.shoutDetector.delegate = self;

  self.view.backgroundColor = [UIColor blackColor];
  self.universeView = [[FTTUniverseView alloc] initWithFrame:self.view.bounds];
  self.universeView.dataSource = self;
  [self.view addSubview:self.universeView];

  [self restartGame];
}


# pragma mark - game control


- (void)restartGame {
  NSParameterAssert(self.motionMannager.accelerometerActive == NO);

  [self.userObject resetPosition];

  [self resetEnemies];

  self.gamePlaying = YES;
  self.gameStarted = YES;

  self.cumulatedCurrentGamePlayTime = 0;
  self.cumulatedBombCooldownTime = 0;
  self.resumedTimestamp = 0;
  [self startReceivingAccelerationData];
}

// used in simulator && dev env only
- (void)simulateFrame {
  [self updateTimestampsWithTimeInterval:[NSDate timeIntervalSinceReferenceDate]];
  [self moveEnemies];

  self.userObject.position = [self updatedPlanePositionWithSpeedX:(rand() % 100 / 100.0) speedY:(rand() % 100 / 100.0)];

  [NSThread sleepForTimeInterval:1.0 / 42];

  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    [self updateUniverse];
  }];

  // detect collision
  [self detectCollision];
}

- (void)youAreDead {
  @synchronized(self) {
    [self.motionMannager stopAccelerometerUpdates];

    if (self.gamePlaying) {
      self.gamePlaying = NO;

      // TODO: this seems not working
      // Vibrate
      AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

      if (self.gameCenterManager.gameCenterEnabled) {
        [self reportScore];
      }

      [self showGameOverAlert];
    }
  }
}

- (void)reportScore {
  [self.gameCenterManager reportScore:self.cumulatedCurrentGamePlayTime * 100
             forLeaderBoardIdentifier:@"com.forresty.FortyTwo.timeLasted"];
}

- (void)showGameOverAlert {
  NSString *messageFormat = NSLocalizedString(@"You lasted %.1f seconds.", nil);
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"You are dead.", nil)
                                                  message:[NSString stringWithFormat:messageFormat, self.cumulatedCurrentGamePlayTime]
                                                 delegate:self
                                        cancelButtonTitle:NSLocalizedString(@"Retry", nil)
                                        otherButtonTitles: nil];

  [alert show];
}

- (void)pauseGame {
  @synchronized(self) {
    if (self.gamePlaying && self.motionMannager.accelerometerActive) {
      self.resumedTimestamp = 0;

      [self.motionMannager stopAccelerometerUpdates];

      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Game Paused", nil)
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"Resume", nil)
                                            otherButtonTitles:nil];

      [alert show];
    }
  }
}

- (void)resumeGame {
  [self startReceivingAccelerationData];
}


# pragma mark - UI setup


- (void)setupPlane {
  self.userObject = [[FTTUserObject alloc] init];
}

- (void)setupEnemies {
  self.enemies = [NSMutableArray arrayWithCapacity:42];

  for (int i = 0; i < 42; i++) {
    FTTEnemyObject *enemy = [[FTTEnemyObject alloc] initWithTargetUserObject:self.userObject];

    [self.enemies addObject:enemy];
  }
}


# pragma mark - position update

- (void)resetEnemies {
  for (int i = 0; i < 42; i++) {
    FTTEnemyObject *enemy = self.enemies[i];

    [enemy resetPosition];
    [enemy resetSpeed];
  }
}

- (CGPoint)updatedPlanePositionWithSpeedX:(CGFloat)speedX speedY:(CGFloat)speedY {
  CGFloat speed = 4;

  if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
    speed = 12;
  }

  CGFloat newX = self.userObject.position.x + speedX * speed;
  CGFloat newY = self.userObject.position.y - speedY * speed;

  newX = MAX(0, newX);
  newX = MIN(DeviceWidth(), newX);
  newY = MAX(0, newY);
  newY = MIN(DeviceHeight(), newY);
  CGPoint newCenterForPlane = CGPointMake(newX, newY);

  return newCenterForPlane;
}

- (void)startReceivingAccelerationData {
  NSParameterAssert(self.motionMannager.accelerometerActive == NO);

  __weak FTTGameViewController *weakSelf = self;

  [self.motionMannager startAccelerometerUpdatesToQueue:self.backgroundQueue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {

    // record time
    [self updateTimestampsWithTimeInterval:accelerometerData.timestamp];

    // bomb
    if (weakSelf.bombDeployed) {
      weakSelf.cumulatedBombCooldownTime = weakSelf.cumulatedCurrentGamePlayTime;
      [weakSelf.universeView deployBomb];
      [weakSelf resetEnemies];
    }

    // move plane
    weakSelf.userObject.position = [weakSelf updatedPlanePositionWithSpeedX:accelerometerData.acceleration.x
                                                                     speedY:accelerometerData.acceleration.y];
    // move enemies
    [weakSelf moveEnemies];

    // draw universe
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
      [weakSelf updateUniverse];
    }];

    // detect collision
    [weakSelf detectCollision];
  }];
}

- (void)updateTimestampsWithTimeInterval:(NSTimeInterval)timestamp {
  if (self.resumedTimestamp == 0) {
    self.resumedTimestamp = timestamp;
  }
  self.cumulatedCurrentGamePlayTime = timestamp - self.resumedTimestamp;

  if (self.cumulatedCurrentGamePlayTime >= 42) {
    [self.gameCenterManager reportAchievementWithIdentifier:@"FortyTwo.FortyTwo"];
  }
}

- (void)moveEnemies {
  for (int i = 0; i < 42; i++) {
    FTTEnemyObject *enemy = self.enemies[i];

    [enemy move];
  }
}

- (void)updateUniverse {
  self.universeView.bombCooldownTime = self.cumulatedCurrentGamePlayTime - self.cumulatedBombCooldownTime;
  [self.universeView setNeedsDisplay];
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


# pragma mark - UIAlertViewDelegate


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (self.gamePlaying) {
    [self resumeGame];
  } else {
    [self restartGame];
  }
}


# pragma mark - FTTUniverseViewDataSource


- (CGPoint)positionOfUserObject {
  return self.userObject.position;
}

- (NSArray *)positionsOfEnemyObjects {
  NSMutableArray *positions = [NSMutableArray arrayWithCapacity:42];
  for (FTTEnemyObject *enemy in self.enemies) {
    [positions addObject:NSStringFromCGPoint(enemy.position)];
  }

  return positions;
}


# pragma mark - FTTShoutDetectorDelegate


- (void)shoutDetectorDidDetectShout {
  if (self.cumulatedCurrentGamePlayTime - self.cumulatedBombCooldownTime >= FTTBombCooldownTime) {

    self.cumulatedBombCooldownTime = self.cumulatedCurrentGamePlayTime;

    self.bombDeployed = YES;
  }
}

- (void)shoutDetectorShoutDidEnd {
  self.bombDeployed = NO;
}


@end
