//
//  FTTGameViewController.m
//  FortyTwo
//
//  Created by Forrest Ye on 8/10/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import "FTTGameViewController.h"

// frameworks
// -- vibration
#import <AVFoundation/AVFoundation.h>

// views
#import "FTTUniverseView.h"

// models
#import "FTTUniverse.h"
#import "FTTEnemyObject.h"

#import "FTTUniverseDataSource.h"
#import "FTTFrameManager.h"
#import "FTTAccelerometerInputSource.h"
#import "FTTAlertViewManager.h"
#import "FTTGameCenterManager.h"

// FFToolkit
#import "FFStopWatch.h"


@interface FTTGameViewController ()

// views
@property (nonatomic) FTTUniverseView *universeView;

// models
@property (nonatomic) FTTUniverse *universe;

// misc
@property (nonatomic) FTTUniverseDataSource *universeDataSource;

// game play
@property (nonatomic) FTTFrameManager *frameManager;
@property (nonatomic) FTTAccelerometerInputSource *accelerometerInputSource;
@property (nonatomic) FTTAlertViewManager *alertViewManager;
@property (nonatomic) FTTGameCenterManager *gameCenterManager;
@property (nonatomic) FFStopWatch *stopWatch;
@property (nonatomic) FTTShoutDetector *shoutDetector;
@property (nonatomic) BOOL bombDeployed;

@property (nonatomic) BOOL gamePlaying;
@property (nonatomic) BOOL gameStarted;

@end


@implementation FTTGameViewController


+ (void)initialize {
  [FTTObject registerDefaultObjectWidth:FTTObjectWidth()];

  if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
    [FTTEnemyObject registerTimeToUserParam:60];
  } else {
    [FTTEnemyObject registerTimeToUserParam:90];
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.gameCenterManager = [FTTGameCenterManager defaultManager];

  self.accelerometerInputSource = [[FTTAccelerometerInputSource alloc] init];

  self.view.backgroundColor = [UIColor blackColor];

  self.shoutDetector = [[FTTShoutDetector alloc] init];
  self.shoutDetector.delegate = self;

  self.alertViewManager = [FTTAlertViewManager defaultManager];
  self.alertViewManager.alertViewDelegate = self;

  self.universeView = [[FTTUniverseView alloc] initWithFrame:self.view.bounds];

  [self.view addSubview:self.universeView];

  [self restartGame];
}


# pragma mark - game control


- (void)restartGame {
  self.universe = [[FTTUniverse alloc] initWithWidth:FTTDeviceWidth() height:FTTDeviceHeight()];
  self.universeDataSource = [[FTTUniverseDataSource alloc] initWithUniverse:self.universe];
  self.universeView.dataSource = self.universeDataSource;

  self.frameManager = [[FTTFrameManager alloc] initWithFrameRate:42];
  self.frameManager.delegate = self;
  [self.frameManager start];

  self.gamePlaying = YES;
  self.gameStarted = YES;

  self.stopWatch = [[FFStopWatch alloc] init];
  [self.stopWatch start];
  [self.accelerometerInputSource startUpdatingUserInput];
}

- (void)youAreDead {
  @synchronized(self) {
    [self.frameManager pause];
    [self.stopWatch pause];
    [self.accelerometerInputSource stopUpdatingUserInput];

    if (self.gamePlaying) {
      self.gamePlaying = NO;

      // TODO: this seems not working
      // Vibrate
      AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

      [self.gameCenterManager reportTimeLasted:self.stopWatch.totalTimeElapsed];
      [self.gameCenterManager diedOnce];
      [self.alertViewManager showGameOverAlertWithTimeLasted:self.stopWatch.totalTimeElapsed];
    }
  }
}


- (void)pauseGame {
  @synchronized(self) {
    if (self.gamePlaying) {
      [self.stopWatch pause];

      [self.frameManager pause];
      [self.accelerometerInputSource stopUpdatingUserInput];

      [self.alertViewManager showGamePausedAlert];
    }
  }
}

- (void)resumeGame {
  [self.frameManager start];
  [self.stopWatch resume];
  [self.accelerometerInputSource startUpdatingUserInput];
}


# pragma mark - position update


- (void)updateUniverse {
  self.universeView.bombCooldownTime = self.stopWatch.timeElapsed;
  [self.universeView setNeedsDisplay];
}

- (void)detectCollision {
  if (self.universe.userIsHit) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [self youAreDead];
    });
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


# pragma mark - FTTShoutDetectorDelegate


- (void)shoutDetectorDidDetectShout {
  if (self.stopWatch.timeElapsed >= FTTBombCooldownTime) {

    [self.stopWatch lap];

    self.bombDeployed = YES;
  }
}

- (void)shoutDetectorShoutDidEnd {
  self.bombDeployed = NO;
}


# pragma mark - FTTFrameManagerDelegate


- (void)frameManagerDidUpdateFrame {
  // bomb
  if (self.bombDeployed) {
    [self.gameCenterManager usedABluePill];

    dispatch_async(dispatch_get_main_queue(), ^{
      [self.universeView deployBomb];
    });

    [self.universe resetEnemies];
  }

  if (self.stopWatch.totalTimeElapsed >= 42) {
    [self.gameCenterManager lasted42Seconds];
  }

  [self.universe updateUserWithSpeedVector:self.accelerometerInputSource.userSpeedVector];
  [self.universe tick];

  // draw universe
  dispatch_async(dispatch_get_main_queue(), ^{
    [self updateUniverse];
  });

  // detect collision
  [self detectCollision];
}


@end
