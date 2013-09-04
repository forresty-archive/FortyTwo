//
//  FFStopWatch.h
//  FortyTwo
//
//  Created by Forrest Ye on 9/4/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FFStopWatch : NSObject

@property (nonatomic, readonly) NSTimeInterval timeElapsed;

@property (nonatomic, readonly) NSMutableArray *laps;

- (void)start;

- (void)lap;

- (void)pause;

- (void)reset;

@end
