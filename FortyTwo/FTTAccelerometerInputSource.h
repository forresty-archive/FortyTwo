//
//  FTTAccelerometerInputSource.h
//  FortyTwo
//
//  Created by Forrest Ye on 9/4/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <UIKit/UIKit.h>


@class FTTSpeedVector;


@interface FTTAccelerometerInputSource : UIResponder

@property (readonly) FTTSpeedVector *userSpeedVector;

- (void)start;

- (void)pause;

@end
