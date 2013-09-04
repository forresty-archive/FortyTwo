//
//  FTTFrameManager.m
//  FortyTwo
//
//  Created by Forrest Ye on 9/4/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import "FTTFrameManager.h"


@interface FTTFrameManager ()

@property (nonatomic) NSUInteger frameRate;
@property (nonatomic) NSTimer *timer;

@end


@implementation FTTFrameManager

- (instancetype)initWithFrameRate:(NSUInteger)frameRate {
  self = [self init];

  if (self) {
    self.frameRate = frameRate;
    [self start];
  }

  return self;
}

- (void)start {
  self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0/self.frameRate target:self.delegate selector:@selector(frameManagerDidUpdateFrame) userInfo:nil repeats:YES];
}

- (void)pause {
  [self.timer invalidate];
}


@end
