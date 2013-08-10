//
//  FTTGameViewController.m
//  FortyTwo
//
//  Created by Forrest Ye on 8/10/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import "FTTGameViewController.h"

#import <CoreMotion/CoreMotion.h>


@interface FTTGameViewController ()

@property (nonatomic) CMMotionManager *motionMannager;

@property (nonatomic) NSOperationQueue *motionHandlingQueue;

@property (nonatomic) UIView *planeView;

@end


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

  self.planeView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 10, 10)];
  self.planeView.backgroundColor = [UIColor whiteColor];

  [self.view addSubview:self.planeView];

  __weak FTTGameViewController *weakSelf = self;
  [self.motionMannager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {

//    NSLog(@"acc %@", accelerometerData);
    CGFloat newX = weakSelf.planeView.center.x + accelerometerData.acceleration.x * 10;
    CGFloat newY = weakSelf.planeView.center.y - accelerometerData.acceleration.y * 10;

    newX = MAX(0, newX);
    newX = MIN(320, newX);
    newY = MAX(0, newY);
    newY = MIN(480, newY);

    [UIView animateWithDuration:0.09 animations:^{
      weakSelf.planeView.center = CGPointMake(newX, newY);
    }];
  }];
}


@end
