//
//  FTTGameViewController.m
//  FortyTwo
//
//  Created by Forrest Ye on 8/10/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import "FTTGameViewController.h"

#import <CoreMotion/CoreMotion.h>

#import "FTTEnemyView.h"


@interface FTTGameViewController ()

@property (nonatomic) CMMotionManager *motionMannager;
@property (nonatomic) UIView *planeView;
@property (nonatomic) NSMutableArray *enemies;
@property (nonatomic) BOOL gamePlaying;

@end


typedef NS_ENUM(NSUInteger, FTTEnemySpawnLocation) {
  FTTEnemySpawnLocationTop,
  FTTEnemySpawnLocationLeft,
  FTTEnemySpawnLocationBottom,
  FTTEnemySpawnLocationRight,
};


static inline CGFloat FTTObjectWidth() {
  if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
    return 8;
  }

  return 5;
}


@implementation FTTGameViewController


+ (instancetype)sharedInstance {
  static FTTGameViewController *_instance = nil;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _instance = [[self alloc] init];
  });

  return _instance;
}


- (instancetype)init {
  self = [super init];

  if (self) {
    self.wantsFullScreenLayout = YES;

    self.motionMannager = [[CMMotionManager alloc] init];
    self.motionMannager.accelerometerUpdateInterval = 0.1;
  }

  return self;
}


- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor = [UIColor blackColor];

  [self setupPlane];
  [self setupEnemies];
  [self restartGame];
}


- (void)youAreDead {
  @synchronized(self) {
    [self.motionMannager stopAccelerometerUpdates];

    if (self.gamePlaying) {
      self.gamePlaying = NO;

      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"You are dead.", nil)
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"Retry", nil)
                                            otherButtonTitles: nil];

      [alert show];
    }
  }
}


- (void)pauseGame {
  @synchronized(self) {
    if (self.gamePlaying) {
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
  self.planeView = [[UIView alloc] initWithFrame:CGRectMake(self.deviceWidth / 2, self.deviceHeight / 2, FTTObjectWidth(), FTTObjectWidth())];
  self.planeView.backgroundColor = [UIColor whiteColor];

  [self.view addSubview:self.planeView];
}


- (void)setupEnemies {
  self.enemies = [NSMutableArray arrayWithCapacity:42];

  for (int i = 0; i < 42; i++) {
    CGRect frame = CGRectMake(0, 0, FTTObjectWidth(), FTTObjectWidth());

    FTTEnemyView *enemy = [[FTTEnemyView alloc] initWithFrame:frame];

    enemy.backgroundColor = [UIColor redColor];

    [self.enemies addObject:enemy];

    [self.view addSubview:enemy];

    [self resetEnemy:enemy];
  }
}


- (void)resetEnemy:(FTTEnemyView *)enemy {
  FTTEnemySpawnLocation location = rand() % 4;

  CGPoint center;

  switch (location) {
    case FTTEnemySpawnLocationTop: {
      center = CGPointMake(rand() % self.deviceWidth, 0);
      break;
    }
    case FTTEnemySpawnLocationLeft: {
      center = CGPointMake(0, rand() % self.deviceHeight);
      break;
    }
    case FTTEnemySpawnLocationBottom: {
      center = CGPointMake(rand() % self.deviceWidth, self.deviceHeight);
      break;
    }
    case FTTEnemySpawnLocationRight: {
      center = CGPointMake(self.deviceWidth, rand() % self.deviceHeight);
      break;
    }
  }

  enemy.center = center;

  CGFloat speed = rand() % 10 + 20;
  enemy.speedX = (self.planeView.center.x - enemy.center.x) / speed;
  enemy.speedY = (self.planeView.center.y - enemy.center.y) / speed;
}


- (void)resetEnemies {
  for (int i = 0; i < 42; i++) {
    FTTEnemyView *enemy = self.enemies[i];

    [self resetEnemy:enemy];
  }
}


- (CGPoint)updatedPlanePositionWithAccelerometerData:(CMAccelerometerData *)accelerometerData {
  CGFloat speed = 15;

  if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
    speed = 25;
  }

  CGFloat newX = self.planeView.center.x + accelerometerData.acceleration.x * speed;
  CGFloat newY = self.planeView.center.y - accelerometerData.acceleration.y * speed;

  newX = MAX(0, newX);
  newX = MIN(self.deviceWidth, newX);
  newY = MAX(0, newY);
  newY = MIN(self.deviceHeight, newY);
  CGPoint newCenterForPlane = CGPointMake(newX, newY);

  return newCenterForPlane;
}


- (void)detectEnemyPositionsAndResetIfNeeded {
  for (int i = 0; i < 42; i++) {
    FTTEnemyView *enemy = self.enemies[i];

    CGFloat newX = enemy.center.x + enemy.speedX;
    CGFloat newY = enemy.center.y + enemy.speedY;

    if (newX <= 0 || newX >= self.deviceWidth || newY <= 0 || newY >= self.deviceHeight) {
      [self resetEnemy:enemy];
    }
  }
}


- (void)restartGame {
  self.planeView.center = CGPointMake(self.deviceWidth / 2, self.deviceHeight / 2);

  [self resetEnemies];

  self.gamePlaying = YES;

  [self startReceivingAccelerationData];
}


- (void)startReceivingAccelerationData {
  __weak FTTGameViewController *weakSelf = self;

  [self.motionMannager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {

    //    NSLog(@"acc %@", accelerometerData);

    [weakSelf detectEnemyPositionsAndResetIfNeeded];

    [UIView animateWithDuration:0.07 animations:^{

      // move plane
      weakSelf.planeView.center = [weakSelf updatedPlanePositionWithAccelerometerData:accelerometerData];

      // move enemies and detect collision
      for (int i = 0; i < 42; i++) {
        FTTEnemyView *enemy = weakSelf.enemies[i];

        enemy.center = CGPointMake(enemy.center.x + enemy.speedX,
                                   enemy.center.y + enemy.speedY);

        if (CGRectIntersectsRect(enemy.frame, weakSelf.planeView.frame)) {
          [weakSelf youAreDead];

          break;
        }
      }
    }];
  }];
}


# pragma mark
# pragma mark - UIAlertViewDelegate


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (self.gamePlaying) {
    [self resumeGame];
  } else {
    [self restartGame];
  }
}


# pragma mark - private


- (NSUInteger)deviceWidth {
  return [UIScreen mainScreen].bounds.size.width;
}


- (NSUInteger)deviceHeight {
  return [UIScreen mainScreen].bounds.size.height;
}


@end
