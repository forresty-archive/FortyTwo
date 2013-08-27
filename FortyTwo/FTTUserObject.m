//
//  FTTUserObject.m
//  FortyTwo
//
//  Created by Forrest Ye on 8/11/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import "FTTUserObject.h"


@implementation FTTUserObject

static CGPoint defaultSpawnPosition;

+ (void)registerDefaultSpawnPosition:(CGPoint)position {
  defaultSpawnPosition = position;
}

- (void)resetPosition {
//  self.position = CGPointMake(DeviceWidth() / 2, DeviceHeight() / 2);
  self.position = defaultSpawnPosition;
}

@end
