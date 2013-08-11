//
//  FTTUserObject.m
//  FortyTwo
//
//  Created by Forrest Ye on 8/11/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import "FTTUserObject.h"


@implementation FTTUserObject


- (void)resetPosition {
  self.position = CGPointMake(DeviceWidth() / 2, DeviceHeight() / 2);
}

@end
