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
  self.position = CGPointMake(self.deviceWidth / 2, self.deviceHeight / 2);
}


# pragma mark - private


- (NSUInteger)deviceWidth {
  return [UIScreen mainScreen].bounds.size.width;
}


- (NSUInteger)deviceHeight {
  return [UIScreen mainScreen].bounds.size.height;
}


@end
