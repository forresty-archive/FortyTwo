//
//  FTTAccelerometerInputSource.m
//  FortyTwo
//
//  Created by Forrest Ye on 9/4/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import "FTTAccelerometerInputSource.h"

// frameworks
// -- motion
#import <CoreMotion/CoreMotion.h>

#import "FTTSpeedVector.h"


@interface FTTAccelerometerInputSource ()

// motion control
@property (nonatomic) CMMotionManager *motionMannager;
@property (nonatomic) NSOperationQueue *backgroundQueue;

@property FTTSpeedVector *userSpeedVector;

@end


@implementation FTTAccelerometerInputSource

- (instancetype)init {
  self = [super init];

  if (self) {
    self.motionMannager = [[CMMotionManager alloc] init];
    self.motionMannager.accelerometerUpdateInterval = 0.1;

    self.backgroundQueue = [[NSOperationQueue alloc] init];
    self.backgroundQueue.maxConcurrentOperationCount = 1;

    self.userSpeedVector = [[FTTSpeedVector alloc] init];
  }

  return self;
}

- (void)startUpdatingUserInput {
  NSParameterAssert(self.motionMannager.accelerometerActive == NO);

  [self.motionMannager startAccelerometerUpdatesToQueue:self.backgroundQueue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {

    CGFloat speed = 4;

    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
      speed = 12;
    }

    @synchronized(self) {
      self.userSpeedVector.x = speed * accelerometerData.acceleration.x;
      self.userSpeedVector.y = speed * accelerometerData.acceleration.y;
    }
  }];
}

- (void)stopUpdatingUserInput {
  [self.motionMannager stopAccelerometerUpdates];
}


@end
