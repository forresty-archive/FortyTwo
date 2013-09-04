//
//  FFStopWatch.m
//  FortyTwo
//
//  Created by Forrest Ye on 9/4/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import "FFStopWatch.h"


@interface FFStopWatch ()

@property (nonatomic) BOOL running;
@property (nonatomic) NSTimeInterval cumulatedElapsedTime;
@property (nonatomic) NSTimeInterval resumedTimestamp;

@end


@implementation FFStopWatch


- (NSTimeInterval)timeElapsed {
  @synchronized(self) {
    if (self.running) {
      [self updateTimestampsWithTimeInterval:[NSDate timeIntervalSinceReferenceDate]];
    }

    return self.cumulatedElapsedTime;
  }
}

- (void)start {
  [self reset];
  self.running = YES;
}

- (void)pause {
  [self updateTimestampsWithTimeInterval:[NSDate timeIntervalSinceReferenceDate]];
  self.running = NO;
}

- (void)reset {
  self.resumedTimestamp = [NSDate timeIntervalSinceReferenceDate];
  self.cumulatedElapsedTime = 0;
  self.running = NO;
}

- (void)updateTimestampsWithTimeInterval:(NSTimeInterval)timestamp {
  if (self.resumedTimestamp == 0) {
    self.resumedTimestamp = timestamp;
  }
  self.cumulatedElapsedTime = timestamp - self.resumedTimestamp;
}


@end
