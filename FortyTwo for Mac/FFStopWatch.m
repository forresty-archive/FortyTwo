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
@property (nonatomic) NSTimeInterval cumulatedTimeWhenLastPaused;
@property (nonatomic) NSTimeInterval resumedTimestamp;
@property (nonatomic) NSMutableArray *laps;

@end


@implementation FFStopWatch


- (NSTimeInterval)timeElapsed {
  @synchronized(self) {
    NSTimeInterval timeElapsed = self.cumulatedTimeWhenLastPaused;

    if (self.running) {
      timeElapsed += [NSDate timeIntervalSinceReferenceDate] - self.resumedTimestamp;
    }

    return timeElapsed;
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


# pragma mark - stop watch control


- (void)start {
  NSParameterAssert(self.running == NO);

  [self reset];
  [self resume];
}

- (void)resume {
  NSParameterAssert(self.running == NO);

  self.resumedTimestamp = [NSDate timeIntervalSinceReferenceDate];
  self.running = YES;
}

- (void)lap {
  NSParameterAssert(self.running == YES);

  [self.laps addObject:@(self.timeElapsed)];
  self.resumedTimestamp = [NSDate timeIntervalSinceReferenceDate];
  self.cumulatedTimeWhenLastPaused = 0;
}

- (void)pause {
  NSParameterAssert(self.running == YES);

  self.cumulatedTimeWhenLastPaused += [NSDate timeIntervalSinceReferenceDate] - self.resumedTimestamp;
  self.running = NO;
}

- (void)reset {
  self.laps = [NSMutableArray array];
  self.resumedTimestamp = [NSDate timeIntervalSinceReferenceDate];
  self.cumulatedTimeWhenLastPaused = 0;
  self.running = NO;
}


@end
