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
@property (nonatomic) NSMutableArray *laps;

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

- (NSTimeInterval)totalTimeElapsed {
  __block NSTimeInterval totalTimeElapsed = 0;

  [self.laps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    totalTimeElapsed += [obj doubleValue];
  }];

  totalTimeElapsed += self.timeElapsed;

  return totalTimeElapsed;
}

- (void)start {
  [self reset];
  self.running = YES;
}

- (void)lap {
  NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
  [self updateTimestampsWithTimeInterval:currentTime];
  [self.laps addObject:@(currentTime)];
  self.resumedTimestamp = currentTime;
  self.cumulatedElapsedTime = 0;
}

- (void)pause {
  [self updateTimestampsWithTimeInterval:[NSDate timeIntervalSinceReferenceDate]];
  self.running = NO;
}

- (void)reset {
  self.laps = [NSMutableArray array];
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
