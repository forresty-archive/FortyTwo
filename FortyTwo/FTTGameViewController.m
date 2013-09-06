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

// misc
#import "FTTDefines.h"

#import "FTTUniverseDataSource.h"
#import "FTTFrameManager.h"
#import "FTTAccelerometerInputSource.h"

// FFToolkit
#import "FFGameCenterManager.h"


@interface FTTGameViewController ()

// shout detection
@property (nonatomic) FTTShoutDetector *shoutDetector;
@property (nonatomic) BOOL bombDeployed;

// views
@property (nonatomic) FTTUniverseView *universeView;

// models
@property (nonatomic) FTTUniverse *universe;

// misc
@property (nonatomic) FTTUniverseDataSource *universeDataSource;

// game center
@property (nonatomic) FFGameCenterManager *gameCenterManager;

// game play
@property (nonatomic) FTTFrameManager *frameManager;
@property (nonatomic) FTTAccelerometerInputSource *accelerometerInputSource;

@property (nonatomic) BOOL gamePlaying;
@property (nonatomic) BOOL gameStarted;

@property (nonatomic) NSTimeInterval cumulatedCurrentGamePlayTime;
@property (nonatomic) NSTimeInterval resumedTimestamp;

@property (nonatomic) NSTimeInterval cumulatedBombCooldownTime;

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

  self.gameCenterManager = [FFGameCenterManager sharedManager];
  self.accelerometerInputSource = [[FTTAccelerometerInputSource alloc] init];

  self.view.backgroundColor = [UIColor blackColor];

  self.shoutDetector = [[FTTShoutDetector alloc] init];
  self.shoutDetector.delegate = self;

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

  self.cumulatedCurrentGamePlayTime = 0;
  self.cumulatedBombCooldownTime = 0;
  self.resumedTimestamp = 0;

  [self.accelerometerInputSource startUpdatingUserInput];
}

- (void)youAreDead {
  @synchronized(self) {
    [self.frameManager pause];
    [self.accelerometerInputSource stopUpdatingUserInput];

    if (self.gamePlaying) {
      self.gamePlaying = NO;

      // TODO: this seems not working
      // Vibrate
      AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

      [self.gameCenterManager reportScore:self.cumulatedCurrentGamePlayTime * 100
                 forLeaderBoardIdentifier:@"com.forresty.FortyTwo.timeLasted"];

      [self showGameOverAlert];
    }
  }
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
    if (self.gamePlaying) {
      self.resumedTimestamp = 0;

      [self.frameManager pause];
      [self.accelerometerInputSource stopUpdatingUserInput];

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
  [self.frameManager start];
  [self.accelerometerInputSource startUpdatingUserInput];
}


# pragma mark - position update


- (void)updateTimestampsWithTimeInterval:(NSTimeInterval)timestamp {
  if (self.resumedTimestamp == 0) {
    self.resumedTimestamp = timestamp;
  }
  self.cumulatedCurrentGamePlayTime = timestamp - self.resumedTimestamp;

  if (self.cumulatedCurrentGamePlayTime >= 42) {
    [self.gameCenterManager reportAchievementWithIdentifier:@"FortyTwo.FortyTwo"];
  }
}

- (void)updateUniverse {
  self.universeView.bombCooldownTime = self.cumulatedCurrentGamePlayTime - self.cumulatedBombCooldownTime;
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
  if (self.cumulatedCurrentGamePlayTime - self.cumulatedBombCooldownTime >= FTTBombCooldownTime) {

    self.cumulatedBombCooldownTime = self.cumulatedCurrentGamePlayTime;

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
    [self.gameCenterManager reportAchievementWithIdentifier:@"FortyTwo.BluePill"];

    self.cumulatedBombCooldownTime = self.cumulatedCurrentGamePlayTime;
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.universeView deployBomb];
    });

    [self.universe resetEnemies];
  }

  // record time
  [self updateTimestampsWithTimeInterval:[NSDate timeIntervalSinceReferenceDate]];

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
