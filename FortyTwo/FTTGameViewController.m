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

@property (nonatomic) NSOperationQueue *motionHandlingQueue;

@property (nonatomic) UIView *planeView;

@property (nonatomic) NSMutableArray *enemies;

@end


typedef NS_ENUM(NSUInteger, FTTEnemySpawnLocation) {
  FTTEnemySpawnLocationTop,

  FTTEnemySpawnLocationLeft,

  FTTEnemySpawnLocationBottom,

  FTTEnemySpawnLocationRight,
};

static const CGFloat FTTObjectWidth = 5;
static const CGFloat FTTObjectHeight = 5;


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

    self.motionHandlingQueue = [[NSOperationQueue alloc] init];

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

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"You are dead.", nil) message:nil delegate:self cancelButtonTitle:@"Retry" otherButtonTitles: nil];

    [alert show];
  }
}


- (void)setupPlane {
  self.planeView = [[UIView alloc] initWithFrame:CGRectMake(self.deviceWidth / 2, self.deviceHeight / 2, FTTObjectWidth, FTTObjectWidth)];
  self.planeView.backgroundColor = [UIColor whiteColor];

  [self.view addSubview:self.planeView];
}


- (void)setupEnemies {
  self.enemies = [NSMutableArray arrayWithCapacity:42];

  for (int i = 0; i < 42; i++) {
    CGRect frame = CGRectMake(0, 0, FTTObjectWidth, FTTObjectWidth);

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

  CGFloat speed = rand() % 10 + 15; // between 15 ~ 25
  enemy.speedX = (self.planeView.center.x - enemy.center.x) / speed;
  enemy.speedY = (self.planeView.center.y - enemy.center.y) / speed;
}


- (NSUInteger)deviceWidth {
  return 320;
}


- (NSUInteger)deviceHeight {
  return 480;
}


- (void)restartGame {
  self.planeView.center = CGPointMake(self.deviceWidth / 2, self.deviceHeight / 2);

  for (int i = 0; i < 42; i++) {
    FTTEnemyView *enemy = self.enemies[i];

    [self resetEnemy:enemy];
  }


  __weak FTTGameViewController *weakSelf = self;

  [self.motionMannager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {

    //    NSLog(@"acc %@", accelerometerData);

    [UIView animateWithDuration:0.09 animations:^{

      CGFloat newX = weakSelf.planeView.center.x + accelerometerData.acceleration.x * 10;
      CGFloat newY = weakSelf.planeView.center.y - accelerometerData.acceleration.y * 10;

      newX = MAX(0, newX);
      newX = MIN(320, newX);
      newY = MAX(0, newY);
      newY = MIN(480, newY);

      weakSelf.planeView.center = CGPointMake(newX, newY);

      for (int i = 0; i < 42; i++) {
        FTTEnemyView *enemy = weakSelf.enemies[i];

        CGFloat newX = enemy.center.x + enemy.speedX;
        CGFloat newY = enemy.center.y + enemy.speedY;

        enemy.center = CGPointMake(newX, newY);

        if (CGRectIntersectsRect(enemy.frame, weakSelf.planeView.frame)) {
          [weakSelf youAreDead];
        }

        if (newX <= 0 || newX >= 320 || newY <= 0 || newY >= 480) {
          [self resetEnemy:enemy];
        }
      }
    }];
  }];
}


# pragma mark
# pragma mark - UIAlertViewDelegate


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  [self restartGame];
}


@end
